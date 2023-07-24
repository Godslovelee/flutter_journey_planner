
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchAPI {
  static Future<List<Map<String, dynamic>>> searchForMatches(String searchQuery) async {
    if (searchQuery.isEmpty) {
      return []; // Return an empty list if the search query is empty
    }

    final String url =
        'https://mvvvip1.defas-fgi.de/mvv/XML_STOPFINDER_REQUEST?language=de&outputFormat=RapidJSON&type_sf=any&name_sf=$searchQuery';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData.containsKey('locations')) {
        final locations = decodedData['locations'];
        return List<Map<String, dynamic>>.from(locations);
      } else {
        // Handle missing data or unexpected response format
        print('Invalid response format: ${response.body}');
        return [];
      }
    } else {
      // Handle error if the request fails
      print('Error: ${response.statusCode}');
      return [];
    }
  }



  }
