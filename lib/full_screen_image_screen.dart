import 'package:flutter/material.dart';

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  FullScreenImageScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Full Image')),
      body: InteractiveViewer(
        child: Image.network(imageUrl),
      ),
    );
  }
}
