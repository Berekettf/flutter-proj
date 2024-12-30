import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust height to remove unnecessary white space
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: const Color.fromARGB(255, 53, 57, 63),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'WhereBus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Track your bus in real-time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.facebook,
                          color: Colors.white),
                      onPressed: () {
                        // Handle Facebook action
                      },
                    ),
                    IconButton(
                      icon:
                          FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
                      onPressed: () {
                        // Handle Twitter action
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.instagram,
                          color: Colors.white),
                      onPressed: () {
                        // Handle Instagram action
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '© 2024 WhereBus. All rights reserved.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
