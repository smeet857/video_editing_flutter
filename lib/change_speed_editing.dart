import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:video_editing_flutter/ffmpeg_edit.dart';
import 'package:video_editing_flutter/speed_tools_model.dart';
import 'package:video_player/video_player.dart';

class ChangeSpeedEditing extends StatefulWidget {
  final videoPath;
  final dir;
  final filter;

  ChangeSpeedEditing(this.videoPath, this.dir, this.filter);

  @override
  _ChangeSpeedEditingState createState() => _ChangeSpeedEditingState();
}

class _ChangeSpeedEditingState extends State<ChangeSpeedEditing> {
  VideoPlayerController _controller;
  bool isProgress = false;
  String progressMessage = "";
  String convertedPath;
  bool isChanges = false;
  bool isExport = true;
  double videoDuration = 100;
  List<File> _exportFiles = [];
  double _exportImageWidth;
  String exportedDir = '';
  RangeValues rangeValues = RangeValues(0, 100);
  RangeLabels rangeLabels = RangeLabels('0', '100');

  List<SpeedToolsModel> _list = [
    SpeedToolsModel(Icons.slow_motion_video, 'Slow Motion'),
    SpeedToolsModel(Icons.fast_forward, 'Fast Motion'),
    SpeedToolsModel(Icons.fast_rewind, 'Reverse'),
  ];

  Future<void> initializeVideoController(File file) async {
    _controller = VideoPlayerController.file(file);
    _controller.setLooping(true);
    _controller.initialize().then((_) {
      _controller.play();
      videoDuration = _controller.value.duration.inSeconds.toDouble();
      rangeValues = RangeValues(0, videoDuration);
      rangeLabels = RangeLabels('0', videoDuration.toString());
      setState(() {});
    });
  }

  @override
  void initState() {
    initializeVideoController(File(widget.videoPath));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void applyReverseVideo() {
    setState(() {
      isProgress = true;
      progressMessage = 'Reverse....';
    });
    String outputPath = '${widget.dir}/reverse.mp4';
    print('output path : $outputPath');
    FFmpegEdit.reverseVideoWithAudio(widget.videoPath, outputPath).then((_) {
      _controller.pause();
      isProgress = false;
      isChanges = true;
      convertedPath = outputPath;
      initializeVideoController(File(outputPath));
    });
  }

  void applyFastMotionVideo() {
    setState(() {
      isProgress = true;
      progressMessage = 'FastMotion....';
    });
    String outputPath = '${widget.dir}/fast_motion.mp4';
    print('output path : $outputPath');
    FFmpegEdit.changeSpeedWithAudio(widget.videoPath, outputPath, '4.0')
        .then((_) {
      _controller.pause();
      isProgress = false;
      isChanges = true;
      convertedPath = outputPath;
      initializeVideoController(File(outputPath));
    });
  }

  void applySlowMotionVideo() {
    setState(() {
      isProgress = true;
      progressMessage = 'SlowMotion....';
    });
    String outputPath = '${widget.dir}/slow_motion.mp4';
    print('output path : $outputPath');
    FFmpegEdit.changeSpeedWithAudio(widget.videoPath, outputPath, '0.5')
        .then((_) {
      _controller.pause();
      isProgress = false;
      isChanges = true;
      convertedPath = outputPath;
      initializeVideoController(File(outputPath));
    });
  }
  void applyChangeSpeedWithTime(String speed) {
    setState(() {
      isProgress = true;
      progressMessage = 'SlowMotion....';
    });
    String folderName = speed == '0.5'?'slow':'fast';
    String outputPath = '${widget.dir}/$folderName.mp4';
    print('output path : $outputPath');
    String firstPart = '0:${rangeValues.start.toInt()}';
    String secondPart = '${rangeValues.start.toInt()}:${rangeValues.end.toInt()}';
    String thirdPart = '${rangeValues.end.toInt()}';
    print('first part : $firstPart');
    print('second part : $secondPart');
    print('third part : $thirdPart');
    FFmpegEdit.changeSpeedWithTime(widget.videoPath, outputPath, firstPart,secondPart,thirdPart,speed)
        .then((_) {
      _controller.pause();
      isProgress = false;
      isChanges = true;
      convertedPath = outputPath;
      initializeVideoController(File(outputPath));
    });
  }

  Widget showProgressDialogWithMessage(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 16,
          ),
          Text(message, style: TextStyle(fontSize: 16, color: Colors.black))
        ],
      ),
    );
  }

  double previousStartValue = 0.0;
  double previousEndValue = 0.0;
  int firstPart = 0;
  int secondPart = 0;
  int thirdPart = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return null;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                ColorFiltered(
                    colorFilter: ColorFilter.matrix(widget.filter),
                    child: VideoPlayer(_controller)),
                Visibility(
                    visible: isProgress,
                    child: showProgressDialogWithMessage(progressMessage)),
              ],
            )),
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex:1,
                    child: RangeSlider(
                        min: 0,
                        max: videoDuration,
                        labels:rangeLabels,
                        divisions: videoDuration.toInt(),
                        values: rangeValues,
                        onChangeStart: (value){
                          setState(() {
                            previousStartValue = value.start;
                            previousEndValue = value.end;
                          });
                        },
                        onChangeEnd: (value){
                          setState(() {
                            previousEndValue = value.end;
                            previousStartValue = value.start;
                          });
                        },
                        onChanged: (values) {
                          setState(() {
                            print('start ${values.start} : End ${values.end}');
                            rangeValues = values;
                            rangeLabels = RangeLabels(values.start.toString(), values.end.toString());
                            if(values.start != previousStartValue){
                              _controller.seekTo(Duration(seconds: values.start.toInt()));
                            }
                            if(values.end != previousEndValue){
                              _controller.seekTo(Duration(seconds: values.end.toInt()));
                            }
                          });
                        }),
                  ),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _list.map((model) {
                          return GestureDetector(
                            onTap: (){
                              switch(model.name){
                                case'Slow Motion':
                                  applyChangeSpeedWithTime('0.5');
                                  break;
                                case'Fast Motion':
                                  applyChangeSpeedWithTime('3.0');
                                  break;
                                case'Reverse':
                                  applyReverseVideo();
                                    break;
                              }
                            },
                              child: ToolsView(model));
                        }).toList(),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                            onPressed: () {
                              FFmpegEdit.cancelRunningCommand();
                              Navigator.pop(context, '');
                            },
                            child: Text('Cancel')),
                        FlatButton(
                            onPressed: () {
                              if (isChanges) {
                                Navigator.pop(context, convertedPath);
                              }
                            },
                            child: Text('Ok')),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ToolsView extends StatefulWidget {
  final SpeedToolsModel model;

  ToolsView(this.model);

  @override
  _ToolsViewState createState() => _ToolsViewState();
}

class _ToolsViewState extends State<ToolsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 45,
            width: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.black)),
            child: Icon(widget.model.icon),
          ),
          SizedBox(
            height: 5,
          ),
          Text(widget.model.name),
        ],
      ),
    );
  }
}
