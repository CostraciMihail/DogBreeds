import 'package:flutter/material.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/CustomWidgets/DBBreedsGridViewCell.dart';

class DBSubBreedsListScreen extends StatefulWidget {
  final _breedsCellsFactory = DBBreedsGridViewCellFactory();
  final viewModel = DBSubBreedsListViewModel();

  DBSubBreedsListScreen({Key key}) : super(key: key);

  @override
  _DBSubBreedsListScreenState createState() => _DBSubBreedsListScreenState();
}

class _DBSubBreedsListScreenState extends State<DBSubBreedsListScreen> {
  var _breedsCells = List<DBBreedsGridViewCell>();
  var _isLoadingData = false;

  @override
  void initState() {
    super.initState();

    _isLoadingData = true;
    widget.viewModel.loadAllDogSubBreeds("hound").then((list) {
      setState(() {
        _breedsCells = widget._breedsCellsFactory
            .makeSubBreedsCells(list, widget.viewModel);
        _isLoadingData = false;
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sub Breeds")),
        body: _isLoadingData
            ? Center(child: CircularProgressIndicator())
            : Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Text(
                    "Hound",
                    style: TextStyle(fontSize: 18),
                  ),
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: _breedsCells,
                  )
                ],
              ));
  }
}
