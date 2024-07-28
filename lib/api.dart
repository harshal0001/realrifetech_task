import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model.dart';

class Api {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<PostModel>> getPosts(int page, int limit) async {
    final response =
        await http.get(Uri.parse('$baseUrl?_page=$page&_limit=$limit'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
