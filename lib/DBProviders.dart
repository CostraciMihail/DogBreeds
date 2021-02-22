import 'package:flutter/foundation.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';

// DBFavoritesSubBredsProvider
//
class DBFavoritesSubBredsProvider extends ChangeNotifier {
  List<DBDogSubBreedModel> _favoriteList = [];

  List<DBDogSubBreedModel> get favoriteList => _favoriteList;

  set favoriteList(List<DBDogSubBreedModel> newValue) {
    _favoriteList.addAll(newValue);
    notifyListeners();
  }
}

// ScreenState
//
class ScreenState extends ChangeNotifier {
  bool _isEditMode = false;

  bool get isEditMode {
    return _isEditMode;
  }

  set isEditMode(bool newValue) {
    if (newValue == _isEditMode) return;
    _isEditMode = newValue;
    notifyListeners();
  }
}

// ScreenState
//
class FavoritesScreenState extends ChangeNotifier {
  bool _isEditMode = false;

  bool get isEditMode {
    return _isEditMode;
  }

  set isEditMode(bool newValue) {
    if (newValue == _isEditMode) return;
    _isEditMode = newValue;
    notifyListeners();
  }
}