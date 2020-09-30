import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_editing_flutter/editing_screen.dart';
import 'package:video_editing_flutter/util.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context){
          return Center(
            child: FlatButton(onPressed: (){
              FilePicker.getFile(type: FileType.video).then((file){
                if(file != null){
                  print('Selected File path ===> ${file.path}');
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditingScreen(file))).then((value){
                    String respons = value;
                    if(respons != ''){
                      Util.showSnackBar(context, 'Video is saved on $respons');
                    }
                  });
                }
              });
            }, child: Text('Select Video from internal storage',style: TextStyle(color: Colors.black),),
              color: Colors.grey,),
          );
        },
      ),
    );
  }
}
