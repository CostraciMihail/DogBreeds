import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';

class DBBreedsListViewModel {
  var _allDogBreeds = List<DBDogBreedsModel>();
  DBDogBreedsEnpointInterface dogBreedsEnpoint;

  DBBreedsListViewModel({DBDogBreedsEnpointInterface dogBreedsEnpoint})
      : dogBreedsEnpoint = dogBreedsEnpoint ?? DBDogBreedsEnpoint();

  List<DBDogBreedsModel> get allDogBreeds {
    return _allDogBreeds;
  }

  Future<List<DBDogBreedsModel>> loadAllDogBreeds() async {
    return dogBreedsEnpoint.getAllDogBreeds();
  }

  Future<String> getRandomImageUrlFor(String dogBreed) async {
    return dogBreedsEnpoint.getBreedRadomImageUrl(dogBreed);
  }

  // Mock
  Future<List<DBDogBreedsModel>> loadAllDogBreedsMocks() async {
    var mockArray = List<DBDogBreedsModel>();

    await Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      for (int i = 0; i < 300; i++) {
        mockArray.add(DBDogBreedsModel(name: "Breed $i", subBreeds: []));
      }
    });

    return mockArray;
  }
}