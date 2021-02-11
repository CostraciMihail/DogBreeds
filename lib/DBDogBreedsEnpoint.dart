import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:DogBreeds/DBDogBreedModel.dart';

abstract class DBDogBreedsEnpointInterface {
  Future<List<DBDogBreedsModel>> getAllDogBreeds();
  Future<DBDogBreedsModel> getAllDogSubBreeds(String dogBreed);
  Future<String> getBreedRadomImageUrl(String dogBreed);
  Future<List<String>> getBreedRadomImagesUrl(String dogBreeds);
  Future<String> getSubBreedRadomImage(String subBreeds);
}

enum DBRequestMethod { GET, POST }

class DBClientAPI {
  Future<http.Response> makeRequest(String url, DBRequestMethod requestMethod,
      {Map<String, dynamic> headers}) async {
    http.Response response;

    print('\n*** Request url: $url');
    print('Method: ${requestMethod.toString()}');

    switch (requestMethod) {
      case DBRequestMethod.GET:
        response = await http.get(url);
        break;

      case DBRequestMethod.POST:
        // todo: add params
        response = await http.post(url);
        break;
    }

    print('\n*** Response url: $url');
    print('Method: ${requestMethod.toString()}');
    print('Status code: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      print("Body: ${jsonDecode(response.body)}");
      return response;
    } else {
      throw Exception('$response');
    }
  }
}

class DBDogBreedsEnpoint implements DBDogBreedsEnpointInterface {
  DBClientAPI _apiClient;

  DBDogBreedsEnpoint() : _apiClient = DBClientAPI();

  Future<List<DBDogBreedsModel>> getAllDogBreeds() async {
    final responseFuture = _apiClient.makeRequest(
        "https://dog.ceo/api/breeds/list/all", DBRequestMethod.GET);

    return responseFuture.then((response) {
      var dogBreedsList =
          DBDogBreedsListModel.fromJson(jsonDecode(response.body)).dogBreeds;
      return Future<List<DBDogBreedsModel>>.value(dogBreedsList);
    });
  }

  Future<DBDogBreedsModel> getAllDogSubBreeds(String dogBreed) async {
    final responseFuture = _apiClient.makeRequest(
        "https://dog.ceo/api/breed/$dogBreed/list", DBRequestMethod.GET);

    return responseFuture.then((response) {
      final dogSubBreedsList =
          List<String>.from(jsonDecode(response.body)["message"]);

      return Future<DBDogBreedsModel>.value(
          DBDogBreedsModel(name: dogBreed, subBreeds: dogSubBreedsList));
    });
  }

  // Return an radom image url for specific dog breed name.
  Future<String> getBreedRadomImageUrl(String dogBreed) async {
    final responseFuture = _apiClient.makeRequest(
        "https://dog.ceo/api/breed/${dogBreed.toLowerCase()}/images/random",
        DBRequestMethod.GET);

    return responseFuture.then((response) {
      var imageUrl = jsonDecode(response.body)["message"] as String;
      print("Response: $imageUrl");
      return Future<String>.value(imageUrl);
    }).catchError((error) {
      print('Fail to load image with error: $error');
      return Future<String>.error(error);
    });
  }

  // Return an array with random images with selected breed.
  Future<List<String>> getBreedRadomImagesUrl(String dogBreeds) async {
    final responseFuture = _apiClient.makeRequest(
        "https://dog.ceo/api/breed/$dogBreeds/images", DBRequestMethod.GET);

    return responseFuture.then((response) {
      var imagesUrlList =
          List<String>.from(jsonDecode(response.body)["messages"]);
      return Future<List<String>>.value(imagesUrlList);
    });

    // var imagesUrlList = List<String>();
    // responseFuture.then((response) {
    //   imagesUrlList = List<String>.from(jsonDecode(response.body)["messages"]);
    // });

    // return imagesUrlList;
  }

  Future<String> getSubBreedRadomImage(String subBreeds) async {
    return 'empty-url';
  }
}
