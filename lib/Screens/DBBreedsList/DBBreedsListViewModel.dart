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
}
