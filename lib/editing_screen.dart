import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editing_flutter/constant.dart';
import 'package:video_editing_flutter/ffmpeg_edit.dart';
import 'package:video_editing_flutter/filter_screen.dart';
import 'package:video_editing_flutter/main.dart';
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
  String mainVideoPath;
  String audioPath;
  String directoryPath;
  String filterDirectoryPath;
  String soundDirectoryPath;
  String effectDirectoryPath;
  String speedDirectoryPath;
  String filterDisplayPath;
  String filterInputPath;
  String soundInputPath;

  List<ToolsModel> _tools = [
    ToolsModel(IconEffect, 'effect'),
    ToolsModel(IconFilter, 'filter'),
    ToolsModel(IconSpeed, 'speed'),
    ToolsModel(IconMusic, 'music'),
  ];

  @override
  void initState() {
    mainVideoPath = widget.file.path;
    soundInputPath = widget.file.path;

    generateDirectory();
    intializeVideoController(widget.file).then((_) {
      setState(() {
        videoPlayerController.play();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    videoPlayerController = null;
    super.dispose();
  }

  Future<void> intializeVideoController(File file) async {
    videoPlayerController = VideoPlayerController.file(file);
    videoPlayerController.initialize().then((_) {
      videoPlayerController.setLooping(true);
    });
  }

  void extractAllFrames() {}

  void generateDirectory() async {
    final Directory appDirectory = await getExternalStorageDirectory();
    final String path = '${appDirectory.path}/sample_video';
    directoryPath = path;
    filterDirectoryPath = '$path/filter';
    soundDirectoryPath = '$path/music';
    effectDirectoryPath = '$path/effect';
    speedDirectoryPath = '$path/speed';
    await Directory(path).exists().then((value) {
      if (value) {
        return;
      }
      Directory(directoryPath).create(recursive: true);
      Directory(filterDirectoryPath).create(recursive: true);
      Directory(soundDirectoryPath).create(recursive: true);
      Directory(effectDirectoryPath).create(recursive: true);
      Directory(speedDirectoryPath).create(recursive: true);
    });
  }

  void pickMusicFile() {
    FilePicker.getFile(type: FileType.audio).then((file) {
      if (file != null) {
        audioPath = file.path;
        String outputPath = '$soundDirectoryPath/add sound.mp4';
        setState(() {
          progressMessage = "Adding Audio...";
          isProgress = true;
        });
        FFmpegEdit.addAudioToVideo(soundInputPath, audioPath, outputPath)
            .then((value) {
          intializeVideoController(File(outputPath)).then((_) {
            if (isFilterAdded) {
              String outputPath2 = '$soundDirectoryPath/add sound2.mp4';
              FFmpegEdit.addAudioToVideo(mainVideoPath, audioPath, outputPath2)
                  .then((value) {
                setState(() {
                  isProgress = false;
                  videoPlayerController.play();
                  mainVideoPath = outputPath2;
                  widget.file = File(outputPath);
                  outputPath = "";
                });
              });
            } else {
              setState(() {
                isProgress = false;
                videoPlayerController.play();
                widget.file = File(outputPath);
                mainVideoPath = outputPath;
                outputPath = "";
              });
            }
          });
        });
      }
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
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      File(directoryPath).delete(recursive: true);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Yes')),
              ],
            ));
      },
      child: Scaffold(
          body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                ),
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
                              break;
                            case 'filter':
                              filterDisplayPath = widget.file.path;
                              filterInputPath = mainVideoPath;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FilterScreen(
                                          filterDisplayPath,
                                          filterInputPath,
                                          filterDirectoryPath))).then((value) {
                                String path = value;
                                isFilterAdded =
                                    path.contains('filter') ? true : false;
                                widget.file = File(path);
                                soundInputPath = path;
                                intializeVideoController(File(path))
                                    .then((value) {
                                  setState(() {
                                    videoPlayerController.play();
                                  });
                                });
                              });
                              break;
                            case 'music':
                              pickMusicFile();
                              break;
                            case 'speed':
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
        ],
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
