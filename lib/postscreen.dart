import 'package:flutter/material.dart';
import 'package:flutter_application_1/api.dart';
import 'package:flutter_application_1/model.dart';
import 'package:flutter_application_1/postdetails.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final Api _api = Api();
  List<PostModel> _posts = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final int _postsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final newPosts = await _api.getPosts(_currentPage, _postsPerPage);
      setState(() {
        _posts.addAll(newPosts);
        _currentPage++;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: ListView.builder(
        itemCount: _posts.length + 1,
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox();
          } else {
            final post = _posts[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostDetailsScreen(postId: post.id),
                ));
              },
              child: Card(
                elevation: 1.0,
                child: ListTile(
                  title: Text(post.title),
                ),
              ),
            );
          }
        },
        controller: ScrollController()..addListener(_scrollListener),
      ),
    );
  }

  void _scrollListener() {
    if (_isLoading) return;

    if (ScrollController().position.pixels ==
        ScrollController().position.maxScrollExtent) {
      _fetchPosts();
    }
  }
}
