import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_editing_flutter/change_speed_editing.dart';
import 'package:video_editing_flutter/constant.dart';
import 'package:video_editing_flutter/effect_editing.dart';
import 'package:video_editing_flutter/ffmpeg_edit.dart';
import 'package:video_editing_flutter/filter_screen.dart';
import 'package:video_editing_flutter/save_dialog.dart';
import 'package:video_editing_flutter/util.dart';
import 'package:video_player/video_player.dart';

import 'tools_model.dart';

class EditingScreen extends StatefulWidget {
  File file;

  EditingScreen(this.file);

  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  VideoPlayerController videoPlayerController;
  bool isProgress = false;
  bool isFilterAdded = false;
  String progressMessage = "";
  String soundFileName = "";
  String audioPath;
  String directoryPath;
  String changeSpeedDir;
  String exportFramesDir;
  String mainVideoPath;
  bool isSpeedChange = false;
  bool isFilterAdd = false;
  bool isMusicChanged = false;
  String saveDir;
  int videoDuration = 0;

  List<ToolsModel> _tools = [
    ToolsModel(IconEffect, 'effect'),
    ToolsModel(IconFilter, 'filter'),
    ToolsModel(IconSpeed, 'speed'),
    ToolsModel(IconMusic, 'music'),
  ];

  List<double> _activeColorFilter = [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];
  List<double> _defaultFilter = [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];

  @override
  void initState() {
    checkStoragePermission();
    generateDirectory();
    mainVideoPath = widget.file.path;
    intializeVideoController(widget.file);
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    videoPlayerController = null;
    super.dispose();
  }

  Future<void> checkStoragePermission() async {
    await Permission.storage.status.isGranted.then((value) {
      if (value) {
        return;
      }
      Permission.storage.request();
    });
  }

  Future<void> intializeVideoController(File file) async {
    videoPlayerController = VideoPlayerController.file(file);
    videoPlayerController.initialize().then((_) {
      videoPlayerController.setLooping(true);
      videoPlayerController.play();
      setState(() {});
    });
  }

  void extractAllFrames() {}

  Future<void> generateDirectory() async {
    final Directory appDirectory = await getExternalStorageDirectory();

    saveDir = '/storage/emulated/0/tiktokClone';
    print('path : ${appDirectory.path}');
    final String path = '${appDirectory.path}/sample_video';
    changeSpeedDir = '${appDirectory.path}/sample_video/change_speed';
    exportFramesDir = '${appDirectory.path}/sample_video/export_frames';
    directoryPath = path;

    Directory(directoryPath).create(recursive: true).then((value) {
      print('directory path: ${value.path}');
      Directory(changeSpeedDir).create(recursive: true).then((value) {
        print('changeSpeedDir: ${value.path}');
        Directory(saveDir).create(recursive: true).then((value) {
          print('saveDir: ${value.path}');
          Directory(exportFramesDir).create(recursive: true).then((value) {
            print('export frames dir: ${value.path}');
          });
        });
      });
    });
  }

  void pickMusicFile() {
    videoPlayerController.pause();
    FilePicker.getFile(type: FileType.audio).then((file) {
      if (file != null) {
        audioPath = file.path;
        String outputPath = '$directoryPath/add sound.mp4';
        setState(() {
          progressMessage = "Adding Audio...";
          isProgress = true;
        });
        FFmpegEdit.addAudioToVideo(widget.file.path, audioPath, outputPath)
            .then((value) {
          isProgress = false;
          mainVideoPath = outputPath;
          isMusicChanged = true;
          intializeVideoController(File(outputPath));
        });
        return;
      }
      videoPlayerController.play();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
            context: context,
            child: AlertDialog(
              title: Text('Are you sure to cancel editing'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, '');
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      File(directoryPath).delete(recursive: true);
                      Navigator.pop(context);
                      Navigator.pop(context, '');
                    },
                    child: Text('Yes')),
              ],
            ));
      },
      child: Scaffold(
          body: Builder(
        builder: (context) => Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(_activeColorFilter),
                      child: VideoPlayer(videoPlayerController)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 100,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            switch (_tools[index].name) {
                              case 'effect':
                                videoPlayerController.pause();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EffectEditing(
                                            mainVideoPath,
                                            exportFramesDir,
                                            _activeColorFilter))).then((value){
                                              videoPlayerController.play();
                                });
                                break;
                              case 'filter':
                                videoPlayerController.pause();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FilterScreen(
                                            File(mainVideoPath),
                                            _activeColorFilter))).then((value) {
                                  setState(() {
                                    List<double> _filter = value;
                                    if (_filter == _defaultFilter) {
                                      isFilterAdd = false;
                                    } else {
                                      isFilterAdd = true;
                                      _activeColorFilter = value;
                                    }
                                    videoPlayerController.play();
                                  });
                                });
                                break;
                              case 'music':
                                pickMusicFile();
                                break;
                              case 'speed':
                                videoPlayerController.pause();
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeSpeedEditing(
                                                    mainVideoPath,
                                                    changeSpeedDir,
                                                    _activeColorFilter)))
                                    .then((value) {
                                  String path = value;
                                  File file = File(path);
                                  if (path != '') {
                                    isSpeedChange = true;
                                    mainVideoPath = path;
                                    widget.file = file;
                                    intializeVideoController(File(path));
                                  } else {
                                    videoPlayerController.play();
                                  }
                                });
                                break;
                            }
                          },
                          child: ToolsView(_tools[index]));
                    },
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ],
            ),
            Visibility(
                visible: isProgress,
                child: showProgressDialogWithMessage(progressMessage)),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: FlatButton(
                  onPressed: () {
                    if (isFilterAdd || isMusicChanged || isSpeedChange) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SaveDialog();
                          }).then((value) {
                        String filename = value;
                        if (filename.isNotEmpty) {
                          setState(() {
                            progressMessage = 'Exporitng';
                            isProgress = true;
                            videoPlayerController.pause();
                          });
                          if (isFilterAdd) {
                            String outputPath = '$saveDir/$filename';
                            String filterText = Util.getColorChannelMixerFilter(
                                _activeColorFilter);
                            FFmpegEdit.colorChannelMixer(
                                    mainVideoPath, outputPath, filterText)
                                .then((_) {
                              Navigator.pop(context, outputPath);
                            });
                          }
                          File file = File(mainVideoPath);
                          String path = '$saveDir/$filename';
                          file.copy(path).then((value) {
                            setState(() {
                              progressMessage = '';
                              isProgress = false;
                            });
                            Navigator.pop(context, path);
                          });
                        }
                      });
                    } else {
                      Util.showSnackBar(context, 'No Changes');
                    }
                  },
                  color: Colors.red,
                  child: Text(
                    'Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class ToolsView extends StatelessWidget {
  final ToolsModel model;

  ToolsView(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      alignment: Alignment.center,
      color: Colors.black12,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            model.icon,
            height: 30,
            width: 30,
          ),
          SizedBox(
            height: 5,
          ),
          Text(model.name)
        ],
      ),
    );
  }
}
