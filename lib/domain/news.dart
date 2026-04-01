import 'package:flutter/material.dart';

class News {
  final String id;
  final String title;
  final String content;
  final String category;
  final String author;
  final String date;
  final String readTime;
  final String imageUrl;
  final Color categoryColor;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.author,
    required this.date,
    required this.readTime,
    required this.imageUrl,
    required this.categoryColor,
  });
}
