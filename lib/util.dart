import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Util {
  static String filterPath(String path) {
    List<String> splitPath = path.split("/");
    splitPath.removeAt(0);
    String finalPath = "/";
    for (int i = 0; i < splitPath.length; i++) {
      if (splitPath[i].contains(" ")) {
        splitPath[i] =
            splitPath[i].replaceAll(splitPath[i], "\"${splitPath[i]}\"");
      }
      finalPath = finalPath + splitPath[i];
      if (i + 1 != splitPath.length) {
        finalPath = finalPath + "/";
      }
    }
    return finalPath;
  }

  static String getColorChannelMixerFilter(List<double> filter) {
    String code = '';

    for(int i = 0;i< filter.length;i++){
      if(i != 4 && i != 9 && i != 14 && i != 19){
        code = code + filter[i].toString();
        if(i != 18){
          code = code + ':';
        }
      }
    }
    print('remove filter $code');
    return code;
  }

  static showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 3),
    ));
  }
}
