import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBExtensions.dart';

enum DBRequestMethod { GET, POST }

class DBClientAPI {
  Future<http.Response> makeRequest(String url, DBRequestMethod requestMethod,
      {Map<String, dynamic> headers}) async {
    http.Response response;

    // print('\n*** Request url: $url');
    // print('Method: ${requestMethod.toString()}');

    switch (requestMethod) {
      case DBRequestMethod.GET:
        response = await http.get(url);
        break;

      case DBRequestMethod.POST:
        // todo: add params
        response = await http.post(url);
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

abstract class DBDogBreedsEnpointInterface {
  Future<List<DBDogBreedModel>> getAllDogBreeds();
  Future<DBDogBreedModel> getAllDogSubBreeds(DBDogBreedModel dogBreed);
  Future<String> getBreedRadomImageUrl(String dogBreed);
  Future<String> getSubBreedRadomImageUrl(String dogBreed, String subBreed);
  Future<Map<String, List<DBDogSubBreedModel>>> getAllBreedRadomImagesUrlFor(
      DBDogBreedModel dogBreed);
}

class DBDogBreedsEnpoint implements DBDogBreedsEnpointInterface {
  DBClientAPI _apiClient;

  static String hostName = 'https://dog.ceo';
  static String imageHostName = 'https://images.dog.ceo';
  static String allBreedImagesPath(String dogBreed) {
    return '/api/breed/$dogBreed/images';
  }

  DBDogBreedsEnpoint() : _apiClient = DBClientAPI();

  Future<List<DBDogBreedModel>> getAllDogBreeds() async {
    final responseFuture = _apiClient.makeRequest(
        "$hostName/api/breeds/list/all", DBRequestMethod.GET);

    return responseFuture.then((response) {
      var dogBreedsList =
          DBDogBreedsListModel.fromJson(jsonDecode(response.body)).dogBreeds;
      return Future<List<DBDogBreedModel>>.value(dogBreedsList);
    });
  }

  Future<DBDogBreedModel> getAllDogSubBreeds(DBDogBreedModel dogBreed) async {
    final responseFuture = _apiClient.makeRequest(
        "$hostName/api/breed/${dogBreed.name}/list", DBRequestMethod.GET);

    return responseFuture.then((response) {
      final dogSubBreedsList =
          List<String>.from(jsonDecode(response.body)["message"]);

      return Future<DBDogBreedModel>.value(DBDogBreedModel(
          name: dogBreed.name,
          subBreeds: dogSubBreedsList.toListOfDogSubBreeds(
              dogBreed: dogBreed.name, dogBreedIndex: dogBreed.id)));
    });
  }

  // Return an radom image url for specific dog breed name.
  Future<String> getBreedRadomImageUrl(String dogBreed) async {
    final responseFuture = _apiClient.makeRequest(
        "$hostName/api/breed/${dogBreed.toLowerCase()}/images/random",
        DBRequestMethod.GET);

    return responseFuture.then((response) {
      var imageUrl = jsonDecode(response.body)["message"] as String;
      // print("Response: $imageUrl");
      return Future<String>.value(imageUrl);
    }).catchError((error) {
      // print('Fail to load image with error: $error');
      return Future<String>.error(error);
    });
  }

  /// Return an radom image url for specific dog breed name.
  ///
  Future<String> getSubBreedRadomImageUrl(
      String dogBreed, String subBreed) async {
    final responseFuture = _apiClient.makeRequest(
        "$hostName/api/breed/${dogBreed.toLowerCase()}/${subBreed.toLowerCase()}/images/random",
        DBRequestMethod.GET);

    return responseFuture.then((response) {
      var imageUrl = jsonDecode(response.body)["message"] as String;
      // print("Response: $imageUrl");
      return Future<String>.value(imageUrl);
    }).catchError((error) {
      // print('Fail to load image with error: $error');
      return Future<String>.error(error);
    });
  }

  /// Returns an array of all the images from a breed, e.g. 'hound'.
  ///
  Future<Map<String, List<DBDogSubBreedModel>>> getAllBreedRadomImagesUrlFor(
      DBDogBreedModel dogBreed) async {
    final responseFuture = _apiClient.makeRequest(
        "$hostName${allBreedImagesPath(dogBreed.name)}", DBRequestMethod.GET);

    return responseFuture.then((response) {
      var imagesUrlList =
          List<String>.from(jsonDecode(response.body)["message"]);

      final subBreedsList = imagesUrlList.convertToSubBreedModels(
          imageHostName, imagesUrlList, dogBreed);
      return Future<Map<String, List<DBDogSubBreedModel>>>.value(subBreedsList);
    });
  }
}
