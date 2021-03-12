import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';

class DBBreedsListViewModel {
  List<DBDogBreedModel> _allDogBreeds = [];
  DBDogBreedsEnpointInterface dogBreedsEnpoint;

  DBBreedsListViewModel({DBDogBreedsEnpointInterface dogBreedsEnpoint})
      : dogBreedsEnpoint = dogBreedsEnpoint ?? DBDogBreedsEnpoint();

  List<DBDogBreedModel> get allDogBreeds {
    return _allDogBreeds;
  }

  Future<List<DBDogBreedModel>> loadAllDogBreeds() async {
    return dogBreedsEnpoint.getAllDogBreeds();
  }

  Future<String> getRandomImageUrlFor(String dogBreed) async {
    return dogBreedsEnpoint.getBreedRadomImageUrl(dogBreed);
  }

  // Mock
  Future<List<DBDogBreedModel>> loadAllDogBreedsMocks() async {
    List<DBDogBreedModel> mockArray = [];

    await Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      for (int i = 0; i < 300; i++) {
        mockArray.add(DBDogBreedModel(name: "Breed $i", subBreeds: []));
      }
    });

    return mockArray;
  }
}
