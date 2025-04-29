import 'dart:async'; // Add this line at the top
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _busIdController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late MapController _mapController;
  StreamSubscription<DatabaseEvent>? _locationSubscription;
  LatLng? _currentBusPosition;
  String _busInfo = 'Enter a bus ID to track';
  bool _isTracking = false;
  bool _showManualPanel = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // Initialize with default values for manual input
    _latController.text = '9.03';
    _lngController.text = '38.74';

    // Add the test database call here
    testDatabase(); // <-- Add this line
  }

// Add this method anywhere in your _MapScreenState class
  void testDatabase() async {
    try {
      await _database
          .child('test')
          .set({'timestamp': DateTime.now().toString()});
      print('Database write successful');
    } catch (e) {
      print('Database error: $e');
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _busIdController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _startTracking(String busId) {
    _locationSubscription?.cancel();
    setState(() {
      _isTracking = true;
      _busInfo = 'Tracking Bus ID: $busId';
    });

    _locationSubscription =
        _database.child('buses/$busId/location').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && mounted) {
        final lat = data['latitude'] as double;
        final lng = data['longitude'] as double;
        final timestamp = data['timestamp'] as int;

        setState(() {
          _currentBusPosition = LatLng(lat, lng);
          _busInfo = 'Bus ID: $busId\n'
              'Location: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}\n'
              'Last update: ${DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal()}';
        });

        _mapController.move(_currentBusPosition!, _mapController.zoom);
      }
    });
  }

  void _stopTracking() {
    _locationSubscription?.cancel();
    setState(() {
      _isTracking = false;
      _busInfo = 'Tracking stopped';
    });
  }

  Future<void> _submitManualLocation() async {
    if (_busIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Bus ID')),
      );
      return;
    }

    try {
      final lat = double.tryParse(_latController.text);
      final lng = double.tryParse(_lngController.text);

      if (lat == null || lng == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid latitude or longitude')),
        );
        return;
      }

      await _database.child('buses/${_busIdController.text}/location').set({
        'latitude': lat,
        'longitude': lng,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Location updated for Bus ${_busIdController.text}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showManualPanel = !_showManualPanel;
          });
        },
        child: Icon(_showManualPanel ? Icons.map : Icons.edit_location),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentBusPosition ?? const LatLng(9.03, 38.74),
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (_currentBusPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40,
                      height: 40,
                      point: _currentBusPosition!,
                      child: const Icon(
                        Icons.directions_bus,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _busIdController,
                            decoration: InputDecoration(
                              labelText: 'Bus ID',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  if (_busIdController.text.isNotEmpty) {
                                    _startTracking(_busIdController.text);
                                  }
                                },
                              ),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _startTracking(value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isTracking)
                          IconButton(
                            icon: const Icon(Icons.stop, color: Colors.red),
                            onPressed: _stopTracking,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _busInfo,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showManualPanel)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text(
                        'Manual Location Update',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _latController,
                              decoration: const InputDecoration(
                                labelText: 'Latitude',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _lngController,
                              decoration: const InputDecoration(
                                labelText: 'Longitude',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _submitManualLocation,
                        child: const Text('Submit Location'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
