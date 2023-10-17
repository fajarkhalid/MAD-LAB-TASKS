import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _currentPosition;
  String? _currentAddress;
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();

  Future<bool> _handlePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Permission Denied");
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        debugPrint("Permission Denied! Change Settings");
        return false;
      }
    }
    return true;
  }

  _getCurrentLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      _addressFromCoordinates(_currentPosition!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _addressFromCoordinates(Position position) async {
    List<Placemark> places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final place = places[0];
    setState(() {
      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
    });
  }

  _getAddressFromCoordinates() async {
    double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    double longitude = double.tryParse(_longitudeController.text) ?? 0.0;

    List<Placemark> places = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (places.isNotEmpty) {
      final place = places[0];
      setState(() {
        _currentAddress =
            "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'LAT: ${_currentPosition?.latitude ?? "No position defined"}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text("Get Current Location"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _latitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Latitude'),
              ),
              TextField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Longitude'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getAddressFromCoordinates,
                child: Text("Get Address from Coordinates"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
