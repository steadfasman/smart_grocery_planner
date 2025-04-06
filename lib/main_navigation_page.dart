import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:trailproj/insta_cook/insta_cook_category_screen.dart'; // No longer navigating here
import 'package:trailproj/insta_cook/insta_cook_menu_screen.dart'; // Import the menu screen
// import 'package:trailproj/insta_cook/insta_cook_flow.dart'; // No longer using the flow directly from here
import 'package:trailproj/day_planner_page.dart';
import 'package:trailproj/week_planner_page.dart';
import 'package:trailproj/insta_cook/insta_cook_custom_plan_flow.dart'; // Re-import Custom Plan
// For profile icon (can be moved to drawer)
// For profile icon logic (can be moved to drawer)
import 'app_drawer.dart'; // Import the AppDrawer

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use theme colors
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color tertiaryColor = Colors.blue.shade600; // Example color for Day Plan
    final Color quaternaryColor = Colors.purple.shade600; // Example color for Week Plan

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        // The leading hamburger icon is added automatically when a drawer is present.
        // We can add actions if needed, e.g., profile icon here or move it to drawer.
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.account_circle),
        //     tooltip: 'Profile / Login',
        //     onPressed: () { /* Profile/Login logic */ },
        //   ),
        // ],
      ),
      drawer: const AppDrawer(), // Add the drawer here
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildNavigationCard(
            context: context,
            title: 'InstaCook',
            subtitle: 'Quick meal selection & order',
            icon: Icons.fastfood_outlined,
            color: secondaryColor, // Use accent color
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InstaCookMenuScreen(category: 'Breakfast')), // Navigate directly to menu screen, default to Breakfast
              );
            },
          ),
          const SizedBox(height: 16),
          _buildNavigationCard(
            context: context,
            title: 'Day Plan',
            subtitle: 'Plan your meals for a single day',
            icon: Icons.today_outlined,
            color: tertiaryColor, // Distinct color
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DayPlannerPage()), // Assuming this is the correct page
              );
            },
          ),
           const SizedBox(height: 16),
          _buildNavigationCard(
            context: context,
            title: 'Week Plan',
            subtitle: 'Plan your meals for the entire week',
            icon: Icons.calendar_view_week_outlined,
            color: quaternaryColor, // Distinct color
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeekPlannerPage()), // Assuming this is the correct page
              );
            },
          ),
          const SizedBox(height: 16), // Re-add spacer
           _buildNavigationCard( // Re-add Custom Plan Card
             context: context,
             title: 'Custom Plan',
             subtitle: 'Plan meals for specific dates',
             icon: Icons.calendar_month_outlined,
             color: primaryColor, // Use primary color
             onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const InstaCookCustomPlanFlow()),
               );
             },
           ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
             border: Border(left: BorderSide(color: color, width: 5)), // Colored side border
          ),
          child: Row(
            children: [
              Icon(icon, size: 40.0, color: color),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
