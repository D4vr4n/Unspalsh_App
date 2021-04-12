import 'dart:convert';

List<CategoriesModel> modelUserFromJson(String str) =>
    List<CategoriesModel>.from(
        json.decode(str).map((x) => CategoriesModel.fromJson(x)));
String modelUserToJson(List<CategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  String title;
  String slug;
  CoverPhoto cover_photo;
  CategoriesModel({
    this.title,
    this.slug,
    this.cover_photo,
  });
  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        title: json["title"],
        slug: json["slug"],
        cover_photo: CoverPhoto.fromJson(json["cover_photo"]),
      );
  Map<String, dynamic> toJson() => {
        "title": title,
        "slug": slug,
        "cover_photo": cover_photo.toJson(),
      };
}

class CoverPhoto {
  UrlModel urls;
  CoverPhoto({
    this.urls,
  });
  factory CoverPhoto.fromJson(Map<String, dynamic> json) => CoverPhoto(
        urls: UrlModel.fromJson(json["urls"]),
      );
  Map<String, dynamic> toJson() => {
        "urls": urls.toJson(),
      };
}

class UrlModel {
  String full;
  String regular;
  UrlModel({
    this.full,
    this.regular,
  });
  factory UrlModel.fromJson(Map<String, dynamic> json) => UrlModel(
        full: json["full"],
        regular: json["regular"],
      );
  Map<String, dynamic> toJson() => {
        "full": full,
        "regular": regular,
      };
}
