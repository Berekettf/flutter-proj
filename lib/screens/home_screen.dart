import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //final TextEditingController _routeController = TextEditingController();
  List<Map<String, String>> _busList = [];
  String _selectedRoute = 'Megenagna-6kilo'; // Default route
  final List<String> _routes = ['Megenagna-6kilo', 'Bole-Mercato', 'Piassa-Sarbet']; // Example routes

  @override
  void initState() {
    super.initState();
    _searchRoute(_selectedRoute); // Display default route buses
  }

  void _searchRoute(String route) {
    // Simulate fetching data based on route
    setState(() {
      _busList = [];
      if (route == 'Megenagna-6kilo') {
        _busList = [
          {'type': 'Mini Bus', 'id': '123'},
          {'type': 'City Bus', 'id': '456'},
          {'type': 'Express Bus', 'id': '789'},
        ]; // Example data for Megenagna-6kilo
      } else if (route == 'Bole-Mercato') {
        _busList = [
          {'type': 'Mini Bus', 'id': '321'},
          {'type': 'City Bus', 'id': '654'},
          {'type': 'Express Bus', 'id': '987'},
        ]; // Example data for Bole-Mercato
      } else if (route == 'Piassa-Sarbet') {
        _busList = [
          {'type': 'Mini Bus', 'id': '231'},
          {'type': 'City Bus', 'id': '564'},
          {'type': 'Express Bus', 'id': '879'},
        ]; // Example data for Piassa-Sarbet
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        title: const Text('Smart Public Bus App'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Search for available buses by selecting a route:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedRoute,
              items: _routes.map((String route) {
                return DropdownMenuItem<String>(
                  value: route,
                  child: Text(route),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRoute = newValue!;
                  _searchRoute(_selectedRoute);
                });
              },
              decoration: InputDecoration(
                hintText: 'Select Route',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _searchRoute(_selectedRoute);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Searching buses for route: $_selectedRoute')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Search'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _busList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      'Bus Type: ${_busList[index]['type']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      'ID: ${_busList[index]['id']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
