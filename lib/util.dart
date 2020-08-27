class Util{

  static String filterPath(String path){
    List<String> splitPath = path.split("/");
    splitPath.removeAt(0);
    String finalPath = "/";
    for(int i = 0; i <splitPath.length;i++){
      if(splitPath[i].contains(" ")){
        splitPath[i] = splitPath[i].replaceAll(splitPath[i], "\"${splitPath[i]}\"");
      }
      finalPath = finalPath + splitPath[i];
      if(i+1 != splitPath.length){
        finalPath = finalPath + "/";
      }
    }
    return finalPath;
  }
}