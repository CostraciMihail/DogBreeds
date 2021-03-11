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

  static const _titleTextStyle =
      TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);

  final _clipedPlaceholder = ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image(
          fit: BoxFit.cover,
          image: AssetImage('images/placeholder-image.png')));

  Widget get _imageWidget {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: _loadImage(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            _imageUrl = snapshot.data;

            if (snapshot.hasData) {
              return CachedNetworkImage(
                fit: BoxFit.cover,
                useOldImageOnUrlChange: true,
                placeholder: (context, url) => SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: _clipedPlaceholder),
                imageUrl: _imageUrl,
              );
            } else {
              return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: _clipedPlaceholder);
            }
          },
        ));
  }

  Widget get _titleWidget {
    return SizedBox(
        child: widget.isSubDogBreedType
            ? Text(
                widget.dogSubBreed.name.capitalize(),
                style: _titleTextStyle,
                maxLines: 2,
                overflow: TextOverflow.clip,
              )
            : Text(widget.dogBreed.name.capitalize(),
                textAlign: TextAlign.center, style: _titleTextStyle));
  }

  // Initialization
  //
  @override
  void initState() {
    super.initState();
    markAsSelectedOrNot();
  }

  // Build
  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [_imageWidget, _titleWidget, overlaySlectionWidget()],
            )),
        onTap: () => performTapAction());
  }

  // UI SetUp
  //
  Widget overlaySlectionWidget() {
    return Consumer<ScreenState>(builder: (context, screenState, _) {
      _isEditMode = screenState.isEditMode;

      if (_isEditMode && widget.isSubDogBreedType) {
        return circleWidget();
      } else if (widget.isSubDogBreedType && _isSelected) {
        return circleWidget();
      } else {
        return Container();
      }
    });
  }

  Widget circleWidget() {
    return Padding(
        padding: EdgeInsets.only(right: 7, top: 7),
        child: Container(
          alignment: Alignment.topRight,
          child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: _isSelected ? Colors.orange : Colors.grey[600],
                  shape: BoxShape.circle)),
        ));
  }

  // Actions
  //
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

  // Loading Data
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

  // Helpers
  //
  void markAsSelectedOrNot() {
    if (widget.isSubDogBreedType) {
      setState(() {
        _isSelected = widget.dogSubBreed.isFavorite;
      });
    }
  }
}
