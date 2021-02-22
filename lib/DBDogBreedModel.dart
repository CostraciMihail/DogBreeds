import 'package:flutter/material.dart';
import 'package:DogBreeds/DBExtensions.dart';

///
/// DBDogInterface
///
abstract class DBDogInterface {
  String name;
  String imageUrl;
}

///
/// DBDogBreedModel
///
class DBDogBreedModel implements DBDogInterface {
  int id;
  String name;
  String imageUrl;
  List<DBDogSubBreedModel> subBreeds;

  DBDogBreedModel({this.id, this.name, String imageUrl, this.subBreeds}) {
    this.imageUrl = imageUrl ?? "no-url";
  }

  factory DBDogBreedModel.fromJson(int index, String key, dynamic value) {
    List<String> listNames = List<String>.from(value);
    return DBDogBreedModel(
        id: index,
        name: key,
        subBreeds: listNames.toListOfDogSubBreeds(
            dogBreed: key, dogBreedIndex: index));
  }

  bool operator ==(Object other) {
    return other is DBDogBreedModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.imageUrl == this.imageUrl &&
        other.subBreeds.length == this.subBreeds.length;
  }

  @override
  int get hashCode => ("$id" + name).hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'DBDogBreedModel{name: $name, imageUrl: $imageUrl}';
  }
}

/// DBDogSubBreedModel
///
class DBDogSubBreedModel implements DBDogInterface {
  int id;
  String name;
  String dogBreed;
  String imageUrl;
  bool isFavorite;

  DBDogSubBreedModel(
      {this.id,
      this.name,
      this.dogBreed,
      this.isFavorite = false,
      String imageUrl}) {
    this.imageUrl = imageUrl ?? "no-url";
  }

  @override
  bool operator ==(Object other) {
    return other is DBDogSubBreedModel && other.id == this.id;
  }

  @override
  int get hashCode => ("$id" + name).hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dogBreed': dogBreed,
      'isFavorite': isFavorite.toInt(),
      'imageUrl': imageUrl,
    };
  }
}

/// Extension [DBDogSubBreedList] for [List<String>].
///
extension DBDogSubBreedList on List<String> {
  /// Convert an List of dogSubBreeds (String) into
  /// an [List<DBDogSubBreedModel>].
  List<DBDogSubBreedModel> toListOfDogSubBreeds(
      {@required String dogBreed, @required int dogBreedIndex}) {
    var array = List<DBDogSubBreedModel>();
    int index = dogBreedIndex * 10;
    this.forEach((name) {
      array.add(DBDogSubBreedModel(id: index, name: name, dogBreed: dogBreed));
      index++;
    });
    return array;
  }
}

/// DBDogBreedsListModel
///
class DBDogBreedsListModel {
  List<DBDogBreedModel> dogBreeds;

  DBDogBreedsListModel({this.dogBreeds});

  factory DBDogBreedsListModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> listJson = json['message'];
    var array = List<DBDogBreedModel>();

    int index = 0;
    listJson.forEach((key, value) {
      array.add(DBDogBreedModel.fromJson(index, key, value));
      index++;
    });

    return DBDogBreedsListModel(dogBreeds: array);
  }
}
