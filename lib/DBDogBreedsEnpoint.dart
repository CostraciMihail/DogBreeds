import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBClientAPI.dart';

abstract class DBDogBreedsEnpointInterface {
  DBClientAPI get apiClient;

  DBDogBreedsEnpointInterface({DBClientAPI apiClient});
  Future<List<DBDogBreedModel>> getAllDogBreeds();
  Future<DBDogBreedModel> getAllDogSubBreeds(DBDogBreedModel dogBreed);
  Future<String> getBreedRadomImageUrl(String dogBreed);
  Future<String> getSubBreedRadomImageUrl(String dogBreed, String subBreed);
  Future<Map<String, List<DBDogSubBreedModel>>> getAllBreedRadomImagesUrlFor(
      DBDogBreedModel dogBreed);
}

class DBDogBreedsEnpoint implements DBDogBreedsEnpointInterface {
  @override
  DBClientAPI get apiClient => _apiClient;
  DBClientAPI _apiClient;

  static String hostName = 'dog.ceo';
  static String imageHostName = 'https://images.dog.ceo';
  static String allBreedImagesPath(String dogBreed) {
    return '/api/breed/$dogBreed/images';
  }

  DBDogBreedsEnpoint({DBClientAPI apiClient})
      : _apiClient = apiClient ?? DBClientAPI();

  Future<List<DBDogBreedModel>> getAllDogBreeds() async {
    final responseFuture = _apiClient.makeRequest(
        hostName, "/api/breeds/list/all", DBRequestMethod.GET);

    return responseFuture.then((response) {
      var dogBreedsList =
          DBDogBreedsListModel.fromJson(jsonDecode(response.body)).dogBreeds;
      return Future<List<DBDogBreedModel>>.value(dogBreedsList);
    });
  }

  Future<DBDogBreedModel> getAllDogSubBreeds(DBDogBreedModel dogBreed) async {
    final responseFuture = _apiClient.makeRequest(
        hostName, "/api/breed/${dogBreed.name}/list", DBRequestMethod.GET);

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
        hostName,
        "/api/breed/${dogBreed.toLowerCase()}/images/random",
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
        hostName,
        "/api/breed/${dogBreed.toLowerCase()}/${subBreed.toLowerCase()}/images/random",
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
    final Map<String, dynamic> params = {
      "dogBreed": dogBreed,
      "apiClient": _apiClient
    };

    return compute(getAllDogSubBreedsWithImages, params);
  }
}

///
/// Make request and get all images for specified Dog Breed.
/// Keys for [arguments] Map are:'imageHostName', 'urls', 'dogBreed'
///
Future<Map<String, List<DBDogSubBreedModel>>> getAllDogSubBreedsWithImages(
    Map<String, dynamic> params) async {
  final dogBreed = params["dogBreed"] as DBDogBreedModel;
  final apiClient = params["apiClient"] as DBClientAPI;

  String imageHostName = DBDogBreedsEnpoint.imageHostName;

  final response = await apiClient.makeRequest(
      DBDogBreedsEnpoint.hostName,
      "${DBDogBreedsEnpoint.allBreedImagesPath(dogBreed.name)}",
      DBRequestMethod.GET);
  var urls = List<String>.from(jsonDecode(response.body)["message"]);

  //
  // Example of one returned url.
  // "https://images.dog.ceo/breeds/hound-blood/n02088466_3568.jpg"
  final trimPattern = imageHostName + "/breeds/${dogBreed.name}-";
  var mapOfArrays = Map<String, List<DBDogSubBreedModel>>();

  if (urls == null ||
      urls.isEmpty && imageHostName == null && dogBreed.name == null)
    return mapOfArrays;

  urls.forEach((imageUrl) {
    final trimmedStr = imageUrl.replaceAll(trimPattern, '');
    var subBreedName = trimmedStr.split('/').first;

    if (subBreedName != null) {
      final newSubBreed = DBDogSubBreedModel(
          name: subBreedName, imageUrl: imageUrl, dogBreed: dogBreed.name);
      final tmpSubBreedList = [newSubBreed];
      var existingArray = mapOfArrays[newSubBreed.name];

      if (existingArray != null)
        existingArray.insert(0, newSubBreed);
      else
        mapOfArrays[subBreedName] = tmpSubBreedList;
    }
  });

  return mapOfArrays;
}
