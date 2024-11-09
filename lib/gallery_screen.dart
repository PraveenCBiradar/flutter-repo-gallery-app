import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'full_screen_image_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> images = [];
  Set<String> bookmarkedImages = Set();

  @override
  void initState() {
    super.initState();
    fetchImages();
    loadBookmarks();
  }

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse('https://api.unsplash.com/photos?client_id=XAYbq3sS__J8FWhhe7ASqgJIdes1BW3x1g3Qn9MKZn4'));
    if (response.statusCode == 200) {
      setState(() {
        images = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedImages = prefs.getStringList('bookmarkedImages')?.toSet() ?? Set();
    });
  }

  Future<void> toggleBookmark(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (bookmarkedImages.contains(imageUrl)) {
        bookmarkedImages.remove(imageUrl);
      } else {
        bookmarkedImages.add(imageUrl);
      }
      prefs.setStringList('bookmarkedImages', bookmarkedImages.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen(bookmarkedImages.toList())),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          final imageUrl = image['urls']['small'];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImageScreen(image['urls']['full']),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      bookmarkedImages.contains(imageUrl) ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => toggleBookmark(imageUrl),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BookmarkScreen extends StatelessWidget {
  final List<String> bookmarkedImages;
  BookmarkScreen(this.bookmarkedImages);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Images'),
        backgroundColor: Colors.deepPurple,
      ),
      body: bookmarkedImages.isNotEmpty
          ? GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: bookmarkedImages.length,
        itemBuilder: (context, index) {
          final imageUrl = bookmarkedImages[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FullScreenImageScreen(imageUrl)),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: Text(
          'No bookmarks yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
