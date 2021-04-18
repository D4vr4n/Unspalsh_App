import 'networking.dart';

const apiKey = 'jLFnRsQ2GjVdKeacMPBjycuBhuqYqyZStxxWH8TccGE';
const url = 'https://api.unsplash.com';

class Photo {
  getPopularPhotos(int pageNumber) async {
    NetworkHelper networkHelper =
        NetworkHelper('$url/photos?page=$pageNumber&client_id=$apiKey');
    var data = await networkHelper.getData();
    return data;
  }

  getCategories(int pageNumber) async {
    NetworkHelper networkHelper =
        NetworkHelper('$url/topics?page=$pageNumber&client_id=$apiKey');
    var data = await networkHelper.getData();
    return data;
  }

  getPhotosByCategory(String category, int pageNumber) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$url/topics/$category/photos?page=$pageNumber&client_id=$apiKey');
    var data = await networkHelper.getData();
    return data;
  }

  getSearchedPhotos(String query, int pageNumber) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$url/search/photos?query=$query&page=$pageNumber&client_id=$apiKey');
    var data = await networkHelper.getData();
    return data;
  }
}
