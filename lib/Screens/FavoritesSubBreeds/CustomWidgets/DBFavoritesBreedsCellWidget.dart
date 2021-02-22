import 'package:DogBreeds/DBDogBreedsEnpoint.dart';
import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBExtensions.dart';
import 'package:DogBreeds/DBProviders.dart';
import 'package:provider/provider.dart';

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
  String _imageUrl;
  bool _isEditMode = false;
  bool _isSelected = false;
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
          // return Icon(Icons.warning_amber_rounded);
          return Container(color: Colors.red[700]);
        } else {
          return Image(image: AssetImage('images/placeholder-image.png'));
        }
      },
    ));
  }

  Widget get _titleWidget {
    return Container(
        alignment: AlignmentDirectional.bottomCenter,
        child: Text(widget.dogSubBreed.dogBreed));
  }

  Widget get _subTitleWidget {
    return Container(
        alignment: AlignmentDirectional.bottomCenter,
        child: Text(widget.dogSubBreed.name.capitalize()));
  }

  @required
  @override
  void initState() {
    super.initState();
    setState(() => _isSelected = widget.dogSubBreed.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(children: [
            overlaySlectionWidget(),
            Expanded(
                child: FittedBox(
                    alignment: Alignment.topCenter, child: _imageWidget)),
            _titleWidget,
            _subTitleWidget
          ]),
        ),
        onTap: () {
          performTapAction();
        });
  }

  Widget overlaySlectionWidget() {
    return Consumer<ScreenState>(builder: (context, screenState, _) {
      _isEditMode = screenState.isEditMode;
      if (!_isEditMode) _isSelected = true;

      return Container(
        alignment: Alignment.topRight,
        child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: _isSelected ? Colors.orange : Colors.grey[600],
                shape: BoxShape.circle)),
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
