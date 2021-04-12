import 'package:flutter/material.dart';
import 'package:unsplash_final_project/models/mainPhotos_model.dart';
import 'package:unsplash_final_project/screens/home.dart';
import 'package:unsplash_final_project/widgets/widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animations/loading_animations.dart';

class Search extends StatefulWidget {
  final String query;
  Search({this.query});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = new TextEditingController();
  List<MainPhotosModel> searchedPhotos = [];
  var loading = false;

  getSearchedPhotos(String query) async {
    setState(() {
      loading = true;
    });
    final responseData = await http.get(
        "https://api.unsplash.com/search/photos?query=$query&per_page=20&client_id=jLFnRsQ2GjVdKeacMPBjycuBhuqYqyZStxxWH8TccGE");
    if (responseData.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(responseData.body);
      setState(() {
        for (Map i in data["results"]) {
          searchedPhotos.add(MainPhotosModel.fromJson(i));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getSearchedPhotos(widget.query);
    super.initState();
    searchController.text = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Search",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
                        searchedPhotos.clear();
                        FocusScope.of(context).unfocus();
                        getSearchedPhotos(searchController.text);
                      },
                      child: Container(child: Icon(Icons.search)))
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              child: loading
                  ? Center(
                      child: LoadingBouncingGrid.circle(
                        backgroundColor: Colors.cyanAccent,
                      ),
                    )
                  : Expanded(child: mainPhotosList(searchedPhotos, context)),
            ),
          ],
        ),
      ),
    );
  }
}
