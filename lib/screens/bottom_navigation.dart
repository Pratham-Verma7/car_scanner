import 'package:card_scanner/screens/report.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Default selected index (Home tab)

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    ReportScreen(),
    MediaPage(),
    TeamPage(),
  ];

  // Function to change the selected tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Example'),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Media',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Team',
          ),
        ],
      ),
    );
  }
}

class MediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Media Page'));
  }
}

class TeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Team Page'));
  }
}
