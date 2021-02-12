import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCell.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListScreen.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/AllSubBreedImages/DBAllSubBreedImagesScreen.dart';

/// DBBreedsGridViewCellFactory
///
class DBBreedsGridViewCellFactory {
  List<DBBreedsGridViewCell> makeBreedsCells(
      List<DBDogBreedModel> dogBreeds, DBBreedsListViewModel viewModel) {
    var cells = List<DBBreedsGridViewCell>();

    for (var dogBreed in dogBreeds) {
      var cell = DBBreedsGridViewCell(dogBreed, null,
          onTapAction: (context, dogBreed, subBreed) {
        final viewModel = DBSubBreedsListViewModel(dogBreed);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DBSubBreedsListScreen(viewModel: viewModel)));
      });
      cells.add(cell);
    }

    return cells;
  }

  List<DBBreedsGridViewCell> makeSubBreedsCells(
      DBDogBreedModel dogBreed, DBSubBreedsListViewModel viewModel) {
    var cells = List<DBBreedsGridViewCell>();

    for (var subBreed in dogBreed.subBreeds) {
      var cell = DBBreedsGridViewCell(dogBreed, subBreed, allowTapAction: false,
          onTapAction: (context, dogBreed, selectedSubBreed) {
        var tmpDogBreed = dogBreed;
        tmpDogBreed.subBreeds = viewModel.allSubBreeds[selectedSubBreed.name];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DBAllSubBreedImagesScreen(
                    dogBreed: tmpDogBreed, initialSubBreed: selectedSubBreed)));
      });
      cells.add(cell);
    }

    return cells;
  }
}
