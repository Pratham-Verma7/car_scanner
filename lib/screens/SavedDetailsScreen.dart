import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedDetailsScreen extends StatefulWidget {
  @override
  _SavedDetailsScreenState createState() => _SavedDetailsScreenState();
}

class _SavedDetailsScreenState extends State<SavedDetailsScreen> {
  late Map<String, String> savedDetails;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedDetails = {
        'Name': prefs.getString('name') ?? 'Not available',
        'Position': prefs.getString('position') ?? 'Not available',
        'Company': prefs.getString('company') ?? 'Not available',
        'Email': prefs.getString('email') ?? 'Not available',
        'Phone': prefs.getString('phone') ?? 'Not available',
        'Website': prefs.getString('website') ?? 'Not available',
        'Address': prefs.getString('address') ?? 'Not available',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Details'),
      ),
      body: savedDetails == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16),
              children: savedDetails.entries.map((entry) {
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      entry.key,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(entry.value),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
