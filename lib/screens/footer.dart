import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color.fromARGB(255, 53, 57, 63),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'WhereBus',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Track your bus in real-time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.facebook,
                    color: Colors.white),
                onPressed: () {
                  // Handle Facebook action
                },
              ),
              IconButton(
                icon:
                    const FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
                onPressed: () {
                  // Handle Twitter action
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.instagram,
                    color: Colors.white),
                onPressed: () {
                  // Handle Instagram action
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '© 2025 WhereBus. All rights reserved.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
