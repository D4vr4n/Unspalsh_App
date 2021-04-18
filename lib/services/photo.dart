import 'networking.dart';

const apiKey = 'jLFnRsQ2GjVdKeacMPBjycuBhuqYqyZStxxWH8TccGE';
const url = 'https://api.unsplash.com';

class Photo {
  getPopularPhotos() async {
    NetworkHelper networkHelper =
        NetworkHelper('$url/photos?client_id=$apiKey');
    var data = await networkHelper.getData();
    return data;
  }

  getCategories() async {
    NetworkHelper networkHelper =
        NetworkHelper('$url/topics?client_id=$apiKey');
    var data = await networkHelper.getData();
    return data;
  }

  getPhotosByCategory(String category) async {
    NetworkHelper networkHelper =
        NetworkHelper('$url/topics/$category/photos?client_id=$apiKey');
    var data = await networkHelper.getData();
    return data;
  }
}
