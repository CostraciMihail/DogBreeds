import 'package:DogBreeds/DBDogBreedModel.dart';

extension StringExtension on String {
  /// Capitalize the first character of a string
  ///
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension DBDogSubBreedList on List<List<DBDogSubBreedModel>> {
  bool containsArray(List<DBDogSubBreedModel> array) {
    for (var index = 0; index < this.length; index++) {
      final tmpArray = this[index];
      if (tmpArray.first != null && tmpArray.first.name == array.first.name) {
        return true;
      }
    }
    return false;
  }

  int getIndexOfSubBreedList(List<DBDogSubBreedModel> subBreedsList) {
    for (var index = 0; index < this.length; index++) {
      final tmpArray = this[index];
      if (tmpArray.first != null &&
          tmpArray.first.name == subBreedsList.first.name) {
        return index;
      }
    }
    return -1;
  }
}

extension DBDogSubBreedListUrls on List<String> {
  Map<String, List<DBDogSubBreedModel>> convertToSubBreedModels(
      String imageHostName, List<String> urls, DBDogBreedModel dogBreed) {
    //
    // Example of one returned url.
    // "https://images.dog.ceo/breeds/hound-blood/n02088466_3568.jpg"
    final trimPattern = imageHostName + "/breeds/${dogBreed.name}-";
    var mapOfArrays = Map<String, List<DBDogSubBreedModel>>();

    urls.forEach((imageUrl) {
      final trimmedStr = imageUrl.replaceAll(trimPattern, '');
      var subBreedName = trimmedStr.split('/').first;

      if (subBreedName != null) {
        final newSubBreed =
            DBDogSubBreedModel(name: subBreedName, imageUrl: imageUrl);
        final tmpSubBreedList = [newSubBreed];
        var existingArray = mapOfArrays[newSubBreed.name];

        if (existingArray != null)
          existingArray.insert(0, newSubBreed);
        else
          mapOfArrays[subBreedName] = tmpSubBreedList;
      }
    });

    return mapOfArrays;
  }
}

extension BoolHelpers on bool {
  int toInt() => this ? 1 : 0;
}

extension IntHelpers on int {
  bool toBool() => this == 0 ? false : true;
  bool inttoBool(int a) => a == 0 ? false : true;
}
