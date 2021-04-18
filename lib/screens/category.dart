import 'package:flutter/material.dart';
import 'package:unsplash_final_project/models/mainPhotos_model.dart';
import 'package:unsplash_final_project/services/photo.dart';
import 'package:unsplash_final_project/widgets/widget.dart';

class Category extends StatefulWidget {
  final String categoryName;
  Category({this.categoryName});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int pageNumber = 1;
  Photo photo = Photo();
  ScrollController _scrollController = new ScrollController();
  List<MainPhotosModel> photosByCategory = [];
  var loading = false;

  getPhotosByCategory(String categoryName) async {
    setState(() {
      loading = true;
    });
    var data = await photo.getPhotosByCategory(categoryName, pageNumber);
    setState(() {
      for (Map i in data) {
        photosByCategory.add(MainPhotosModel.fromJson(i));
      }
      loading = false;
    });
  }

  @override
  void initState() {
    getPhotosByCategory(widget.categoryName);
    // Load next page when user scrolls to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          pageNumber++;
        });
        getPhotosByCategory(widget.categoryName);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.categoryName,
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 16),
            Container(
              child: Expanded(
                child: mainPhotosList(
                    photosByCategory, context, _scrollController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
