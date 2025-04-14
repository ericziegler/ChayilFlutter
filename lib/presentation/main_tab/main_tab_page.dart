import 'package:flutter/material.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/presentation/ranks/ranks_page.dart';
import 'package:chayil/presentation/categories/categories_page.dart';
import 'package:chayil/presentation/more/more_page.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({Key? key}) : super(key: key);

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onItemTapped(int index) {
    if (_currentIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Navigator(
            key: _navigatorKeys[0],
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const RanksPage(),
            ),
          ),
          Navigator(
            key: _navigatorKeys[1],
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const CategoriesPage(),
            ),
          ),
          Navigator(
            key: _navigatorKeys[2],
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const MorePage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/tab-belt.png')),
            label: 'Belts',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/tab-category.png')),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/tab-fist.png')),
            label: 'More',
          ),
        ],
        selectedItemColor: accentColor,
        unselectedItemColor: toolbarIconColor,
        backgroundColor: toolbarColor,
      ),
    );
  }
}
