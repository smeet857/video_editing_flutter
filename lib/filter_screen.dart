import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_editing_flutter/filter_model.dart';
import 'package:video_editing_flutter/my_filters.dart';
import 'package:video_player/video_player.dart';

class FilterScreen extends StatefulWidget {
  final videoFile;
  final List<double> _previousFilter;

  FilterScreen(this.videoFile, this._previousFilter);

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
  List<double> _activeColorFilter;

  List<FilterModel> _list = [
    FilterModel(
      'Normal',
      FILTER_NORMAL,
      true
    ),
    FilterModel(
      'Black and white',
      FILTER_BLACK_AND_WHITE,
      false
    ),
    FilterModel(
      'Sepia',
      FILTER_SEPIA,
      false
    ),
    FilterModel(
      'Invert',
      FILTER_INVERT,
      false
    ),
    FilterModel(
      'Alpha Pink',
      FILTER_ALPHA_PINK,
      false
    ),
    FilterModel(
      'Alpha blue',
      FILTER_ALPHA_BLUE,
      false
    ),
    FilterModel(
      'Binary',
      FILTER_BINARY,
      false
    ),
    FilterModel(
      'Grey red bright',
        FILTER_GREY_RED_BRIGHT,
      false
    ),
    FilterModel(
        'Grey green bright',
        FILTER_GREY_GREEN_BRIGHT,
        false
    ),
    FilterModel(
        'Grey blue bright',
        FILTER_GREY_BLUE_BRIGHT,
        false
    ),
    FilterModel(
        'swap red to blue',
        FILTER_SWAP_RED_TO_BLUE,
        false
    ),
    FilterModel(
        'swap red to green',
        FILTER_SWAP_RED_TO_GREEN,
        false
    ),
    FilterModel(
        'Purple',
        FILTER_PURPLE,
        false
    ),
    FilterModel(
        'Cyan',
        FILTER_CYAN,
        false
    ),
    FilterModel(
        'Ywllow',
        FILTER_YELLOW,
        false
    ),
    FilterModel(
        'Old Times',
        FILTER_OLDTIMES,
        false
    ),
    FilterModel(
        'Cold Life',
        FILTER_COLD_LIFE,
        false
    ),
    FilterModel(
        'Sepium',
        FILTER_SEPIAM,
        false
    ),
    FilterModel(
        'Milk',
        FILTER_MILK,
        false
    ),
    FilterModel(
        'Filter 1',
        FILTER_1,
        false
    ),
    FilterModel(
        'Filter 2',
        FILTER_2,
        false
    ),
  ];

  void setSelected(){
    for(int i = 0;i<_list.length;i++){
      if(_list[i].filterMatrix == widget._previousFilter){
        _list[i].isSelect = true;
      }else{
        _list[i].isSelect = false;
      }
    }
  }
  @override
  void initState() {
    setSelected();
    _activeColorFilter = widget._previousFilter;
    intializeVideoController(widget.videoFile);
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> intializeVideoController(File file) async {
    videoPlayerController = VideoPlayerController.file(file);
    videoPlayerController.initialize().then((_) {
      videoPlayerController.setLooping(true);
      videoPlayerController.play();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return null;
      },
      child: Scaffold(
        body: Stack(
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
                  height: 180,
                  color: Colors.grey,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _activeColorFilter =
                                        _list[index].filterMatrix;
                                    for(int i = 0;i<_list.length;i++){
                                     if(i == index){
                                       _list[i].isSelect = true;
                                     }else{
                                      _list[i].isSelect = false;
                                     }
                                     setState(() {});
                                    }
                                  });
                                },
                                child: FilterTabView(_list[index]));
                          },
                          itemCount: _list.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context, widget._previousFilter);
                                },
                                child: Text('Cancel')),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context, _activeColorFilter);
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
      margin: EdgeInsets.all(5),
      decoration: filterModel.isSelect?BoxDecoration(
        border: Border.all(color: Colors.red,width: 3)
      ):null,
      child: Column(
        children: [
          ColorFiltered(
              colorFilter: ColorFilter.matrix(filterModel.filterMatrix),
              child: Image.asset(
                'assets/images/model.jpg',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 5,
          ),
          Text(filterModel.name)
        ],
      ),
    );
  }
}
