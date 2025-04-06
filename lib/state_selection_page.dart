import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'groficy_options_page.dart'; // Assuming this page will be created next
import 'login_page.dart'; // Import for AuthService
import 'profile_page.dart'; // Import for navigation

// Model for state data
class IndianState {
  final String name;
  final String favoriteDish; // Placeholder

  IndianState({required this.name, required this.favoriteDish});
}

class StateSelectionPage extends StatefulWidget {
  const StateSelectionPage({super.key});

  @override
  _StateSelectionPageState createState() => _StateSelectionPageState();
}

class _StateSelectionPageState extends State<StateSelectionPage> {
  // Sample list of Indian states and placeholder favorite dishes
  final List<IndianState> _indianStates = [
    IndianState(name: 'Andhra Pradesh', favoriteDish: 'Pesarattu'),
    IndianState(name: 'Arunachal Pradesh', favoriteDish: 'Thukpa'),
    IndianState(name: 'Assam', favoriteDish: 'Masor Tenga'),
    IndianState(name: 'Bihar', favoriteDish: 'Litti Chokha'),
    IndianState(name: 'Chhattisgarh', favoriteDish: 'Chila'),
    IndianState(name: 'Goa', favoriteDish: 'Fish Curry Rice'),
    IndianState(name: 'Gujarat', favoriteDish: 'Dhokla'),
    IndianState(name: 'Haryana', favoriteDish: 'Bajre ki Khichdi'),
    IndianState(name: 'Himachal Pradesh', favoriteDish: 'Madra'),
    IndianState(name: 'Jharkhand', favoriteDish: 'Dhuska'),
    IndianState(name: 'Karnataka', favoriteDish: 'Bisi Bele Bath'),
    IndianState(name: 'Kerala', favoriteDish: 'Appam with Stew'),
    IndianState(name: 'Madhya Pradesh', favoriteDish: 'Poha Jalebi'),
    IndianState(name: 'Maharashtra', favoriteDish: 'Vada Pav'),
    IndianState(name: 'Manipur', favoriteDish: 'Eromba'),
    IndianState(name: 'Meghalaya', favoriteDish: 'Jadoh'),
    IndianState(name: 'Mizoram', favoriteDish: 'Bai'),
    IndianState(name: 'Nagaland', favoriteDish: 'Smoked Pork with Bamboo Shoot'),
    IndianState(name: 'Odisha', favoriteDish: 'Pakhala Bhata'),
    IndianState(name: 'Punjab', favoriteDish: 'Makki di Roti & Sarson da Saag'),
    IndianState(name: 'Rajasthan', favoriteDish: 'Dal Baati Churma'),
    IndianState(name: 'Sikkim', favoriteDish: 'Momos'),
    IndianState(name: 'Tamil Nadu', favoriteDish: 'Pongal'),
    IndianState(name: 'Telangana', favoriteDish: 'Hyderabadi Biryani'),
    IndianState(name: 'Tripura', favoriteDish: 'Mui Borok'),
    IndianState(name: 'Uttar Pradesh', favoriteDish: 'Tunde Ke Kabab'),
    IndianState(name: 'Uttarakhand', favoriteDish: 'Kafuli'),
    IndianState(name: 'West Bengal', favoriteDish: 'Kosha Mangsho'),
    // Add Union Territories if needed
  ];

  String? _selectedState;

  void _selectState(IndianState state) {
    setState(() {
      _selectedState = state.name;
    });
    print('Selected State: $_selectedState');
    // Navigate to the Groficy Options Page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroficyOptionsPage(selectedState: _selectedState!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar uses theme
      appBar: AppBar(
        title: const Text('Select Your State'),
        // backgroundColor: Colors.green, // Uses theme
        leading: IconButton(
          icon: const Icon(Icons.account_circle), // Color from theme
          tooltip: 'Profile / Login',
          onPressed: () {
            if (AuthService.isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            } else {
              // Navigate to Login, allowing user to come back
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _indianStates.length,
        itemBuilder: (context, index) {
          final state = _indianStates[index];
          // ListTile uses theme
          return ListTile(
            title: Text(state.name),
            subtitle: Text('Try: ${state.favoriteDish}'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Theme.of(context).colorScheme.onSurfaceVariant), // Use theme color
            onTap: () => _selectState(state),
          );
        },
      ),
    );
  }
}
