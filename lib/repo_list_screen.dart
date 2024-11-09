import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'repo_detail_screen.dart';

class RepoListScreen extends StatefulWidget {
  @override
  _RepoListScreenState createState() => _RepoListScreenState();
}

class _RepoListScreenState extends State<RepoListScreen> {
  List<dynamic> repos = [];

  @override
  void initState() {
    super.initState();
    fetchRepos();
  }

  Future<void> fetchRepos() async {
    final response = await http.get(Uri.parse('https://api.github.com/gists/public'));
    if (response.statusCode == 200) {
      setState(() {
        repos = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load repos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = repos[index];
        return ListTile(
          title: Text(repo['description'] ?? 'No Description'),
          subtitle: Text('Created on: ${repo['created_at']}'),
          onLongPress: () {
            showOwnerInfoDialog(repo['owner']);
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RepoDetailScreen(repo)),
            );
          },
        );
      },
    );
  }

  void showOwnerInfoDialog(owner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(owner['login']),
          content: Text('Owner info goes here'),
        );
      },
    );
  }
}
