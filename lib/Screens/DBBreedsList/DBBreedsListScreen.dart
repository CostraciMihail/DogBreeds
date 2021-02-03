import 'package:flutter/material.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCell.dart';

class DBBreedsListScreen extends StatefulWidget {
  final _breedsCellsFactory = DBBreedsGridViewCellFactory();
  final viewModel = DBBreedsListViewModel();

  DBBreedsListScreen({Key key}) : super(key: key);

  @override
  _DBBreedsListScreenState createState() => _DBBreedsListScreenState();
}

class _DBBreedsListScreenState extends State<DBBreedsListScreen> {
  var _breedsCells = List<DBBreedsGridViewCell>();
  var _isLoadingData = false;

  @override
  void initState() {
    super.initState();

    _isLoadingData = true;
    widget.viewModel.loadAllDogBreeds().then((list) {
      setState(() {
        _breedsCells = widget._breedsCellsFactory.makeBreedsCells(list, widget.viewModel);
        _isLoadingData = false;
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text("DogBreeds")),
        body: _isLoadingData
            ? Center(child: CircularProgressIndicator())
            : GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: _breedsCells,
              ));
  }
}
