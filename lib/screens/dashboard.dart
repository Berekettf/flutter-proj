import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'map_screen.dart';
import 'home_screen.dart';
import 'payment_screen.dart';
import 'profile_screen.dart';
import 'contact_us_screen.dart';
import 'welcome_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.title});

  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 1; // Default to HomeScreen
  final PageController _pageController = PageController(initialPage: 1);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 43, 47, 53),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const FaIcon(FontAwesomeIcons.ellipsisVertical,
                color: Colors.white),
            onSelected: (String result) {
              switch (result) {
                case 'Profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                  break;
                case 'Contact Us':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsScreen()),
                  );
                  break;
                case 'Log Out':
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Profile',
                child: ListTile(
                  leading:
                      FaIcon(FontAwesomeIcons.user, color: Colors.blueAccent),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Contact Us',
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.envelope,
                      color: Colors.greenAccent),
                  title: Text('Contact Us'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Log Out',
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.rightFromBracket,
                      color: Colors.redAccent),
                  title: Text('Log Out'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget>[
          MapScreen(),
          HomeScreen(),
          PaymentScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 43, 47, 53),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).toInt()),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.mapLocationDot,
                    color: Colors.blueAccent),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house, color: Colors.purple),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.creditCard,
                    color: Colors.yellowAccent),
                label: 'Payment',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: const Color.fromARGB(255, 43, 47, 53),
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
