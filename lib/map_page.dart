import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'dart:convert'; // For decoding JSON
import 'package:flutter/services.dart' show rootBundle; // For loading local JSON asset

// Import the next page for navigation
import 'groficy_options_page.dart'; // Assuming this page will be created

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapShapeSource _mapSource;
  late List<MapModel> _stateData; // To hold state names and potentially other data
  int? _selectedIndex; // Index of the currently selected state
  final List<String> _preMarkedStates = ['Maharashtra', 'Karnataka', 'Tamil Nadu']; // Example pre-marked states

  @override
  void initState() {
    super.initState();
    _stateData = []; // Initialize empty
    _loadJsonData(); // Load GeoJSON and prepare data
  }

  Future<void> _loadJsonData() async {
    // IMPORTANT: Ensure you have a GeoJSON file for India states at 'assets/india_states.json'
    // You can find such files online (e.g., search for "india states geojson")
    try {
      final String response = await rootBundle.loadString('assets/india_states.json');
      final Map<String, dynamic> jsonData = json.decode(response);
      final List features = jsonData['features'];

      setState(() {
         _stateData = List<MapModel>.generate(
           features.length,
           (int index) {
             final properties = features[index]['properties'];
             // Adjust 'name_1' based on the actual property name for the state in your GeoJSON
             final stateName = properties['name_1'] ?? properties['NAME_1'] ?? 'Unknown';
             return MapModel(stateName);
           },
         );

        _mapSource = MapShapeSource.asset(
          'assets/india_states.json',
          shapeDataField: 'name_1', // Key in GeoJSON properties to match with _stateData
          dataCount: _stateData.length,
          primaryValueMapper: (int index) => _stateData[index].state,
          // Initial highlighting based on _preMarkedStates
          shapeColorValueMapper: (int index) {
             if (_preMarkedStates.contains(_stateData[index].state)) {
               return Colors.orange.shade300; // Color for pre-marked states
             }
             return null; // Default color
          },
          // Highlighting for the selected state
          //shapeDataValueMapper: (int index) => _stateData[index].state, // Pass state name for selection check
        );
      });
    } catch (e) {
       print('Error loading GeoJSON: $e');
       // Handle error, maybe show a message to the user
       setState(() {
          // Set a dummy source or show an error message widget
          _mapSource = const MapShapeSource.asset('assets/india_states.json'); // Will likely fail again, but prevents null error
       });
    }
  }


  void _handleStateTap(int index) {
    setState(() {
      _selectedIndex = index;
      // Update map source to reflect new selection visually
       _mapSource = MapShapeSource.asset(
          'assets/india_states.json',
          shapeDataField: 'name_1',
          dataCount: _stateData.length,
          primaryValueMapper: (int i) => _stateData[i].state,
          shapeColorValueMapper: (int i) {
             if (i == _selectedIndex) {
               return Colors.green.shade700; // Selected state color
             } else if (_preMarkedStates.contains(_stateData[i].state)) {
                return Colors.orange.shade300; // Pre-marked state color
             }
             return null; // Default color
          },
          //shapeDataValueMapper: (int i) => _stateData[i].state,
        );
    });

    // Add a small delay before navigating for visual feedback
    Future.delayed(const Duration(milliseconds: 300), () {
       if (_selectedIndex != null) {
          print('Selected State: ${_stateData[_selectedIndex!].state}');
          // Navigate to Groficy Options Page
          Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => GroficyOptionsPage(selectedState: _stateData[_selectedIndex!].state)),
          );
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your State'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _stateData.isEmpty
            ? const CircularProgressIndicator() // Show loading indicator while data loads
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfMaps(
                  layers: <MapLayer>[
                    MapShapeLayer(
                      source: _mapSource,
                      showDataLabels: true, // Optionally show state names
                      strokeColor: Colors.white,
                      strokeWidth: 0.5,
                      // Data label settings (optional)
                      dataLabelSettings: const MapDataLabelSettings(
                         textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10, // Adjust font size as needed
                         ),
                         overflowMode: MapLabelOverflow.hide, // Hide labels that overflow
                      ),
                      // Selection settings
                      selectionSettings: const MapSelectionSettings(
                         color: Colors.green, // Color when selected
                         strokeColor: Colors.white,
                         strokeWidth: 1.5,
                      ),
                      // Tooltip settings (optional)
                      tooltipSettings: const MapTooltipSettings(
                         color: Colors.black87,
                         strokeColor: Colors.white,
                         //TextStyle: TextStyle(color: Colors.white, fontSize: 12)
                      ),
                      // Handle tap events
                      onSelectionChanged: (int index) {
                         _handleStateTap(index);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// Simple model class for state data
class MapModel {
  MapModel(this.state);
  final String state;
}
