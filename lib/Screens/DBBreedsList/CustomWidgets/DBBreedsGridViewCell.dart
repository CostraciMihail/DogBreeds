import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListScreen.dart';
import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListViewModel.dart';

class DBBreedsGridViewCellFactory {
  List<DBBreedsGridViewCell> makeBreedsCells(
      List<DBDogBreedsModel> dogBreeds, DBBreedsListViewModel viewModel) {
    var cells = List<DBBreedsGridViewCell>();

    for (var dogBreed in dogBreeds) {
      var cell = DBBreedsGridViewCell(dogBreed);
      cells.add(cell);
    }

    return cells;
  }

  List<DBBreedsGridViewCell> makeSubBreedsCells(
      List<DBDogBreedsModel> dogBreeds, DBSubBreedsListViewModel viewModel) {
    var cells = List<DBBreedsGridViewCell>();

    for (var dogBreed in dogBreeds) {
      var cell = DBBreedsGridViewCell(
        dogBreed,
        allowTapAction: false,
      );
      cells.add(cell);
    }

    return cells;
  }
}

class DBBreedsGridViewCell extends StatefulWidget {
  final DBDogBreedsModel dogBreed;
  final bool allowTapAction;
  // final Future<String> loadImageFuture;

  DBBreedsGridViewCell(this.dogBreed, {this.allowTapAction = true});

  @override
  State<StatefulWidget> createState() => _DBBreedsGridViewCellState();
}

class _DBBreedsGridViewCellState extends State<DBBreedsGridViewCell> {
  // var _imageUrl = 'no-url';

  @override
  void initState() {
    super.initState();

    // widget.loadImageFuture.then((imageUrl) {
    //   setState(() {
    //     _imageUrl = imageUrl;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(alignment: AlignmentDirectional.center, children: [
          Container(
            child: FadeInImage.assetNetwork(
              fit: BoxFit.scaleDown,
              placeholder: "images/placeholder-image.png",
              image: 'https://images.dog.ceo/breeds/clumber/n02101556_5387.jpg',
            ),
          ),
          Container(
              alignment: AlignmentDirectional.bottomCenter,
              child: Text(widget.dogBreed.name))
        ]),
        onTap: () {
          if (widget.allowTapAction) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DBSubBreedsListScreen()));
          }
        });
  }
}
