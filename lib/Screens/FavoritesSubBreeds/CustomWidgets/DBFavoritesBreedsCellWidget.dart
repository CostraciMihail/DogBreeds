import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBExtensions.dart';
import 'package:DogBreeds/DBProviders.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';

/// DBBreedsGridViewCell
///
class DBFavoritesBreedsCellWidget extends StatefulWidget {
  final DBDogSubBreedModel dogSubBreed;
  final bool allowTapAction;
  final Function(DBDogBreedModel, DBDogSubBreedModel, bool) onSelectionAction;
  final Function(DBDogSubBreedModel) onTapAction;

  DBFavoritesBreedsCellWidget(this.dogSubBreed,
      {this.allowTapAction = true,
      @required this.onTapAction,
      @required this.onSelectionAction});

  @override
  State<StatefulWidget> createState() => _DBFavoritesBreedsCellWidgetState();
}

/// _DBBreedsGridViewCellState
///
class _DBFavoritesBreedsCellWidgetState
    extends State<DBFavoritesBreedsCellWidget> {
  // Properties
  //
  String _imageUrl;
  bool _isEditMode = false;
  bool _isSelected = false;
  final _endpoint = DBDogBreedsEnpoint();

  // UI Properties
  //
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

  static const _titleTextStyle =
      TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);

  Widget get _titleWidget {
    return Container(
        alignment: AlignmentDirectional.bottomCenter,
        child: Text(widget.dogSubBreed.dogBreed.capitalize(),
            style: _titleTextStyle));
  }

  Widget get _subTitleWidget {
    return Container(
        alignment: AlignmentDirectional.bottomCenter,
        child:
            Text(widget.dogSubBreed.name.capitalize(), style: _titleTextStyle));
  }

  //
  // Initialization
  //
  @override
  void initState() {
    super.initState();
    setState(() => _isSelected = widget.dogSubBreed.isFavorite);
  }

  //
  // Build
  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _imageWidget,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  textDirection: TextDirection.ltr,
                  children: [_titleWidget, _subTitleWidget],
                ),
                overlaySlectionWidget()
              ],
            )),
        onTap: () => performTapAction());
  }

  //
  // UI
  //
  Widget overlaySlectionWidget() {
    return Consumer<ScreenState>(builder: (context, screenState, _) {
      _isEditMode = screenState.isEditMode;
      if (!_isEditMode) _isSelected = true;

      return Padding(
        padding: EdgeInsets.only(top: 7, right: 7),
        child: Container(
          alignment: Alignment.topRight,
          child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: _isSelected ? Colors.orange : Colors.grey[600],
                  shape: BoxShape.circle)),
        ),
      );
    });
  }

  // Actions
  //
  void performTapAction() {
    if (_isEditMode) {
      setState(() => _isSelected = !_isSelected);
      widget.onSelectionAction(null, widget.dogSubBreed, _isSelected);
    } else {
      widget.onTapAction(widget.dogSubBreed);
    }
  }

  // Helpers
  //
  Future<String> _loadImage() async {
    return _endpoint
        .getSubBreedRadomImageUrl(
            widget.dogSubBreed.dogBreed, widget.dogSubBreed.name)
        .then((urlString) {
      _imageUrl = urlString;
      widget.dogSubBreed.imageUrl = urlString;
      return Future<String>.value(urlString);
    }).catchError((error) {
      return Future<String>.error(error);
    });
  }
}
