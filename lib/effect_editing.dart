
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_editing_flutter/effect_model.dart';
import 'package:video_player/video_player.dart';

class EffectEditing extends StatefulWidget {

  final videoPath;
  final exportFramePath;
  final filterScreen;

  EffectEditing(this.videoPath, this.exportFramePath, this.filterScreen);

  @override
  _EffectEditingState createState() => _EffectEditingState();
}

class _EffectEditingState extends State<EffectEditing> {

  VideoPlayerController videoPlayerController;

  List<EffectModel> _list = [
    EffectModel('image', 'Edge Detection'),
    EffectModel('image', 'Rgb Edge Detection'),
    EffectModel('image', 'Lighting up'),
    EffectModel('image', 'Motion blur')
  ];

  Future<void> intializeVideoController(File file) async {
    videoPlayerController = VideoPlayerController.file(file);
    videoPlayerController.initialize().then((_) {
      videoPlayerController.setLooping(true);
      videoPlayerController.play();
      setState(() {});
    });
  }

  @override
  void initState() {
    intializeVideoController(File(widget.videoPath));
    super.initState();
  }
  @override
  void dispose() {
    videoPlayerController.dispose();
    videoPlayerController = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(child: VideoPlayer(videoPlayerController)),
          Container(
            height: 200,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context,index){
                    return EffectToolsView(_list[index]);
                  },itemCount: _list.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(onPressed: (){}, child: Text('Cancel')),
                    FlatButton(onPressed: (){}, child: Text('ok')),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EffectToolsView extends StatefulWidget {
  final EffectModel model;

  EffectToolsView(this.model);

  @override
  _EffectToolsViewState createState() => _EffectToolsViewState();
}

class _EffectToolsViewState extends State<EffectToolsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset('assets/icon/effect.png'),
          SizedBox(height: 10,),
          Text(widget.model.name)
        ],
      ),
    );
  }
}
