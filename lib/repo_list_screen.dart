import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'repo_detail_screen.dart';
import 'package:intl/intl.dart'; // For date formatting

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

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd – kk:mm').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Repositories'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: repos.length,
        itemBuilder: (context, index) {
          final repo = repos[index];
          return Card(
            color: Colors.white,
            shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(repo['owner']['avatar_url']),
              ),
              title: Text(
                repo['description'] ?? 'No Description',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Created on: ${formatDate(repo['created_at'])}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Last updated: ${formatDate(repo['updated_at'])}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
              onLongPress: () {
                showOwnerInfoDialog(repo['owner']);
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RepoDetailScreen(repo)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void showOwnerInfoDialog(owner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(owner['login']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(owner['avatar_url']),
                radius: 40,
              ),
              SizedBox(height: 10),
              Text('Owner Info'),
              Text(
                'Profile URL: ${owner['html_url']}',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        );
      },
    );
  }
}
