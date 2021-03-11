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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FRBottomNavigationBarWidget(),
    );
  }
}
