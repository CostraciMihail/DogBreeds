import 'package:DogBreeds/DBDogBreedsEnpoint.dart';
import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBExtensions.dart';

/// DBBreedsGridViewCell
///
class DBBreedsGridViewCell extends StatefulWidget {
  final DBDogBreedModel dogBreed;
  final DBDogSubBreedModel dogSubBreed;
  final bool allowTapAction;
  bool get isSubDogBreedType {
    return dogSubBreed != null;
  }

  final Function(BuildContext, DBDogBreedModel, DBDogSubBreedModel) onTapAction;

  DBBreedsGridViewCell(this.dogBreed, this.dogSubBreed,
      {this.allowTapAction = true, @required this.onTapAction});

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
        _imageUrl = snapshot.data;
        if (snapshot.hasData) {
          return FadeInImage.assetNetwork(
              placeholder: "images/placeholder-image.png", image: _imageUrl);
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
        child: widget.isSubDogBreedType
            ? Text(widget.dogSubBreed.name.capitalize())
            : Text(widget.dogBreed.name.capitalize()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(
            alignment: AlignmentDirectional.center,
            children: [_imageWidget, _titleWidget]),
        onTap: () {
          widget.onTapAction(context, widget.dogBreed, widget.dogSubBreed);
        });
  }

  // Helpers

  Future<String> _loadImage() {
    return widget.isSubDogBreedType
        ? _loadDogSubBreedImage()
        : _loadDogBreedImage();
  }

  Future<String> _loadDogBreedImage() async {
    return _endpoint
        .getBreedRadomImageUrl(widget.dogBreed.name)
        .then((urlString) {
      _imageUrl = urlString;
      widget.dogBreed.imageUrl = urlString;
      return Future<String>.value(urlString);
    }).catchError((error) {
      return Future<String>.error(error);
    });
  }

  Future<String> _loadDogSubBreedImage() async {
    return _endpoint
        .getSubBreedRadomImageUrl(widget.dogBreed.name, widget.dogSubBreed.name)
        .then((urlString) {
      _imageUrl = urlString;
      widget.dogSubBreed.imageUrl = urlString;
      return Future<String>.value(urlString);
    }).catchError((error) {
      return Future<String>.error(error);
    });
  }
}
