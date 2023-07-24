import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JourneyPlanningApp(),
    );
  }
}

class JourneyPlanningApp extends StatefulWidget {
  @override
  _JourneyPlanningAppState createState() => _JourneyPlanningAppState();
}

class _JourneyPlanningAppState extends State<JourneyPlanningApp> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  void _searchForMatches() async {
    final String searchQuery = _searchController.text;

    if (searchQuery.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      final String url =
          'https://mvvvip1.defas-fgi.de/mvv/XML_STOPFINDER_REQUEST?language=de&outputFormat=RapidJSON&type_sf=any&name_sf=$searchQuery';

      final response = await http.get(Uri.parse(url));

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData.containsKey('locations')) {
          final locations = decodedData['locations'];

          setState(() {
            _searchResults = List<Map<String, dynamic>>.from(locations);
          });
        } else {
          // Handle missing data or unexpected response format
          print('Invalid response format: ${response.body}');
        }
      } else {
        // Handle error if the request fails
        print('Error: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey Planning App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter starting point',
              ),
              onSubmitted: (_) => _searchForMatches(),
            ),
            SizedBox(height: 20),
            _isLoading // Show the loading indicator if _isLoading is true
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final match = _searchResults[index];
                        return ListTile(
                          title: Text(match['name']),
                          subtitle: Text(match['type']),
                          // Additional information can be displayed here as well
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
