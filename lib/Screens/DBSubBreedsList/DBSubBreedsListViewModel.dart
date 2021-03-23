import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';
import 'package:DogBreeds/DBDataBaseManager.dart';

class DBSubBreedsListViewModel {
  bool isEditMode;
  DBDogBreedModel dogBreed;
  Map<String, List<DBDogSubBreedModel>> allSubBreeds = {};
  Set<DBDogSubBreedModel> favoritesSubBreeds = Set<DBDogSubBreedModel>();
  Set<DBDogSubBreedModel> initialFavoritesSubBreeds = Set<DBDogSubBreedModel>();
  DBDogBreedsEnpointInterface dogBreedsEnpoint;

  DBSubBreedsListViewModel(this.dogBreed,
      {DBDogBreedsEnpointInterface dogBreedsEnpoint, this.isEditMode = false})
      : dogBreedsEnpoint = dogBreedsEnpoint ?? DBDogBreedsEnpoint() {
    getAllBreedImages().then((subBreedsWithImageUrls) {
      allSubBreeds = subBreedsWithImageUrls;
    });
  }

  void updateFavoritesSubBreedsList(
      DBDogSubBreedModel subBreed, bool isSelected) {
    isSelected
        ? favoritesSubBreeds.add(subBreed)
        : favoritesSubBreeds.remove(subBreed);
  }

  void saveFavoritesSubBreeds() async {
    print("Total Favorites: ${favoritesSubBreeds.length}");

    final subBreedsToRemove = initialFavoritesSubBreeds.where((subBreed) {
      return !favoritesSubBreeds.contains(subBreed);
    }).toList();
    print("SubBreeds To Remove: ${subBreedsToRemove.length}");

    await DBDataBaseManager().delete(subBreedsToRemove);
    await DBDataBaseManager().insertDogSubBreeds(favoritesSubBreeds.toList());
    print("Successfully saved to db");
  }

  Future<DBDogBreedModel> loadAllDogSubBreeds(DBDogBreedModel dogBreed) async {
    return dogBreedsEnpoint.getAllDogSubBreeds(dogBreed).then((value) async {
      var tmpDobBreeds = List<DBDogSubBreedModel>.of(value.subBreeds);
      final favoritesSubBreeds = await loadAllFavoritesSubBreedsDB();
      print("Loaded from DB: ${favoritesSubBreeds.length}");
      this.favoritesSubBreeds = Set.from(favoritesSubBreeds);
      this.initialFavoritesSubBreeds = Set.from(favoritesSubBreeds);

      tmpDobBreeds.forEach((subBreed) {
        if (favoritesSubBreeds.contains(subBreed)) {
          subBreed.isFavorite = true;
        }
      });

      value.subBreeds = tmpDobBreeds;
      this.dogBreed = value;

      return Future<DBDogBreedModel>.value(this.dogBreed);
    });
  }

  Future<List<DBDogSubBreedModel>> loadAllFavoritesSubBreedsDB() async {
    return DBDataBaseManager()
        .getFavoritesSubBreedsFor(dogBreed.name)
        .then((dbSubBreeds) {
      return Future<List<DBDogSubBreedModel>>.value(dbSubBreeds);
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
    List<DBDogBreedModel> mockArray = [];

    await Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      for (int i = 0; i < 30; i++) {
        mockArray.add(DBDogBreedModel(name: "Breed $i", subBreeds: []));
      }
    });

    return mockArray;
  }
}
