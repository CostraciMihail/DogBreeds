import 'package:DogBreeds/DBDogBreedsEnpoint.dart';
import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBExtensions.dart';
import 'package:provider/provider.dart';
import 'package:DogBreeds/DBProviders.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final Function(DBDogBreedModel, DBDogSubBreedModel, bool) onSelectionAction;

  DBBreedsGridViewCell(this.dogBreed, this.dogSubBreed,
      {this.allowTapAction = true,
      @required this.onTapAction,
      this.onSelectionAction});

  @override
  State<StatefulWidget> createState() => _DBBreedsGridViewCellState();
}

/// _DBBreedsGridViewCellState
///
class _DBBreedsGridViewCellState extends State<DBBreedsGridViewCell> {
  String _imageUrl;
  bool isImageLoaded = false;
  bool _isEditMode;
  bool _isSelected;
  final _endpoint = DBDogBreedsEnpoint();

  @override
  void initState() {
    super.initState();
    if (widget.isSubDogBreedType) {
      setState(() {
        _isSelected = widget.dogSubBreed.isFavorite;
      });
    }
  }

  Widget get _imageWidget {
    return Container(
        child: FutureBuilder(
      future: _loadImage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        _imageUrl = snapshot.data;

        if (snapshot.hasData) {
          return CachedNetworkImage(
            useOldImageOnUrlChange: true,
            placeholder: (context, url) =>
                Image(image: AssetImage('images/placeholder-image.png')),
            imageUrl: _imageUrl,
          );
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
        child: Container(
          width: 100,
          height: 100,
          alignment: Alignment.topCenter,
          child: Column(children: [
            overlaySlectionWidget(),
            Expanded(
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    child: _imageWidget)),
            _titleWidget
          ]),
        ),
        onTap: () => performTapAction());
  }

  void performTapAction() {
    if (_isEditMode && widget.isSubDogBreedType) {
      setState(() => _isSelected = !_isSelected);
      widget.dogSubBreed.isFavorite = _isSelected;
      widget.onSelectionAction(
          widget.dogBreed, widget.dogSubBreed, _isSelected);
    } else {
      widget.onTapAction(context, widget.dogBreed, widget.dogSubBreed);
    }
  }

  Widget overlaySlectionWidget() {
    return Consumer<ScreenState>(builder: (context, screenState, _) {
      _isEditMode = screenState.isEditMode;

      if (_isEditMode && widget.isSubDogBreedType) {
        return Container(
          alignment: Alignment.topRight,
          child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: _isSelected ? Colors.orange : Colors.grey[600],
                  shape: BoxShape.circle)),
        );
      } else if (widget.isSubDogBreedType && _isSelected) {
        return Container(
          alignment: Alignment.topRight,
          child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: _isSelected ? Colors.orange : Colors.grey[600],
                  shape: BoxShape.circle)),
        );
      } else {
        return Container();
      }
    });
  }

  // Helpers
  //
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
