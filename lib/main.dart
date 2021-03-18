import 'package:DogBreeds/Screens/AllSubBreedImages/DBAllSubBreedImagesScreen.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListScreen.dart';
import 'package:DogBreeds/Screens/DBSubBreedsList/DBSubBreedsListScreen.dart';
import 'package:flutter/material.dart';
import 'package:DogBreeds/FRBottomNavigationBarWidget.dart';
import 'package:provider/provider.dart';
import 'package:DogBreeds/DBProviders.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ScreenState()),
    ChangeNotifierProvider(create: (_) => DBFavoritesSubBredsProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/main-screen': (context) => DBBreedsListScreen(),
        '/sub-breeds-screen': (context) => DBSubBreedsListScreen(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FRBottomNavigationBarWidget(),
    );
  }
}
