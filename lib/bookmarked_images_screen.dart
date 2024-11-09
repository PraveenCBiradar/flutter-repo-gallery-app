import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkedImagesScreen extends StatefulWidget {
  @override
  _BookmarkedImagesScreenState createState() => _BookmarkedImagesScreenState();
}

class _BookmarkedImagesScreenState extends State<BookmarkedImagesScreen> {
  List<String> bookmarks = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarks = prefs.getStringList('bookmarks') ?? [];
    });
  }

  Future<void> saveBookmark(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    bookmarks.add(imageUrl);
    await prefs.setStringList('bookmarks', bookmarks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Image.network(bookmarks[index]),
        );
      },
    );
  }
}
