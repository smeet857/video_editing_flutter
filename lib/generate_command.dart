
import 'package:video_editing_flutter/util.dart';

class GenerateCommands{

  static String addAudioToVideo(String videoPath,String audioPath,String outputPath){
    return "-y -i ${Util.filterPath(videoPath)} -i ${Util.filterPath(audioPath)} -c:v copy -map 0:v:0 -map 1:a:0 -shortest ${Util.filterPath(outputPath)}";
  }
  static String addCurveFilterToVideo(String videoPath,String outputPath,String filterText){
    return "-i ${Util.filterPath(videoPath)} -filter_complex $filterText ${Util.filterPath(outputPath)}";
  }
  static String colorChannelMixer(String videoPath,String outputPath,String filterText){
    return "-i ${Util.filterPath(videoPath)} -filter_complex colorchannelmixer=$filterText -b:v 2000k -c:a copy ${Util.filterPath(outputPath)}";
  }
  static String changeSpeedToVideo(String videoPath,String outputPath){
    return "-i $videoPath -vf \"setpts=2*PTS\" -c:a copy $outputPath";
  }
  static String reverseVideoWithAudio(String videoPath,String outputPath){
    return "-y -i ${Util.filterPath(videoPath)} -vf reverse -af areverse -b:v 2000k ${Util.filterPath(outputPath)}";
  }
  static String changeSpeedWithAudio(String videoPath,String outputPath,String speed){
    return "-y -i ${Util.filterPath(videoPath)} -vf setpts=(1/$speed)*PTS -af atempo=$speed -b:v 2000k ${Util.filterPath(outputPath)}";
  }
  static String exportFramesByTime(String videoPath,String outputPath){
    return "-y -i ${Util.filterPath(videoPath)} -vf fps=1/1 ${Util.filterPath(outputPath)}";
  }
  static String changeSpeedWithTime(String videoPath,String outputPath,String firstPart,String secondPart,String thirdPart,String speed){
    return "-y -i ${Util.filterPath(videoPath)} -filter_complex \"[0:v]trim=$firstPart,setpts=PTS-STARTPTS[v1];[0:v]trim=$secondPart,setpts=PTS-STARTPTS[v2];[0:v]trim=start=$thirdPart,setpts=PTS-STARTPTS[v3];[0:a]atrim=$firstPart,asetpts=PTS-STARTPTS[a1];[0:a]atrim=$secondPart,asetpts=PTS-STARTPTS[a2];[0:a]atrim=start=$thirdPart,asetpts=PTS-STARTPTS[a3];[v2]setpts=PTS/$speed[slowv];[a2]atempo=$speed[slowa];[v1][a1][slowv][slowa][v3][a3]concat=n=3:v=1:a=1[v][a]\" -map \"[v]\" -map \"[a]\" -b:v 2000k ${Util.filterPath(outputPath)}";
  }
}