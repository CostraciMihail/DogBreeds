import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:DogBreeds/DBExtensions.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCell.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCellFactory.dart';
import 'package:DogBreeds/CustomWidgets/DBEditAppBar.dart';
import 'package:DogBreeds/DBProviders.dart';

///
/// DBSubBreedsListScreen
///
class DBSubBreedsListScreen extends StatefulWidget {
  final _breedsCellsFactory = DBBreedsGridViewCellFactory();
  final DBSubBreedsListViewModel viewModel;

  DBSubBreedsListScreen({Key key, this.viewModel}) : super(key: key);

  @override
  _DBSubBreedsListScreenState createState() => _DBSubBreedsListScreenState();
}

///
/// _DBSubBreedsListScreenState
///
class _DBSubBreedsListScreenState extends State<DBSubBreedsListScreen> {
  var _breedsCells = List<DBBreedsGridViewCell>();

  @override
  Widget build(context) {
    return Scaffold(
        appBar: DBEditAppBar("Sub Breeds",
            onSaveTapHandler: () => saveAppBarTapped(context)),
        body: _futureBuilder());
  }

  ///
  /// Loading Data
  ///
  Widget _futureBuilder() {
    return Stack(alignment: AlignmentDirectional.topCenter, children: [
      Text(
        widget.viewModel.dogBreed.name.capitalize(),
        style: TextStyle(fontSize: 18),
      ),
      FutureBuilder(
          future: _loadData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DBBreedsGridViewCell>> snapshot) {
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

  //
  // Acitons
  Future<List<DBBreedsGridViewCell>> _loadData() async {
    final subBreedslist =
        await widget.viewModel.loadAllDogSubBreeds(widget.viewModel.dogBreed);

    _breedsCells = widget._breedsCellsFactory
        .makeSubBreedsCells(subBreedslist, widget.viewModel);

    return Future<List<DBBreedsGridViewCell>>.value(_breedsCells);
  }

  void saveAppBarTapped(BuildContext context) {
    widget.viewModel.saveFavoritesSubBreeds();
    context.read<DBFavoritesSubBredsProvider>().favoriteList = [];
  }
}
