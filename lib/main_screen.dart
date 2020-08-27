import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_editing_flutter/editing_screen.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(onPressed: (){
          FilePicker.getFile(type: FileType.video).then((file){
            if(file != null){
              print('Selected File path ===> ${file.path}');
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditingScreen(file)));
            }
          });
        }, child: Text('Select Video from internal storage',style: TextStyle(color: Colors.black),),
        color: Colors.grey,),
      ),
    );
  }
}
