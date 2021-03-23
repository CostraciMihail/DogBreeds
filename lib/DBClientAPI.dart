import 'package:http/http.dart' as http;

enum DBRequestMethod { GET, POST }

class DBClientAPI {
  Future<http.Response> makeRequest(
      String host, String path, DBRequestMethod requestMethod,
      {Map<String, dynamic> headers}) async {
    http.Response response;

    // print('\n*** Request url: $url');
    // print('Method: ${requestMethod.toString()}');

    switch (requestMethod) {
      case DBRequestMethod.GET:
        response = await http.get(Uri.https(host, path));
        break;

      case DBRequestMethod.POST:
        // todo: add params
        response = await http.post(Uri.https(host, path));
        break;
    }

    // print('\n*** Response url: $url');
    // print('Method: ${requestMethod.toString()}');
    // print('Status code: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      // print("Body: ${jsonDecode(response.body)}");
      return response;
    } else {
      throw Exception('$response');
    }
  }
}
