import 'dart:convert';

class DBDogBreedsListModel {
  List<DBDogBreedsModel> dogBreeds;

  DBDogBreedsListModel({this.dogBreeds});

  factory DBDogBreedsListModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> listJson = json['message'];
    var array = List<DBDogBreedsModel>();

    listJson.forEach((key, value) {
      array.add(DBDogBreedsModel.fromJson(key, value));
    });

    return DBDogBreedsListModel(dogBreeds: array);
  }
}

class DBDogBreedsModel {
  final String name;
  String imageUrl = 'no-url';
  final List<String> subBreeds;

  DBDogBreedsModel({this.name, this.imageUrl, this.subBreeds});

  factory DBDogBreedsModel.fromJson(String key, dynamic value) {
    List<String> list = List<String>.from(value);
    return DBDogBreedsModel(name: key, subBreeds: list);
  }
}
