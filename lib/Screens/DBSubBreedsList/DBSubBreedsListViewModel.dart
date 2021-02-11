import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';

class DBSubBreedsListViewModel {
  var _allDogBreeds = List<DBDogBreedsModel>();
  DBDogBreedsEnpointInterface dogBreedsEnpoint;

  DBSubBreedsListViewModel({DBDogBreedsEnpointInterface dogBreedsEnpoint})
      : dogBreedsEnpoint = dogBreedsEnpoint ?? DBDogBreedsEnpoint();

  List<DBDogBreedsModel> get allDogBreeds {
    return _allDogBreeds;
  }

  Future<DBDogBreedsModel> loadAllDogSubBreeds(String dogBreed) async {
    return dogBreedsEnpoint.getAllDogSubBreeds(dogBreed);
  }

  Future<String> getRandomImageUrlFor(String dogBreed) async {
    return dogBreedsEnpoint.getBreedRadomImageUrl(dogBreed);
  }

  // Mock
  Future<List<DBDogBreedsModel>> loadAllDogSubBreedsMocks() async {
    var mockArray = List<DBDogBreedsModel>();

    await Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      for (int i = 0; i < 30; i++) {
        mockArray.add(DBDogBreedsModel(name: "Breed $i", subBreeds: []));
      }
    });

    return mockArray;
  }
}
