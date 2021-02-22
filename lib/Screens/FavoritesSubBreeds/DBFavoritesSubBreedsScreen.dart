import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:DogBreeds/Screens/FavoritesSubBreeds/CustomWidgets/DBFavoritesBreedsCellWidget.dart';
import 'package:DogBreeds/Screens/FavoritesSubBreeds/DBFavoritesSubBreedsViewModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCellFactory.dart';
import 'package:DogBreeds/CustomWidgets/DBEditAppBar.dart';
import 'package:DogBreeds/DBProviders.dart';

class DBFavoritesSubBreedsScreen extends StatefulWidget {
  final _breedsCellsFactory = DBBreedsGridViewCellFactory();
  final DBFavoritesSubBreedsViewModel viewModel;

  DBFavoritesSubBreedsScreen({Key key, DBFavoritesSubBreedsViewModel viewModel})
      : this.viewModel = viewModel ?? DBFavoritesSubBreedsViewModel();

  @override
  _DBFavoritesSubBreedsScreenState createState() =>
      _DBFavoritesSubBreedsScreenState();
}

class _DBFavoritesSubBreedsScreenState
    extends State<DBFavoritesSubBreedsScreen> {
  var _favoritesBreedsCells = List<DBFavoritesBreedsCellWidget>();

  @override
  Widget build(context) {
    return Scaffold(
        appBar: DBEditAppBar("Sub Breeds",
            onSaveTapHandler: () => appBarButtonPressed(context)),
        body: Consumer<DBFavoritesSubBredsProvider>(
            builder: (context, favoriteList, _) {
          return _futureBuilder();
        }));
  }

  // Load Data
  //
  Widget _futureBuilder() {
    return Stack(alignment: AlignmentDirectional.topCenter, children: [
      FutureBuilder(
          future: _loadData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DBFavoritesBreedsCellWidget>> snapshot) {
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              return GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: snapshot.data,
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Text(
                "No sub breeds found.",
                style: TextStyle(fontSize: 25, color: Colors.grey[500]),
              ),
            );
          })
    ]);
  }

  Future<List<DBFavoritesBreedsCellWidget>> _loadData() async {
    final subBreedslistFuture =
        widget.viewModel.loadAllFavoritesSubBreeds().then((subBreedsList) {
      _favoritesBreedsCells = widget._breedsCellsFactory
          .makeFavoritesSubBreedsCellsFrom(subBreedsList,
              (dogBreed, subBreed, isSlected) {
        widget.viewModel.upadeFavoritesList(dogBreed, subBreed, isSlected);
      });
      return Future<List<DBFavoritesBreedsCellWidget>>.value(
          _favoritesBreedsCells);
    });

    return subBreedslistFuture;
  }

  // Actions
  //
  void appBarButtonPressed(context) {
    widget.viewModel.saveSelectedFavoritesSubBreeds();
    Provider.of<DBFavoritesSubBredsProvider>(context, listen: false)
        .favoriteList = [];
  }
}
