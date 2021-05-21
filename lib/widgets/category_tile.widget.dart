// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Screens
import '../pages/category.page.dart';

// CategoryTileWidget StatelessWidget Class
class CategoryTileWidget extends StatelessWidget {
  // Final Properties
  final String imageUrl;
  final String categoryName;

  // Normal Class Properties
  double width;
  double height;

  // Constructor
  CategoryTileWidget({
    @required this.imageUrl,
    @required this.categoryName,
  });

  // Build Method
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if(size.width >= 1000) {
      width = 250;
      height = 110;
    } else {
      width = 130;
      height = 65;
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          CategoryPage.routeName,
          arguments: this.categoryName,
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 10,
        ),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                this.imageUrl,
                width: this.width,
                height: this.height,
                fit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: this.width,
                height: this.height,
                alignment: Alignment.center,
                color: Colors.black26,
                child: Text(
                  this.categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
