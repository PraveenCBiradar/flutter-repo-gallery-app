import 'package:flutter/material.dart';

class RepoDetailScreen extends StatelessWidget {
  final dynamic repo;

  RepoDetailScreen(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(repo['description'] ?? 'Repo Details')),
      body: Center(
        child: Text('Here you can list the files of this repo.'),
      ),
    );
  }
}
