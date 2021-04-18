import 'package:flutter/material.dart';

import 'package:unsplash_final_project/models/category_model.dart';
import 'package:unsplash_final_project/models/mainPhotos_model.dart';
import 'package:unsplash_final_project/screens/search.dart';
import 'package:unsplash_final_project/services/photo.dart';
import 'package:unsplash_final_project/widgets/categories_tile.dart';
import 'package:unsplash_final_project/widgets/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageNumber = 1;
  int catPageNumber = 1;
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollController1 = new ScrollController();
  Photo photo = Photo();
  List<CategoriesModel> categories = [];
  List<MainPhotosModel> popularPhotos = [];
  TextEditingController searchController = new TextEditingController();

  getPopularPhotos() async {
    var data = await photo.getPopularPhotos(pageNumber);
    setState(() {
      for (Map i in data) {
        popularPhotos.add(MainPhotosModel.fromJson(i));
      }
    });
  }

  getCategories() async {
    var data = await photo.getCategories(catPageNumber);
    setState(() {
      for (Map i in data) {
        categories.add(CategoriesModel.fromJson(i));
      }
    });
  }

  @override
  void initState() {
    getCategories();
    // Load next page when user scrolls to the end
    _scrollController1.addListener(() {
      if (_scrollController1.position.pixels ==
          _scrollController1.position.maxScrollExtent) {
        setState(() {
          catPageNumber++;
        });
        getCategories();
      }
    });
    getPopularPhotos();
    // Load next page when user scrolls to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          pageNumber++;
        });
        getPopularPhotos();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController1.dispose();
    super.dispose();
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
                          ),
                        ),
                      );
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      child: Icon(Icons.search),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 80,
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  controller: _scrollController1,
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
              child: Expanded(
                child: mainPhotosList(
                  popularPhotos,
                  context,
                  _scrollController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
