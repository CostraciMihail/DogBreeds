import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:DogBreeds/DBDogBreedModel.dart';

abstract class DBDogBreedsEnpointInterface {
  Future<List<DBDogBreedsModel>> getAllDogBreeds();
  Future<String> getBreedRadomImageUrl(String dogBreed);
  Future<List<String>> getBreedRadomImagesUrl(String dogBreeds);
  Future<String> getSubBreedRadomImage(String subBreeds);
}

enum DBRequestMethod { GET, POST }

class DBClientAPI {
  Future<http.Response> makeRequest(String url, DBRequestMethod requestMethod,
      {Map<String, dynamic> headers}) async {
    http.Response response;

    switch (requestMethod) {
      case DBRequestMethod.GET:
        response = await http.get(url);
        break;

      case DBRequestMethod.POST:
        // todo: add params
        response = await http.post(url);
        break;
    }

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Fail to make request');
    }
  }
}

class DBDogBreedsEnpoint implements DBDogBreedsEnpointInterface {
  DBClientAPI _apiClient;

  DBDogBreedsEnpoint() : _apiClient = DBClientAPI();

  Future<List<DBDogBreedsModel>> getAllDogBreeds() async {
    final responseFuture = _apiClient.makeRequest(
        "https://dog.ceo/api/breeds/list/all", DBRequestMethod.GET);

    var dogBreedsList;
    await responseFuture.then((response) {
      dogBreedsList =
          DBDogBreedsListModel.fromJson(jsonDecode(response.body)).dogBreeds;
    });

    return dogBreedsList;
  }

// Return an array with random images with selected breed.
  Future<String> getBreedRadomImageUrl(String dogBreed) async {
    final responseFuture = _apiClient.makeRequest(
        "https://dog.ceo/api/breed/$dogBreed/images/random",
        DBRequestMethod.GET);

    var imageUrl;
    responseFuture.then((response) {
      print("Response: ${jsonDecode(response.body)}");
      // imageUrl = jsonDecode(response.body)["message"] as String;
    }).catchError((error) {
      print('Fail to load image with error: $error');
    });

    return imageUrl;
  }

  // Return an array with random images with selected breed.
  Future<List<String>> getBreedRadomImagesUrl(String dogBreeds) async {
    final responseFuture = _apiClient.makeRequest(
        "https://dog.ceo/api/breed/$dogBreeds/images", DBRequestMethod.GET);

    var imagesUrlList = List<String>();
    responseFuture.then((response) {
      imagesUrlList = List<String>.from(jsonDecode(response.body)["messages"]);
    });

    return imagesUrlList;
  }

  Future<String> getSubBreedRadomImage(String subBreeds) async {
    return 'empty-url';
  }
}
