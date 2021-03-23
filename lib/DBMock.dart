import 'package:DogBreeds/DBDogBreedModel.dart';

class DBMock {
  static Future<List<DBDogBreedModel>> loadAllDogBreedsMocks() async {
    List<DBDogBreedModel> mockArray = [];

    await Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      for (int i = 0; i < 300; i++) {
        mockArray.add(DBDogBreedModel(name: "Breed $i", subBreeds: []));
      }
    });

    return mockArray;
  }

  static DBDogBreedModel mockDogBreed({String name = "terrier"}) {
    return DBDogBreedModel(
        id: 1,
        name: name,
        subBreeds: DBMock.mokSubBreedModel(),
        imageUrl: "empty_image_url");
  }

  static List<DBDogSubBreedModel> mokSubBreedModel() {
    List<DBDogSubBreedModel> array = [];
    final dogBreedName = "terrier";
    final subBreedNames = [
      "american",
      "australian",
      "bedlington",
      "border",
      "dandie",
      "fox",
      "irish",
      "kerryblue",
      "lakeland",
      "norfolk"
    ];

    for (var index = 0; index < 10; index++) {
      array.add(DBDogSubBreedModel(
          id: index,
          dogBreed: dogBreedName,
          imageUrl: "https://${subBreedNames[index]}.jpg",
          isFavorite: false,
          name: subBreedNames[index]));
    }

    return array;
  }
}
