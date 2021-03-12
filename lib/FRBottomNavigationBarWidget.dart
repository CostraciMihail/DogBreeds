import 'package:flutter/material.dart';
import 'package:DogBreeds/Screens/DBBreedsList/DBBreedsListScreen.dart';
import 'package:DogBreeds/Screens/FavoritesSubBreeds/DBFavoritesSubBreedsScreen.dart';

class FRBottomNavigationBarWidget extends StatefulWidget {
  FRBottomNavigationBarWidget({Key key}) : super(key: key);

  @override
  _FRBottomNavigationBarWidgetState createState() =>
      _FRBottomNavigationBarWidgetState();
}

class _FRBottomNavigationBarWidgetState
    extends State<FRBottomNavigationBarWidget> {
  List<String> elements = [];
  var _selectedTabBarIndex = 0;
  List<BottomNavigationBarItem> tabBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.list), label: "Dog Breeds"),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites"),
  ];

  List<Widget> tabBarScreens = [
    DBBreedsListScreen(),
    DBFavoritesSubBreedsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTabBarIndex,
        children: tabBarScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: tabBarItems,
        currentIndex: _selectedTabBarIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  // Actions
  //
  void _onItemTapped(int index) {
    setState(() {
      _selectedTabBarIndex = index;
    });
  }
}
