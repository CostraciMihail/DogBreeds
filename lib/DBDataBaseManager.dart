import 'dart:async';
import 'dart:ffi';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBExtensions.dart';

class DBDataBaseManager {
  static const _SUB_BREEDS_DB_NAME = "subbreeds_database.db";
  static const _SUB_BREEDS_TABLE_NAME = "SUB_BREEDS";

  Future<Database> _getDatabse() async {
    final databasesPathStr = await getDatabasesPath();
    return openDatabase(
      join(databasesPathStr, _SUB_BREEDS_DB_NAME),
    );
  }

  static final DBDataBaseManager _singleton = DBDataBaseManager._internal();

  factory DBDataBaseManager() => _singleton;

  // private constructor
  DBDataBaseManager._internal() {
    setUpDataBaseManager();
  }

  void setUpDataBaseManager() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();

    final databasesPathStr = await getDatabasesPath();
    print("db path: $databasesPathStr");

    openDatabase(
      join(databasesPathStr, _SUB_BREEDS_DB_NAME),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_SUB_BREEDS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, dogBreed TEXT, isFavorite BOOL, imageUrl TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertDogSubBreed(DBDogSubBreedModel subBreed,
      {ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace}) async {
    if (subBreed == null) return;

    final db = await _getDatabse();

    await db.insert(
      _SUB_BREEDS_TABLE_NAME,
      subBreed.toMap(),
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  Future<void> insertDogSubBreeds(List<DBDogSubBreedModel> subBreeds) async {
    if (subBreeds == null || subBreeds.isEmpty) return;

    final db = await _getDatabse();
    List<int> exceptIds = subBreeds.map((element) {
      return element.id;
    }).toList();

    final List<Map<String, dynamic>> foundItems = await db.query(
        _SUB_BREEDS_TABLE_NAME,
        columns: ["id"],
        where: "id IN(${exceptIds.join(', ')})");

    var listToInsert = subBreeds.where((element) {
      return !foundItems.toList().contains({"id": element.id});
    });
    if (listToInsert.isEmpty) {
      return Future<Void>.value();
    }

    listToInsert.forEach((subBreed) async {
      await insertDogSubBreed(subBreed);
    });
    return Future<Void>.value();
  }

  Future<List<DBDogSubBreedModel>> getAllFavoritesSubBreeds() async {
    final db = await _getDatabse();
    final List<Map<String, dynamic>> maps =
        await db.query(_SUB_BREEDS_TABLE_NAME);

    return List.generate(maps.length, (i) {
      return DBDogSubBreedModel(
          id: maps[i]['id'],
          name: maps[i]['name'],
          dogBreed: maps[i]['dogBreed'],
          isFavorite: (maps[i]['isFavorite'] as int).toBool(),
          imageUrl: maps[i]['imageUrl']);
    });
  }

  Future<List<DBDogSubBreedModel>> getFavoritesSubBreedsFor(
      String dogBreed) async {
    final db = await _getDatabse();
    final List<Map<String, dynamic>> maps =
        await db.query("$_SUB_BREEDS_TABLE_NAME WHERE dogBreed='$dogBreed';");

    return List.generate(maps.length, (i) {
      return DBDogSubBreedModel(
          id: maps[i]['id'],
          name: maps[i]['name'],
          dogBreed: maps[i]['dogBreed'],
          isFavorite: (maps[i]['isFavorite'] as int).toBool(),
          imageUrl: maps[i]['imageUrl']);
    });
  }

  Future<Void> delete(List<DBDogSubBreedModel> subBreeds) async {
    if (subBreeds.isEmpty) return Future<Void>.value();

    final db = await _getDatabse();

    List<int> subBreedIds = subBreeds.map((element) {
      return element.id;
    }).toList();

    db.rawDelete(
        'DELETE FROM $_SUB_BREEDS_TABLE_NAME WHERE id IN(${subBreedIds.join(', ')})');
    await db.close();
    return Future<Void>.value();
  }

  Future<Void> deleteAllDB() async {
    final db = await _getDatabse();
    db.rawDelete('DELETE FROM $_SUB_BREEDS_TABLE_NAME');
    await db.close();
    return Future<Void>.value();
  }
}
