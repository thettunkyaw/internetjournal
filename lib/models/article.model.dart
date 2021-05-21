// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// ArticleModel Model Class
class ArticleModel {
  // Final Properties
  final int id;
  final String date;
  final String title;
  final String description;
  final String content;
  final String imageLink;
  final String articleLink;
  final String categoryName;

  // Constructor
  ArticleModel({
    @required this.id,
    @required this.date,
    @required this.title,
    @required this.description,
    @required this.content,
    @required this.imageLink,
    @required this.articleLink,
    @required this.categoryName,
  });

  // To convert to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": this.id,
      "date": this.date,
      "title": this.title,
      "description": this.description,
      "content": this.content,
      "imageLink": this.imageLink,
      "articleLink": this.articleLink,
      "categoryName": this.categoryName,
    };
    return map;
  }

  // To convert from JSON
  ArticleModel.fromJson(Map<String, dynamic> json)
      : this.id = json["id"],
        this.date = json["date"],
        this.title = json["title"],
        this.description = json["description"],
        this.content = json["content"],
        this.imageLink = json["imageLink"],
        this.articleLink = json["articleLink"],
        this.categoryName = json["categoryName"];

  // return ArticleModel(
  //   id: json["id"],
  //   date: json["date"],
  //   title: json["date"],
  //   description: json["description"],
  //   content: json["content"],
  //   imageLink: json["imageLink"],
  //   articleLink: json["articleLink"],
  //   categoryName: json["categoryName"],
  // );
  // }
}
