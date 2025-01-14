import 'package:card_scanner/screens/report.dart';
import 'package:flutter/material.dart';

import '../services/storage.dart';
import 'history_screen.dart';


class MyHomePage extends StatefulWidget {
  final StorageService storageService;
  const MyHomePage({Key? key, required this.storageService}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Default selected index (Home tab)

  // List of pages corresponding to each tab
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ReportScreen(storageService: widget.storageService),
      MediaPage(),
      TeamPage(),
    ];
  }

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
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            // Your navigation logic, e.g., open a drawer or a side menu
          },
        ),
        title: Align(
          alignment: Alignment.center, // Centers the title
          child: Text(
            'Participants',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.history, // Replace with your desired icon
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryScreen(
                  storageService: widget.storageService,
                ),
              ),
            );
            },
          ),
        ],
      ),

      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: 'Report',
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
