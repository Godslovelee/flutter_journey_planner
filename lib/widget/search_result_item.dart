///Created by: Godslove Lee
///Last edited: 25.07.2023
///Description: Search result Widget to display the query inputted in the text controller

import 'package:flutter/material.dart';
import 'package:mentz_coding_challenge/api/api_model.dart';

class JourneyPlanningApp extends StatefulWidget {
  const JourneyPlanningApp({super.key});

  @override
  _JourneyPlanningAppState createState() => _JourneyPlanningAppState();
}

class _JourneyPlanningAppState extends State<JourneyPlanningApp> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  void _searchForMatches() async {
    final String searchQuery = _searchController.text;

    setState(() {
      _isLoading = true;
    });

    // Call the searchForMatches method from the Api class
    _searchResults = await SearchAPI.searchForMatches(searchQuery);

    setState(() {
      _isLoading = false; // Set isLoading to false when search completes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Planning App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter starting point',
              ),
              onSubmitted: (_) => _searchForMatches(),
            ),
            SizedBox(height: 20),
            _isLoading // Show the loading indicator if _isLoading is true
                ? const CircularProgressIndicator()
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
