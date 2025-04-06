import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_page.dart'; // Import LoginPage for navigation and AuthService
// import 'state_selection_page.dart'; // No longer navigating here
import 'main_navigation_page.dart'; // Import for navigation back
// Import for AppColors

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  void _logout() {
    AuthService.logout();
    // Navigate back to LoginPage and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false, // Remove all routes
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch user details from the simulated service
    final String userName = AuthService.userName ?? 'N/A';
    final String userEmail = AuthService.userEmail ?? 'N/A';
    final String userPhone = AuthService.userPhone ?? 'N/A';

    // Use theme colors
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color errorColor = Theme.of(context).colorScheme.error;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // AppBar uses theme automatically
      appBar: AppBar(
        title: const Text('Profile'),
        // backgroundColor: AppColors.primary, // Uses theme
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.grey.shade400, // Lighter grey for placeholder icon
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileDetailRow(context, Icons.person_outline, 'Name', userName), // Pass context
            const SizedBox(height: 20),
            _buildProfileDetailRow(context, Icons.email_outlined, 'Email', userEmail), // Pass context
            const SizedBox(height: 20),
            _buildProfileDetailRow(context, Icons.phone_outlined, 'Phone', userPhone), // Pass context
            const Spacer(), // Pushes buttons to the bottom

            // Back/Done Button - Uses theme
             ElevatedButton(
              onPressed: () {
                 // Navigate back to the previous screen (should be MainNavigationPage)
                 if (Navigator.canPop(context)) {
                   Navigator.pop(context);
                 } else {
                   // Fallback if cannot pop (e.g., deep link) - go to main nav page
                   Navigator.pushReplacement(
                     context,
                     MaterialPageRoute(builder: (context) => const MainNavigationPage()),
                   );
                 }
              },
              child: const Text('Done'), // Changed text to 'Done'
            ),
            const SizedBox(height: 15), // Space between buttons

            // Logout Button - Uses theme but overrides color
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor, // Use theme's error color for logout
              ),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 20), // Some padding at the bottom
          ],
        ),
      ),
    );
  }

  // Helper widget to display profile details consistently using theme
  Widget _buildProfileDetailRow(BuildContext context, IconData icon, String label, String value) {
     final TextTheme textTheme = Theme.of(context).textTheme;
     final Color secondaryTextColor = Theme.of(context).colorScheme.onSurfaceVariant; // More appropriate secondary color

    return Row(
      children: [
        Icon(icon, color: secondaryTextColor, size: 28), // Use theme color
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: secondaryTextColor), // Use theme style
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: textTheme.titleMedium, // Use theme style
            ),
          ],
        ),
      ],
    );
  }
}
