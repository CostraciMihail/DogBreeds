import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCell.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListScreen.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/AllSubBreedImages/DBAllSubBreedImagesScreen.dart';
import 'package:DogBreeds/Screens/FavoritesSubBreeds/CustomWidgets/DBFavoritesBreedsCellWidget.dart';

/// DBBreedsGridViewCellFactory
///
class DBBreedsGridViewCellFactory {
  List<DBBreedsGridViewCell> makeBreedsCells(
      List<DBDogBreedModel> dogBreeds, DBBreedsListViewModel viewModel) {
    List<DBBreedsGridViewCell> cells = [];

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
    List<DBBreedsGridViewCell> cells = [];

    for (var subBreed in dogBreed.subBreeds) {
      var cell = DBBreedsGridViewCell(
        dogBreed,
        subBreed,
        allowTapAction: false,
        onTapAction: (context, dogBreed, selectedSubBreed) {
          var tmpDogBreed = dogBreed;
          final allSubBreeds = viewModel.allSubBreeds[selectedSubBreed.name];

          if (allSubBreeds == null || allSubBreeds.isEmpty) return;

          tmpDogBreed.subBreeds = allSubBreeds;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DBAllSubBreedImagesScreen(
                      dogBreed: tmpDogBreed,
                      initialSubBreed: selectedSubBreed)));
        },
        onSelectionAction: (dobBreed, subBreed, isSelected) {
          viewModel.updateFavoritesSubBreedsList(subBreed, isSelected);
        },
      );
      cells.add(cell);
    }

    return cells;
  }

  List<DBFavoritesBreedsCellWidget> makeFavoritesSubBreedsCellsFrom(
      List<DBDogSubBreedModel> subBreeds,
      Function(DBDogBreedModel, DBDogSubBreedModel, bool) onSelectionAction) {
    if (subBreeds == null) return [];

    List<DBFavoritesBreedsCellWidget> cells = [];
    subBreeds.forEach((subBreed) {
      cells.add(DBFavoritesBreedsCellWidget(
        subBreed,
        onTapAction: (selectedBreed) {},
        onSelectionAction: (dogBreed, subBreed, isSlected) =>
            onSelectionAction(dogBreed, subBreed, isSlected),
      ));
    });

    return cells;
  }
}
