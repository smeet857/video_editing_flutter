import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:video_editing_flutter/generate_command.dart';

class FFmpegEdit {
  static FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  
  static Future<void> addAudioToVideo(String videoPath,String audioPath,String outputPath) async {
    String command = GenerateCommands.addAudioToVideo(videoPath, audioPath, outputPath);
    await _flutterFFmpeg.execute(command);
  }
  static Future<void> colorChannelMixer(String videoPath,String outputPath,String filterText) async {
    String command = GenerateCommands.colorChannelMixer(videoPath, outputPath,filterText);
    await _flutterFFmpeg.execute(command);
  }
  static Future<void> reverseVideoWithAudio(String videoPath,String outputPath) async {
    String command = GenerateCommands.reverseVideoWithAudio(videoPath, outputPath);
    await _flutterFFmpeg.execute(command);
  }
  static Future<void> changeSpeedWithAudio(String videoPath,String outputPath,String speed) async {
    String command = GenerateCommands.changeSpeedWithAudio(videoPath, outputPath,speed);
    await _flutterFFmpeg.execute(command);
  }
  static Future<void> exportImageByTime(String videoPath,String outputPath) async {
    String command = GenerateCommands.exportFramesByTime(videoPath, outputPath);
    await _flutterFFmpeg.execute(command);
  }
  static Future<void> changeSpeedWithTime(String videoPath,String outputPath,String firstPart,String secondPart,String thirdPart,String speed) async {
    String command = GenerateCommands.changeSpeedWithTime(videoPath, outputPath,firstPart,secondPart,thirdPart,speed);
    await _flutterFFmpeg.execute(command);
  }
  static void cancelRunningCommand(){
    _flutterFFmpeg.cancel();
  }
}
