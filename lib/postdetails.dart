import 'package:flutter/material.dart';
import 'package:flutter_application_1/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ... (Make sure you have the same Post class definition here as well) ...

class PostDetailsScreen extends StatelessWidget {
  final int postId;
  const PostDetailsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Details")),
      body: FutureBuilder<PostModel>(
        future: _fetchPostDetails(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final post = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(post.body),
                ],
              ),
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }

  Future<PostModel> _fetchPostDetails(int postId) async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post details');
    }
  }
}
