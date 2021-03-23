// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
@Timeout(Duration(seconds: 3))

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:matcher/src/equals_matcher.dart';

import 'package:DogBreeds/DBDogBreedModel.dart';
import 'package:DogBreeds/DBDogBreedsEnpoint.dart';
import 'package:DogBreeds/DBClientAPI.dart';
import 'package:DogBreeds/DBMock.dart';
import 'MockClientAPI.dart';

void main() {
  group("Testing DBDogBreedsEnpoint", () {
    final mockClient = MockClientAPI();

    test("getAllDogBreeds()", () async {
      final jsonString = """
            { "message": { "appenzeller": [],
                          "australian": ["shepherd"]
                         }
            }
        """;

      when(mockClient.makeRequest(DBDogBreedsEnpoint.hostName,
              '/api/breeds/list/all', DBRequestMethod.GET))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      final results =
          await DBDogBreedsEnpoint(apiClient: mockClient).getAllDogBreeds();

      expect(results, isA<List<DBDogBreedModel>>());
      expect(results.length, equals(2));
    });

    test("getAllDogSubBreeds()", () async {
      final jsonString = """
            { "message": [ "american",
                          "australian",
                          "bedlington",
                          "border",
                          "dandie"
                          ]
            }
        """;

      final dogBreed = DBDogBreedModel(
          id: 1,
          name: "breed_name",
          subBreeds: [],
          imageUrl: "empty_image_url");

      when(mockClient.makeRequest(DBDogBreedsEnpoint.hostName,
              '/api/breed/${dogBreed.name}/list', DBRequestMethod.GET))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      final results = await DBDogBreedsEnpoint(apiClient: mockClient)
          .getAllDogSubBreeds(dogBreed);

      expect(results, isA<DBDogBreedModel>());
      expect(results.subBreeds, isA<List<DBDogSubBreedModel>>());
      expect(results.subBreeds.length, equals(5));
    });

    test("getBreedRadomImageUrl()", () async {
      final jsonString = """
            {
            "message": "https://images.dog.ceo/breeds/clumber/n02101556_5903.jpg",
             "status": "success"
            }
        """;

      final dogBreedName = "breed_name";

      when(mockClient.makeRequest(
              DBDogBreedsEnpoint.hostName,
              "/api/breed/${dogBreedName.toLowerCase()}/images/random",
              DBRequestMethod.GET))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      final results = await DBDogBreedsEnpoint(apiClient: mockClient)
          .getBreedRadomImageUrl(dogBreedName);

      expect(results, isA<String>());
      expect(results.isNotEmpty, true);
    });

    test("getSubBreedRadomImageUrl()", () async {
      final jsonString = """
            {
            "message": "https://images.dog.ceo/breeds/clumber/n02101556_5903.jpg",
             "status": "success"
            }
        """;

      final dogBreedName = "breed_name";
      final dogSubBreedName = "subBreed_name";

      when(mockClient.makeRequest(
              DBDogBreedsEnpoint.hostName,
              "/api/breed/${dogBreedName.toLowerCase()}/${dogSubBreedName.toLowerCase()}/images/random",
              DBRequestMethod.GET))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      final results = await DBDogBreedsEnpoint(apiClient: mockClient)
          .getSubBreedRadomImageUrl(dogBreedName, dogSubBreedName);

      expect(results, isA<String>());
      expect(results.isNotEmpty, true);
    });

    test("getAllBreedRadomImagesUrlFor()", () async {
      final jsonString = """
            {
            "message": [
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg",
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_1023.jpg",
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg",
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_10263.jpg",
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_10715.jpg",
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_10822.jpg",
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_10832.jpg",
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_10982.jpg",
              "https://images.dog.ceo/breeds/hound-afghan/n02088094_11006.jpg"
              ]
            }
        """;

      final dogBreed = DBMock.mockDogBreed(name: 'hound');

      when(mockClient.makeRequest(
              DBDogBreedsEnpoint.hostName,
              "${DBDogBreedsEnpoint.allBreedImagesPath(dogBreed.name)}",
              DBRequestMethod.GET))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      final Map<String, dynamic> params = {
        "dogBreed": dogBreed,
        "apiClient": mockClient
      };

      final results = await getAllDogSubBreedsWithImages(params);

      expect(results, isA<Map<String, List<DBDogSubBreedModel>>>());
      expect(results.isNotEmpty, true);
      expect(results.length, equals(1));
      expect(results[results.keys.first].length, equals(9));
    });
  });
}
