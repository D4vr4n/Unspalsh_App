import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';

import 'package:unsplash_final_project/models/category_model.dart';
import 'package:unsplash_final_project/models/mainPhotos_model.dart';
import 'package:unsplash_final_project/screens/search.dart';
import 'package:unsplash_final_project/widgets/widget.dart';

import 'category.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = [];
  List<MainPhotosModel> popularPhotos = [];
  var loading = false;
  var catloading = false;
  TextEditingController searchController = new TextEditingController();

  getPopularPhotos() async {
    setState(() {
      loading = true;
    });
    final responseData = await http.get(
        "https://api.unsplash.com/photos?per_page=20&client_id=jLFnRsQ2GjVdKeacMPBjycuBhuqYqyZStxxWH8TccGE");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      setState(() {
        for (Map i in data) {
          popularPhotos.add(MainPhotosModel.fromJson(i));
        }
        loading = false;
      });
    }
  }

  getCategories() async {
    setState(() {
      catloading = true;
    });
    final responseData = await http.get(
        "https://api.unsplash.com/topics?client_id=jLFnRsQ2GjVdKeacMPBjycuBhuqYqyZStxxWH8TccGE");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      setState(() {
        for (Map i in data) {
          categories.add(CategoriesModel.fromJson(i));
        }
        catloading = false;
      });
    }
  }

  @override
  void initState() {
    getCategories();
    getPopularPhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            hintText: 'Search free high-resolution photos',
                            border: InputBorder.none)),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search(
                                      query: searchController.text,
                                    )));
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(child: Icon(Icons.search)))
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 80,
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoriesTile(
                      title: categories[index].title,
                      slug: categories[index].slug,
                      imgUrl: categories[index].cover_photo.urls.full,
                    );
                  }),
            ),
            Container(
              child: loading
                  ? Center(
                      child: LoadingBouncingGrid.circle(
                        backgroundColor: Colors.cyanAccent,
                      ),
                    )
                  : Expanded(child: mainPhotosList(popularPhotos, context)),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title, slug;
  CategoriesTile(
      {@required this.title, @required this.imgUrl, @required this.slug});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Category(
                      categoryName: slug,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  height: 50,
                  width: 100,
                  fit: BoxFit.cover,
                )),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black26,
                ),
                alignment: Alignment.center,
                height: 50,
                width: 100,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }
}
