import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wru_fe/screens/journey.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
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
    var journeyPages = JourneyScreen(
      lastKnowUserLocation: position,
    );
    setState(() {
      _widgetOptions = <Widget>[
        journeyPages,
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
            label: 'Journey',
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
