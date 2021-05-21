// Models
import '../models/category.model.dart';

// DataHelper Helper Class
class DataHelper {
  // Normal Properties
  List<CategoryModel> _categoriesList = [
    CategoryModel(
      cateogryName: 'Article',
      categoryNumber: 14,
      imageUrl: 'assets/images/Categories/Article.jpg',
    ),
    CategoryModel(
      cateogryName: 'Review',
      categoryNumber: 12,
      imageUrl: 'assets/images/Categories/Review.jpg',
    ),
    CategoryModel(
      cateogryName: 'Camera',
      categoryNumber: 41,
      imageUrl: 'assets/images/Categories/Camera.jpg',
    ),
    CategoryModel(
      cateogryName: 'Gadget',
      categoryNumber: 13,
      imageUrl: 'assets/images/Categories/Gadgets.jpg',
    ),
    CategoryModel(
      cateogryName: 'Game',
      categoryNumber: 44,
      imageUrl: 'assets/images/Categories/Game.jpg',
    ),
    CategoryModel(
      cateogryName: 'Laptop',
      categoryNumber: 16,
      imageUrl: 'assets/images/Categories/Laptop.jpg',
    ),
    CategoryModel(
      cateogryName: 'Mobile',
      categoryNumber: 11, // 4, 46
      imageUrl: 'assets/images/Categories/Mobile.jpg',
    ),
    CategoryModel(
      cateogryName: 'Tablet',
      categoryNumber: 42,
      imageUrl: 'assets/images/Categories/Tablet.jpg',
    ),
    CategoryModel(
      cateogryName: 'How to',
      categoryNumber: 45,
      imageUrl: 'assets/images/Categories/HowTo.jpg',
    ),
    CategoryModel(
      cateogryName: 'IJ Podcast',
      categoryNumber: 185,
      imageUrl: 'assets/images/Categories/Podcast.jpg',
    ),
    // CategoryModel(
    //   cateogryName: 'Live Blog',
    //   categoryNumber: 179,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1519337265831-281ec6cc8514?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2100&q=80',
    // ),
    // CategoryModel(
    //   cateogryName: 'Mini Newspaper',
    //   categoryNumber: 178,
    //   imageUrl: 'assets/images/Categories/MiniNewspaper.jpg',
    // ),
  ];

  // Get Method
  List<CategoryModel> get getCategoriesList {
    return [...this._categoriesList];
  }
}
