
import 'package:video_editing_flutter/util.dart';

class GenerateCommands{

  static String addAudioToVideo(String videoPath,String audioPath,String outputPath){
    return "-i ${Util.filterPath(videoPath)} -i ${Util.filterPath(audioPath)} -c:v copy -map 0:v:0 -map 1:a:0 -shortest -y ${Util.filterPath(outputPath)}";
  }
  static String addCurveFilterToVideo(String videoPath,String outputPath,String filterText){
    return "-i ${Util.filterPath(videoPath)} -filter_complex $filterText -b:v 1M ${Util.filterPath(outputPath)}";
  }
  static String changeSpeedToVideo(String videoPath,String outputPath){
    return "-i $videoPath vf \"setpts=0.5*PTS\" -c:a copy $outputPath";
  }
}