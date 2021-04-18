import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  getData() async {
    final responseData = await http.get(url);
    if (responseData.statusCode == 200) {
      return jsonDecode(responseData.body);
    } else {
      print(responseData.statusCode);
    }
  }
}
