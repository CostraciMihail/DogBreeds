import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListViewModel.dart';

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
}

class DBBreedsGridViewCell extends StatefulWidget {
  final DBDogBreedsModel dogBreed;
  // final Future<String> loadImageFuture;

  DBBreedsGridViewCell(this.dogBreed);

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
    return Stack(
      children: <Widget>[
        FadeInImage.assetNetwork(
            fit: BoxFit.scaleDown,
            placeholder: 'images/placeholder-image.png',
            image: 'https://images.dog.ceo/breeds/clumber/n02101556_4826.jpg'),
        Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(widget.dogBreed.name),
          ),
        ),
      ],
    );
  }
}
