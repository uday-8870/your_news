import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000";

  // Login bypassed: always returns a dummy token
  static Future<String?> login(String email, String password) async {
    return 'demo_token'; // Bypassed login
  }
static Future<void> addPost(String title, String content, String imageUrl) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/add_post'), // Or your actual endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      print('Failed to add post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error adding post: $e');
  }
}

  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        print('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return [];
  }
}
