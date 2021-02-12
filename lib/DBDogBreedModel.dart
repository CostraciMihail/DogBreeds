///
/// DBDogInterface
///
abstract class DBDogInterface {
  String name;
  String imageUrl;
}

/// DBDogBreedModel
///
class DBDogBreedModel implements DBDogInterface {
  String name;
  String imageUrl;
  List<DBDogSubBreedModel> subBreeds;

  DBDogBreedModel({this.name, String imageUrl, this.subBreeds}) {
    this.imageUrl = imageUrl ?? "no-url";
  }

  factory DBDogBreedModel.fromJson(String key, dynamic value) {
    List<String> listNames = List<String>.from(value);
    return DBDogBreedModel(
        name: key, subBreeds: listNames.toListOfDogSubBreeds());
  }

  bool operator ==(Object other) {
    return other is DBDogBreedModel &&
        other.name == this.name &&
        other.imageUrl == this.imageUrl &&
        other.subBreeds.length == this.subBreeds.length;
  }

  @override
  int get hashCode => name.hashCode;
}

/// DBDogSubBreedModel
///
class DBDogSubBreedModel implements DBDogInterface {
  String name;
  String imageUrl;

  DBDogSubBreedModel({this.name, String imageUrl}) {
    this.imageUrl = imageUrl ?? "no-url";
  }

  @override
  bool operator ==(Object other) {
    return other is DBDogSubBreedModel &&
        other.name == this.name &&
        other.imageUrl == this.imageUrl;
  }

  @override
  int get hashCode => name.hashCode;
}

/// Extension [DBDogSubBreedList] for [List<String>].
///
extension DBDogSubBreedList on List<String> {
  /// Convert an List of dogSubBreeds (String) into
  /// an [List<DBDogSubBreedModel>].
  List<DBDogSubBreedModel> toListOfDogSubBreeds() {
    var array = List<DBDogSubBreedModel>();
    this.forEach((name) {
      array.add(DBDogSubBreedModel(name: name));
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

    listJson.forEach((key, value) {
      array.add(DBDogBreedModel.fromJson(key, value));
    });

    return DBDogBreedsListModel(dogBreeds: array);
  }
}
