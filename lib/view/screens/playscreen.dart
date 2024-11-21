import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/video_provider.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String channelName;
  final String des;

  const VideoPage({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.channelName,
    required this.des,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<VideoProvider>(context, listen: false)
          .initializePlayer(widget.videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<VideoProvider>(context);
    var providerFalse = Provider.of<VideoProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Light grey background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            providerTrue.chewieController != null &&
                providerTrue.videoPlayerController.value.isInitialized
                ? AspectRatio(
              aspectRatio:
              providerTrue.videoPlayerController.value.aspectRatio,
              child: Chewie(controller: providerTrue.chewieController!),
            )
                : Container(
              color: const Color(0xFF111827), // Dark grey fallback
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 10),

            // Video Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFF1F2937), // Black
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.channelName,
                    style: const TextStyle(
                      color: Color(0xFF6B7280), // Grey
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.des,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6B7280), // Grey
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.add_circle_outline, "Wishlist"),
                      _buildActionButton(Icons.share, "Share"),
                      _buildActionButton(Icons.thumb_up_alt, "Like"),
                      _buildActionButton(Icons.thumb_down_alt, "Dislike"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Related Videos Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Related Videos",
                style: TextStyle(
                  color: Color(0xFF1F2937), // Black
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Related Videos List
            Expanded(
              child: FutureBuilder(
                future: providerFalse.fetchApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasData) {
                    final videos = providerTrue.videoModal!.categories.first.videos
                        .where((video) =>
                    video.sources.first != widget.videoUrl)
                        .toList();

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VideoPage(
                                  videoUrl: video.sources.first,
                                  title: video.title,
                                  channelName: video.subtitle.name,
                                  des: video.description,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    video.thumb,
                                    height: 80,
                                    width: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF1F2937), // Black
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Channel Name • ${index + 1}M views',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280), // Grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.more_vert,
                                    color: Color(0xFF6B7280)), // Grey
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No related videos available',
                        style: TextStyle(
                          color: Color(0xFF1F2937), // Black
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00897B), size: 28), // Teal color
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1F2937), // Black
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
