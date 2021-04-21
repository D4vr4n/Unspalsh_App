import 'package:flutter/material.dart';
import 'package:unsplash_final_project/models/mainPhotos_model.dart';
import 'package:unsplash_final_project/services/photo.dart';
import 'package:unsplash_final_project/widgets/widget.dart';

class Search extends StatefulWidget {
  final String query;
  Search({this.query});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int pageNumber = 1;
  Photo photo = Photo();
  ScrollController _scrollController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  List<MainPhotosModel> searchedPhotos = [];

  getSearchedPhotos(String query) async {
    var data = await photo.getSearchedPhotos(query, pageNumber);
    setState(() {
      for (Map i in data["results"]) {
        searchedPhotos.add(MainPhotosModel.fromJson(i));
      }
    });
  }

  Future<void> _updateData() async {
    setState(() {
      pageNumber = 1;
      searchedPhotos.clear();
      getSearchedPhotos(widget.query);
    });
  }

  @override
  void initState() {
    getSearchedPhotos(widget.query);
    // Load next page when user scrolls to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          pageNumber++;
        });
        getSearchedPhotos(widget.query);
      }
    });
    super.initState();
    searchController.text = widget.query;
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
              child: Expanded(
                child: RefreshIndicator(
                  child: mainPhotosList(
                    searchedPhotos,
                    context,
                    _scrollController,
                  ),
                  onRefresh: _updateData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
