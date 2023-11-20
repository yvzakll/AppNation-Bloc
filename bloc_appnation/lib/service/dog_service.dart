import 'dart:convert';
import 'package:http/http.dart' as http;

class DogApiService {
  final http.Client httpClient;

  DogApiService({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> fetchAllBreeds() async {
    final response =
        await httpClient.get(Uri.parse('https://dog.ceo/api/breeds/list/all'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['message'];
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  Future<String> fetchRandomImageForBreed(String breed) async {
    final response = await httpClient
        .get(Uri.parse('https://dog.ceo/api/breed/$breed/images/random'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['message'];
    } else {
      throw Exception('Failed to load breed image');
    }
  }

  Future<List<String>> fetchSubBreeds(String breed) async {
    final response = await httpClient
        .get(Uri.parse('https://dog.ceo/api/breed/$breed/list'));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<String>.from(body['message']);
    } else {
      throw Exception('Failed to load sub breeds');
    }
  }
}
