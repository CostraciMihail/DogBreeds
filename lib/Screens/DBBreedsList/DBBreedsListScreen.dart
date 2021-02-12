import 'package:flutter/material.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCell.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCellFactory.dart';

class DBBreedsListScreen extends StatefulWidget {
  final _breedsCellsFactory = DBBreedsGridViewCellFactory();
  final viewModel = DBBreedsListViewModel();

  DBBreedsListScreen({Key key}) : super(key: key);

  @override
  _DBBreedsListScreenState createState() => _DBBreedsListScreenState();
}

class _DBBreedsListScreenState extends State<DBBreedsListScreen> {
  var _breedsCells = List<DBBreedsGridViewCell>();

  Future<List<DBBreedsGridViewCell>> createCells() async {
    final allDogBreeds = await widget.viewModel.loadAllDogBreeds();

    final dogBreedsList = widget._breedsCellsFactory
        .makeBreedsCells(allDogBreeds, widget.viewModel);

    _breedsCells = dogBreedsList;
    return Future<List<DBBreedsGridViewCell>>.value(_breedsCells);
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text("Dog Breeds")),
        body: FutureBuilder(
            future: createCells(),
            builder: (BuildContext buildContext,
                AsyncSnapshot<List<DBBreedsGridViewCell>> snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: snapshot.data,
                );
              } else if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            }));
  }
}
