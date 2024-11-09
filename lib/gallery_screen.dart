import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'full_screen_image_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FullScreenImageScreen(image['urls']['full'])),
            );
          },
          child: Image.network(image['urls']['small']),
        );
      },
    );
  }
}
