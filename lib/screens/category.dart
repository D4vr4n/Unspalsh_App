import 'package:flutter/material.dart';
import 'package:unsplash_final_project/models/mainPhotos_model.dart';
import 'package:unsplash_final_project/widgets/widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animations/loading_animations.dart';

class Category extends StatefulWidget {
  final String categoryName;
  Category({this.categoryName});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<MainPhotosModel> photosByCategory = [];
  var loading = false;

  getPhotosByCategory(String category) async {
    setState(() {
      loading = true;
    });
    final responseData = await http.get("https://api.unsplash.com/topics/" +
        category +
        "/photos?per_page=20&client_id=jLFnRsQ2GjVdKeacMPBjycuBhuqYqyZStxxWH8TccGE");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      setState(() {
        for (Map i in data) {
          photosByCategory.add(MainPhotosModel.fromJson(i));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getPhotosByCategory(widget.categoryName);
    super.initState();
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
              child: loading
                  ? Center(
                      child: LoadingBouncingGrid.circle(
                        backgroundColor: Colors.cyanAccent,
                      ),
                    )
                  // ? Center(child: CircularProgressIndicator())
                  : Expanded(child: mainPhotosList(photosByCategory, context)),
            ),
          ],
        ),
      ),
    );
  }
}
