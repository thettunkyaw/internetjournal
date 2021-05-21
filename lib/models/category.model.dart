// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// CategoryModel Model Class
class CategoryModel {
  // Final Properties
  final String cateogryName;
  final int categoryNumber;
  final String imageUrl;

  // Constructor
  CategoryModel({
    @required this.cateogryName,
    @required this.categoryNumber,
    @required this.imageUrl,
  });
}
