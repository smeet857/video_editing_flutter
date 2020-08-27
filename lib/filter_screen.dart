import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_editing_flutter/constant.dart';
import 'package:video_editing_flutter/ffmpeg_edit.dart';
import 'package:video_editing_flutter/filter_model.dart';
import 'package:video_player/video_player.dart';

class FilterScreen extends StatefulWidget {

  final String displayPath;
  final String directoryPath;
  final String inputPath;

  FilterScreen(this.displayPath,this.inputPath,this.directoryPath);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  VideoPlayerController videoPlayerController;
  bool isProgress = false;
  String progressMessage = "";
  String outputPath = "";
  String testedDirectory;
  String finalPath;
  String finalName;

  List<FilterModel> _list = [
    FilterModel(IconFilter, 'Cross Process','curves=preset=cross_process'),
    FilterModel(IconFilter, 'Darker','curves=preset=darker'),
    FilterModel(IconFilter, 'Lighter','curves=preset=lighter'),
    FilterModel(IconFilter, 'Vintage','curves=preset=vintage'),
    FilterModel(IconFilter, 'Strong Contrast','curves=preset=strong_contrast'),
    FilterModel(IconFilter, 'Medium Contrast','curves=preset=medium_contrast'),
    FilterModel(IconFilter, 'Linear Contrast','curves=preset=linear_contrast'),
    FilterModel(IconFilter, 'Increase Contrast','curves=preset=increase_contrast'),
    FilterModel(IconFilter, 'Color Negative','curves=preset=color_negative'),
    FilterModel(IconFilter, 'Negative','curves=preset=negative'),
    FilterModel(IconFilter, 'Black And White','hue=s=0'),
    FilterModel(IconFilter, 'Saturation Light Repeate',"hue=\"H=3*PI*t: s=sin(3*PI*t)+1\""),
  ];
  @override
  void initState() {
    testedDirectory = '${widget.directoryPath}/tested';
   File(testedDirectory).exists().then((value){
     if(!value){
       Directory(testedDirectory).create(recursive: true);
       return;
     }
     return;
   });
    intializeVideoController(File(widget.displayPath)).then((_){
      setState(() {
        videoPlayerController.play();
      });
    });
    super.initState();
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
          Text(message, style: TextStyle(fontSize: 16, color: Colors.white))
        ],
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    videoPlayerController = null;
    super.dispose();
  }

  Future<void> intializeVideoController(File file) async{
    videoPlayerController = VideoPlayerController.file(file);
    videoPlayerController.initialize().then((_) {
      videoPlayerController.setLooping(true);
    });
  }

  void applyFilter(String filterText,String filterName){
    setState(() {
      progressMessage = "Apply Filter...";
      isProgress = true;
    });
    String outputPath = "$testedDirectory/$filterName.mp4";
    FFmpegEdit.addCurveFilterToVideo(widget.inputPath, outputPath, filterText).then((value){
      intializeVideoController(File(outputPath)).then((value){
        setState(() {
          isProgress = false;
          finalPath = outputPath;
          finalName = '$filterText.mp4';
          videoPlayerController.play();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async{
        return null;
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
                height: 150,
                color: Colors.grey,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(itemBuilder: (context,index){
                        return GestureDetector(onTap:(){
                          applyFilter(_list[index].filterText,_list[index].name);
                        },
                            child: FilterTabView(_list[index]));
                      },
                        itemCount: _list.length,
                      scrollDirection: Axis.horizontal,),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(onPressed: (){
                            File(testedDirectory).delete(recursive: true).then((value){
                              Navigator.pop(context,widget.displayPath);
                            });
                          }, child: Text('Cancel')),
                          FlatButton(onPressed: (){
                            String newPath = '${widget.directoryPath}/$finalName';
                            File(finalPath).copy(newPath).then((value){
                              File(testedDirectory).delete(recursive: true).then((value){
                                Navigator.pop(context,newPath);
                              });
                            });
                          }, child: Text('Ok')),
                        ],
                      ),
                    )
                  ],
                ),
              )
              ],
            ),
            Visibility(
              child: showProgressDialogWithMessage(progressMessage),
              visible: isProgress,
            )
          ],
        ),
      ),
    );
  }
}

class FilterTabView extends StatelessWidget {

  final FilterModel filterModel;
  FilterTabView(this.filterModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Image.asset(filterModel.image,height: 30,width: 30,),
          SizedBox(height: 5,),
          Text(filterModel.name)
        ],
      ),
    );
  }
}
