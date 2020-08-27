import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:video_editing_flutter/generate_command.dart';

class FFmpegEdit {
  static FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  
  static Future<void> addAudioToVideo(String videoPath,String audioPath,String outputPath) async {
    String command = GenerateCommands.addAudioToVideo(videoPath, audioPath, outputPath);
    await _flutterFFmpeg.execute(command);
  }
  static Future<void> addCurveFilterToVideo(String videoPath,String outputPath,String filterText) async {
    String command = GenerateCommands.addCurveFilterToVideo(videoPath, outputPath,filterText);
    await _flutterFFmpeg.execute(command);
  }
}
