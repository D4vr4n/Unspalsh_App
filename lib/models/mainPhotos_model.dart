import 'dart:convert';

List<MainPhotosModel> modelUserFromJson(String str) =>
    List<MainPhotosModel>.from(
      json.decode(str).map(
            (x) => MainPhotosModel.fromJson(x),
          ),
    );
String modelUserToJson(List<MainPhotosModel> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class MainPhotosModel {
  String id;
  UserModel user;
  UrlModel urls;
  MainPhotosModel({this.id, this.user, this.urls});
  factory MainPhotosModel.fromJson(Map<String, dynamic> json) =>
      MainPhotosModel(
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
        urls: UrlModel.fromJson(json["urls"]),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "urls": urls.toJson(),
      };
}

class UserModel {
  String name;
  UserModel({this.name});
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class UrlModel {
  String full;
  String regular;
  UrlModel({this.full, this.regular});
  factory UrlModel.fromJson(Map<String, dynamic> json) =>
      UrlModel(full: json["full"], regular: json["regular"]);
  Map<String, dynamic> toJson() => {"full": full, "regular": regular};
}
