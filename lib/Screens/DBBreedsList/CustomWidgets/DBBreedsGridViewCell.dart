import 'package:DogBreeds/DBDogBreedsEnpoint.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListScreen.dart';
import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListViewModel.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListViewModel.dart';

/// DBBreedsGridViewCell
///
class DBBreedsGridViewCell extends StatefulWidget {
  final DBDogBreedsModel dogBreed;
  final bool allowTapAction;

  DBBreedsGridViewCell(this.dogBreed, {this.allowTapAction = true});

  @override
  State<StatefulWidget> createState() => _DBBreedsGridViewCellState();
}

/// _DBBreedsGridViewCellState
///
class _DBBreedsGridViewCellState extends State<DBBreedsGridViewCell> {
  String _imageUrl;
  bool isImageLoaded = false;
  final _endpoint = DBDogBreedsEnpoint();

  Widget get _imageWidget {
    return Container(
        child: FutureBuilder(
      future: _loadImage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return FadeInImage.assetNetwork(
              // fit: BoxFit.fitHeight,
              placeholder: "images/placeholder-image.png",
              image: snapshot.data);
        } else if (snapshot.hasError) {
          return Icon(Icons.warning_amber_rounded);
        } else {
          return Image(image: AssetImage('images/placeholder-image.png'));
        }
      },
    ));
  }

  Widget get _titleWidget {
    return Container(
        alignment: AlignmentDirectional.bottomCenter,
        child: Text(widget.dogBreed.name));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(
            alignment: AlignmentDirectional.center,
            children: [_imageWidget, _titleWidget]),
        onTap: () {
          moveToNextScreen(context);
        });
  }

  // Actions
  void moveToNextScreen(BuildContext context) {
    if (widget.allowTapAction) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DBSubBreedsListScreen()));
    }
  }

  // Helpers
  Future<String> _loadImage() async {
    return _endpoint
        .getBreedRadomImageUrl(widget.dogBreed.name)
        .then((urlString) {
      _imageUrl = urlString;
      return Future<String>.value(urlString);
    }).catchError((error) {
      return Future<String>.error(error);
    });
  }
}

/// DBBreedsGridViewCellFactory
///
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
      DBDogBreedsModel dogBreed, DBSubBreedsListViewModel viewModel) {
    var cells = List<DBBreedsGridViewCell>();

    for (var subBreed in dogBreed.subBreeds) {
      var cell = DBBreedsGridViewCell(
        dogBreed,
        allowTapAction: false,
      );
      cells.add(cell);
    }

    return cells;
  }
}
