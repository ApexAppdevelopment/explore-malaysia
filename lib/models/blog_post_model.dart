import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPost {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final String featuredImage;
  final String author;
  final String authorAvatar;
  final List<String> categories;
  final List<String> tags;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.featuredImage,
    required this.author,
    required this.authorAvatar,
    required this.categories,
    required this.tags,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'].toString(),
      title: json['title']['rendered'] ?? '',
      content: json['content']['rendered'] ?? '',
      excerpt: json['excerpt']['rendered'] ?? '',
      featuredImage: json['_embedded']?['wp:featuredmedia']?[0]?['source_url'] ?? '',
      author: json['_embedded']?['author']?[0]?['name'] ?? '',
      authorAvatar: json['_embedded']?['author']?[0]?['avatar_urls']?['96'] ?? '',
      categories: (json['_embedded']?['wp:term']?[0] as List<dynamic>? ?? [])
          .map((category) => category['name'].toString())
          .toList(),
      tags: (json['_embedded']?['wp:term']?[1] as List<dynamic>? ?? [])
          .map((tag) => tag['name'].toString())
          .toList(),
      commentCount: json['comment_count'] ?? 0,
      createdAt: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['modified'] ?? DateTime.now().toIso8601String()),
    );
  }

  factory BlogPost.fromFirestore(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'] ?? '',
      featuredImage: json['featuredImage'] ?? '',
      author: json['author'] ?? '',
      authorAvatar: json['authorAvatar'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      commentCount: json['commentCount'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'featuredImage': featuredImage,
      'author': author,
      'authorAvatar': authorAvatar,
      'categories': categories,
      'tags': tags,
      'commentCount': commentCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
