import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player_app/view/screens/playscreen.dart';
import '../../provider/video_provider.dart';

class AhaHomePage extends StatefulWidget {
  @override
  _AhaHomePageState createState() => _AhaHomePageState();
}

class _AhaHomePageState extends State<AhaHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var videoProvider = Provider.of<VideoProvider>(context);
    var videoProviderNoListen = Provider.of<VideoProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B), // Teal color
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Handle profile tap
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 110),
              child: Text(
                "Video Player",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Handle search tap
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                // Handle notifications tap
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category Tabs
          _buildCategoryTabs(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Home Section
                FutureBuilder(
                  future: videoProviderNoListen.fetchApi(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerLoading();
                    } else if (snapshot.hasData) {
                      return _buildVideoList(videoProvider);
                    } else {
                      return const Center(
                        child: Text(
                          'No Data Available',
                          style: TextStyle(color: Colors.black87, fontSize: 18),
                        ),
                      );
                    }
                  },
                ),

                // Other Tabs
                _buildPlaceholderSection('Movies'),
                _buildPlaceholderSection('Originals'),
                _buildPlaceholderSection('Wishlist'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: const Color(0xFF00796B), // Dark teal
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          // color: const Color(0xFFFFA000), // Amber
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[300],
        isScrollable: true,
        tabs: const [
          Tab(text: 'Home'),
          Tab(text: 'Movies'),
          Tab(text: 'Originals'),
          Tab(text: 'Wishlist'),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade400,
          highlightColor: Colors.grey.shade200,
          child: Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoList(VideoProvider videoProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: videoProvider.videoModal?.categories.first.videos.length ?? 0,
      itemBuilder: (context, index) {
        final video = videoProvider.videoModal!.categories.first.videos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
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
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    video.thumb,
                    height: 100,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),

                // Video Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${video.subtitle.name} • ${index + 1}M views',
                        style:  TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '2 days ago',
                        style: TextStyle( fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // More Options
                Icon(Icons.more_vert, color: Colors.black87),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderSection(String sectionName) {
    return Center(
      child: Text(
        '$sectionName Section',
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black, // Dark teal
      selectedItemColor:  Colors.black45, // Amber
      unselectedItemColor: Colors.black,
      currentIndex: 0,
      onTap: (index) {
        // Handle bottom navigation tap
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
