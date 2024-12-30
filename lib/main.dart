import 'package:flutter/material.dart';
import 'auth/login_card.dart';
import 'auth/signup_card.dart';
import 'home/hero.dart';
import 'home/footer.dart';
//import 'home/bus_tracking_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'BusWhere?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 43, 47, 53),
          elevation: 10,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Settings') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginCard()),
                      );
                    }
                    if (value == 'signup') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpCard()),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'signup',
                        child: ListTile(
                          leading: Icon(Icons.person_add, color: Colors.green),
                          title: Text('Sign Up',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Settings',
                        child: ListTile(
                          leading: Icon(Icons.settings, color: Colors.blue),
                          title: Text('Settings',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ];
                  },
                  icon: Icon(Icons.menu, color: Colors.white),
                  offset: Offset(
                      0, 40), // Adjust the offset to start below the icon
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10), // Add top border radius
                      bottom: Radius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                color: const Color.fromARGB(
                    255, 53, 57, 63), // Match footer background color
                child: Column(
                  children: [
                    HeroSection(),
                    // Add the BusTrackingSection here
                    Center(
                      child: Text('Welcome to BusWhere? platform'),
                    ),

                    SizedBox(
                      height: 250, // Set a fixed height for the footer
                      child: FooterSection(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                backgroundColor:
                    Color.fromARGB(255, 142, 192, 26), // Green button
                onPressed: () {
                  // Handle Contact Us action
                },
                icon: Icon(Icons.message),
                label: Text("Contact Us"),
              ),
            ),
          ],
        ),
      ),
      routes: {
        '/login': (context) => LoginCard(),
        '/signup': (context) => SignUpCard(),
      },
    );
  }
}
