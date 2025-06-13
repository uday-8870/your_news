// home_screen.dart

import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService.fetchPosts();
  }

  void _showAddPostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add New Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: InputDecoration(labelText: 'Content')),
            TextField(controller: imageController, decoration: InputDecoration(labelText: 'Image URL')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ApiService.addPost(
                titleController.text,
                contentController.text,
                imageController.text,
              );
              Navigator.pop(context);
              setState(() {
                _postsFuture = ApiService.fetchPosts();
              });
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Way2News Clone')),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) { // Add error handling for better debugging
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No posts found'));

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.content),
                  leading: (post.imageUrl != null && post.imageUrl!.isNotEmpty) // Check for null first, then empty
                      ? Image.network(post.imageUrl!, width: 50, height: 50, fit: BoxFit.cover) // Use ! to assert non-null
                      : null, // You can put a placeholder image here instead of null
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}