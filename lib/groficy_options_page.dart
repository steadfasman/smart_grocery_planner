import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'day_planner_page.dart'; // For navigation
import 'insta_cook/insta_cook_category_screen.dart'; // Import Insta Cook screen
import 'week_planner_page.dart'; // Import Week Planner page
// import 'custom_plan_page.dart'; // Keep commented if not implemented
import 'login_page.dart'; // For AuthService and navigation
import 'profile_page.dart'; // For navigation

class GroficyOptionsPage extends StatelessWidget {
  final String selectedState; // Receive selected state

  const GroficyOptionsPage({super.key, required this.selectedState});

  // Helper function to build option cards
  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    // Use CardTheme from main theme
    return Card(
      // elevation: 4.0, // Use theme default
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), // Use theme default
      clipBehavior: Clip.antiAlias, // Ensure ink splash respects border radius
      child: InkWell(
        onTap: onTap,
        // borderRadius: BorderRadius.circular(15.0), // InkWell takes shape from Card
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 50.0, color: color), // Keep specific icon color
              const SizedBox(height: 15.0),
              Text(
                title,
                textAlign: TextAlign.center,
                // Use theme text style
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color, // Use secondary text color
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppBar uses theme
    return Scaffold(
      appBar: AppBar(
        title: Text('Groficy - $selectedState'),
        // backgroundColor: Colors.green, // Uses theme
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
             DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Use theme color
              ),
              child: Text(
                AuthService.isLoggedIn ? (AuthService.userName ?? 'Menu') : 'Menu',
                // Use theme text style for drawer header
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
            ),
            // ListTile uses theme
            ListTile(
              leading: Icon(AuthService.isLoggedIn ? Icons.account_circle : Icons.login),
              title: Text(AuthService.isLoggedIn ? 'Profile' : 'Login'),
              onTap: () {
                Navigator.pop(context);
                if (AuthService.isLoggedIn) {
                  Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                } else {
                  Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
            ),
             ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Calendar'),
              onTap: () {
                // TODO: Implement Calendar view
                Navigator.pop(context); // Close drawer
                print('Calendar tapped');
              },
            ),
            const Divider(),
            // Only show Sign Out if logged in
            if (AuthService.isLoggedIn) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () {
                  AuthService.logout(); // Use AuthService to logout
                  Navigator.pop(context); // Close drawer
                  // Navigate back to Login page after signing out
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false, // Remove all previous routes
                  );
                },
              ),
            ]
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 options per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildOptionCard(
              context: context,
              icon: Icons.flash_on, // Example icon
              title: 'Insta Cook',
              color: Colors.orange,
              onTap: () {
                print('Insta Cook tapped');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InstaCookCategoryScreen()),
                );
              },
            ),
            _buildOptionCard(
              context: context,
              icon: Icons.calendar_view_day, // Example icon
              title: 'Plan for a Day',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DayPlannerPage()),
                );
              },
            ),
            _buildOptionCard(
              context: context,
              icon: Icons.calendar_view_week, // Example icon
              title: 'Plan for a Week',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeekPlannerPage()), // Navigate to Week Planner
                );
              },
            ),
             _buildOptionCard(
              context: context,
              icon: Icons.edit_calendar, // Example icon
              title: 'Plan for Custom Days',
              color: Colors.red,
              onTap: () {
                // TODO: Navigate to Custom Plan page
                print('Plan for Custom Days tapped');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => CustomPlanPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
