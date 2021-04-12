import 'package:flutter/material.dart';
import 'package:unsplash_final_project/models/mainPhotos_model.dart';
import 'package:unsplash_final_project/screens/image.dart';

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.only(right: 20),
        child: ImageIcon(
          AssetImage('images/icon.png'),
        ),
      ),
      Text(
        'Unsplash',
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget mainPhotosList(List<MainPhotosModel> popularPhotos, context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: popularPhotos
          .map((popularPhoto) => GridTile(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageView(
                                  imgUrl: popularPhoto.urls.regular,
                                  imgAuthor: popularPhoto.user.name,
                                )));
                  },
                  child: Hero(
                    tag: popularPhoto.urls.regular,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image(
                          image: NetworkImage(popularPhoto.urls.regular),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    ),
  );
}
