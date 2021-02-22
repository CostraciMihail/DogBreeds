import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';
import 'package:DogBreeds/DBDataBaseManager.dart';

class DBFavoritesSubBreedsViewModel {
  List<DBDogSubBreedModel> allFavoritesSubBreeds = [];
  List<DBDogSubBreedModel> selectedSubBreeds = [];
  DBDogBreedsEnpointInterface dogBreedsEnpoint;

  DBFavoritesSubBreedsViewModel({DBDogBreedsEnpointInterface dogBreedsEnpoint})
      : dogBreedsEnpoint = dogBreedsEnpoint ?? DBDogBreedsEnpoint();

  Future<List<DBDogSubBreedModel>> loadAllFavoritesSubBreeds() async {
    return DBDataBaseManager().getAllFavoritesSubBreeds().then((dbSubBreeds) {
      allFavoritesSubBreeds = List<DBDogSubBreedModel>.of(dbSubBreeds);
      selectedSubBreeds = List<DBDogSubBreedModel>.of(dbSubBreeds);
      return Future<List<DBDogSubBreedModel>>.value(dbSubBreeds);
    });
  }

  void upadeFavoritesList(dogBreed, subBreed, isSlected) {
    !isSlected
        ? selectedSubBreeds.remove(subBreed)
        : selectedSubBreeds.add(subBreed);
  }

  void saveSelectedFavoritesSubBreeds() async {
    final subBreedsToRemove = allFavoritesSubBreeds.where((subBreed) {
      return !selectedSubBreeds.contains(subBreed);
    });

    if (subBreedsToRemove.isEmpty) return;
    await DBDataBaseManager().delete(subBreedsToRemove.toList());
  }

  // Future<String> getRandomImageUrlFor(String dogBreed) async {
  //   return dogBreedsEnpoint.getBreedRadomImageUrl(dogBreed);
  // }

  // Future<Map<String, List<DBDogSubBreedModel>>> getAllBreedImages() async {
  //   return dogBreedsEnpoint.getAllBreedRadomImagesUrlFor(dogBreed);
  // }

}
