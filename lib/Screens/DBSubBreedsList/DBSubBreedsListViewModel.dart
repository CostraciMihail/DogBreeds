import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';

class DBSubBreedsListViewModel {
  DBDogBreedModel dogBreed;
  Map<String, List<DBDogSubBreedModel>> allSubBreeds = {};
  DBDogBreedsEnpointInterface dogBreedsEnpoint;

  DBSubBreedsListViewModel(this.dogBreed,
      {DBDogBreedsEnpointInterface dogBreedsEnpoint})
      : dogBreedsEnpoint = dogBreedsEnpoint ?? DBDogBreedsEnpoint() {
    // TODO: add links to dogSubBreedImage object.
    //       Make this operation in background on separated thread.
    getAllBreedImages().then((subBreedsWithImageUrls) {
      allSubBreeds = subBreedsWithImageUrls;
    });
  }

  Future<DBDogBreedModel> loadAllDogSubBreeds(String dogBreed) async {
    return dogBreedsEnpoint.getAllDogSubBreeds(dogBreed).then((value) {
      this.dogBreed = value;
      return Future<DBDogBreedModel>.value(value);
    });
  }

  Future<String> getRandomImageUrlFor(String dogBreed) async {
    return dogBreedsEnpoint.getBreedRadomImageUrl(dogBreed);
  }

  Future<Map<String, List<DBDogSubBreedModel>>> getAllBreedImages() async {
    return dogBreedsEnpoint.getAllBreedRadomImagesUrlFor(dogBreed);
  }

  // Mock
  Future<List<DBDogBreedModel>> loadAllDogSubBreedsMocks() async {
    var mockArray = List<DBDogBreedModel>();

    await Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      for (int i = 0; i < 30; i++) {
        mockArray.add(DBDogBreedModel(name: "Breed $i", subBreeds: []));
      }
    });

    return mockArray;
  }
}
