import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedDetailsScreen extends StatefulWidget {
  @override
  _SavedDetailsScreenState createState() => _SavedDetailsScreenState();
}

class _SavedDetailsScreenState extends State<SavedDetailsScreen> {
  late List<Map<String, String>> history;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedHistory =
        prefs.getStringList('businessCardHistory') ?? [];

    setState(() {
      history = storedHistory
          .map((item) => Map<String, String>.from(jsonDecode(item)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Business Cards'),
      ),
      body: history.isEmpty
          ? Center(child: Text('No history available'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: item['imagePath'] != null
                        ? Image.file(
                            File(item['imagePath']!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : null,
                    title: Text(item['name'] ?? 'Unknown'),
                    subtitle: Text(item['email'] ?? 'No email'),
                  ),
                );
              },
            ),
    );
  }
}
