import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../api_helper/api_helper.dart';
import '../modal/video_modal.dart';



class VideoProvider extends ChangeNotifier
{
  VideoModal? videoModal;
  ApiHelper helper = ApiHelper();

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  Future<VideoModal?> fetchApi()
  async {
    final data = await helper.fetchApi();
    videoModal = VideoModal.fromJson(data);
    return videoModal;
  }

  Future<void> videoControllerInitializer(String videoUrl) async {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        videoUrl.split('http').join('https'),
      ),
    );
    await videoPlayerController.initialize();
  }

  Future<void> initializePlayer(String videoUrl) async {
    await videoControllerInitializer(videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white.withOpacity(0.5),
      ),
    );
    notifyListeners();
  }

  VideoProvider()
  {
    fetchApi();
  }
}