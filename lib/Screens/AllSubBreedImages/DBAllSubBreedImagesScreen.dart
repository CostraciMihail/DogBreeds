import 'package:flutter/material.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';
import 'package:DogBreeds/DBExtensions.dart';

class DBAllSubBreedImagesScreen extends StatefulWidget {
  final DBDogBreedModel dogBreed;
  final DBDogSubBreedModel initialSubBreed;

  DBAllSubBreedImagesScreen(
      {Key key, @required this.dogBreed, @required this.initialSubBreed});

  @override
  _DBAllSubBreedImagesScreenState createState() =>
      _DBAllSubBreedImagesScreenState();
}

class _DBAllSubBreedImagesScreenState extends State<DBAllSubBreedImagesScreen> {
  String previousSubBreedImageUrl = 'no-url';
  String nextSubBreedImageUrl = 'no-url';
  String currentSubBreedImageUrl;
  int currentIndexOfSubBreed = 0;

  final endPoint = DBDogBreedsEnpoint();

  void _loadPreviousSubBreedImage() {
    if (currentIndexOfSubBreed <= 0) return;

    setState(() {
      currentIndexOfSubBreed -= 1;
      currentSubBreedImageUrl =
          widget.dogBreed.subBreeds[currentIndexOfSubBreed].imageUrl;
    });
  }

  void _loadNextSubBreedImage() {
    if (currentIndexOfSubBreed == widget.dogBreed.subBreeds.length - 1) return;

    setState(() {
      currentIndexOfSubBreed += 1;
      currentSubBreedImageUrl =
          widget.dogBreed.subBreeds[currentIndexOfSubBreed].imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();

    currentIndexOfSubBreed = 0;
    currentSubBreedImageUrl =
        widget.dogBreed.subBreeds[currentIndexOfSubBreed].imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.initialSubBreed.name.capitalize() ?? 'No name')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(currentSubBreedImageUrl ?? '', loadingBuilder:
              (BuildContext buildContext, Widget child,
                  ImageChunkEvent progress) {
            return progress == null ? child : CircularProgressIndicator();
          }, alignment: Alignment.topCenter, fit: BoxFit.fitWidth),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Previous",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onTap: () {
                  _loadPreviousSubBreedImage();
                },
              ),
              Text(
                "${currentIndexOfSubBreed + 1}/${widget.dogBreed.subBreeds.length}",
                style: TextStyle(fontSize: 20),
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onTap: () {
                  _loadNextSubBreedImage();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
