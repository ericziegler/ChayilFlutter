import 'package:flutter/material.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/presentation/rank/ranks_page.dart';
import 'package:chayil/presentation/category/categories_page.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/presentation/authentication/request_login_page.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({Key? key}) : super(key: key);

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;

  // Create a list of global keys for each navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // This function is used to switch tabs and handle back navigation within a tab
  void _onItemTapped(int index) {
    if (_currentIndex == index) {
      // Pop to first route if the user taps on the active tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
    UserRepository().onUserChanged.listen((user) {
      _checkUser();
    });
  }

  void _checkUser() async {
    var user = await UserRepository().loadUser();
    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RequestLoginPage()),
        (Route<dynamic> route) => false,
      );
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
        ],
        selectedItemColor: accentColor,
        unselectedItemColor: toolbarIconColor,
        backgroundColor: toolbarColor,
      ),
    );
  }
}
