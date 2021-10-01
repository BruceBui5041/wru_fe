import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wru_fe/screens/jouney.screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    const Text("Loading..."),
    const Text("Loading...")
  ];

  @override
  void initState() {
    _loadPages();
    super.initState();
  }

  void _loadPages() async {
    Position? position = await Geolocator.getLastKnownPosition();
    var jouneyPages = JouneyScreen(
      lastKnowUserLocation: position,
    );
    setState(() {
      _widgetOptions = <Widget>[
        jouneyPages,
        const Text(
          'Index 2: School',
          style: optionStyle,
        ),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // TODO Group
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.group),
          //   label: 'Groups',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Jouney',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
