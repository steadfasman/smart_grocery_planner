import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import for date formatting
// import 'insta_cook/insta_cook_flow.dart'; // No longer needed for history view
// import 'insta_cook/insta_cook_custom_plan_flow.dart'; // No longer needed for history view
// import 'day_planner_page.dart'; // No longer needed for history view
import 'grocery_list_page.dart'; // Import GroceryListPage
// Import menu items
// Import InstaCookMenuScreen

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Example meal plans for specific dates (used by Calendar)
  final Map<DateTime, List<Map<String, String>>> _mealPlans = {
    DateTime.utc(2025, 4, 5): [{'meal': 'Breakfast', 'dish': 'Dosa'}],
    DateTime.utc(2025, 4, 12): [{'meal': 'Lunch', 'dish': 'Biriyani'}],
    DateTime.utc(2025, 4, 19): [
      {'meal': 'Breakfast', 'dish': 'Dosa'},
      {'meal': 'Lunch', 'dish': 'Biriyani'},
      {'meal': 'Dinner', 'dish': 'Naan'}
    ],
    DateTime.utc(2025, 4, 20): [{'meal': 'Dinner', 'dish': 'Paneer Butter Masala'}],
    // Add more example past dates for history
    DateTime.utc(2025, 3, 28): [{'meal': 'Breakfast', 'dish': 'Idli'}],
    DateTime.utc(2025, 3, 25): [{'meal': 'Lunch', 'dish': 'Rice'}],
  };

  // Mock meal history data (replace with backend fetch later)
  final List<Map<String, dynamic>> _mealHistory = [
    {'date': DateTime.utc(2025, 4, 1), 'category': 'Breakfast', 'dish': 'Dosa'}, // Added Dosa example
    {'date': DateTime.utc(2025, 3, 28), 'category': 'Breakfast', 'dish': 'Idli'},
    {'date': DateTime.utc(2025, 3, 25), 'category': 'Lunch', 'dish': 'Rice'},
    {'date': DateTime.utc(2025, 3, 20), 'category': 'Dinner', 'dish': 'Naan'},
    {'date': DateTime.utc(2025, 3, 15), 'category': 'Breakfast', 'dish': 'Upma'},
  ];


  List<Map<String, String>> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _mealPlans[normalizedDay] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Menu',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildDrawerSection(
            context: context,
            title: "Today's Plan",
            // Replace content with a clickable ListTile
            content: ListTile(
              dense: true,
              title: const Text('Dosa (Breakfast)'), // Example for today
              subtitle: const Text('Today'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroceryListPage(
                      selectedItems: const {'Breakfast': 'Dosa'}, // Pass Dosa
                      showEditButton: true, // Enable edit for Today's Plan
                    ),
                  ),
                );
              },
            ),
            // Remove onTap from the section itself
          ),
          _buildDrawerSection(
            context: context,
            title: "Calendar",
            content: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCalendar(context),
            ),
          ),
          _buildDrawerSection(
            context: context,
            title: "Your Plans", // Changed to Meal History view
            content: _buildMealHistoryList(context), // Call helper to build history list
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to Settings Page
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement Logout Logic
            },
          ),
        ],
      ),
    );
  }

  // Helper to build the Meal History List
  Widget _buildMealHistoryList(BuildContext context) {
    if (_mealHistory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("No meal history found."),
      );
    }

    // Sort history by date descending
    _mealHistory.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add some horizontal padding
      child: Column(
        children: _mealHistory.map((historyEntry) {
          DateTime date = historyEntry['date'];
          String category = historyEntry['category'];
          String dish = historyEntry['dish'];
          String formattedDate = DateFormat('MMM d, yyyy').format(date);

          return ListTile(
            dense: true, // Make tiles more compact
            title: Text('$dish ($category)'),
            subtitle: Text(formattedDate),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              // Show details dialog or navigate directly
              _showHistoryMealDetails(context, date, category, dish);
            },
          );
        }).toList(),
      ),
    );
  }

  // Function to show details and navigate to grocery list
  void _showHistoryMealDetails(BuildContext context, DateTime date, String category, String dish) {
     // Option 1: Show Dialog first (like Calendar)
     /*
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('Meal on ${DateFormat('MMM d, yyyy').format(date)}'),
           content: Text('$dish ($category)'),
           actions: [
             TextButton(
               child: const Text('View Grocery List'),
               onPressed: () {
                 Navigator.pop(context); // Close dialog
                 Navigator.pop(context); // Close drawer
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => GroceryListPage(
                       selectedItems: {category: dish},
                       showEditButton: true, // Allow editing from history
                     ),
                   ),
                 );
               },
             ),
             TextButton(
               child: const Text('Close'),
               onPressed: () => Navigator.of(context).pop(),
             ),
           ],
         );
       },
     );
     */

     // Option 2: Navigate directly to Grocery List
     Navigator.pop(context); // Close drawer
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => GroceryListPage(
           selectedItems: {category: dish},
           showEditButton: true, // Allow editing from history
         ),
       ),
     );
  }


  Widget _buildDrawerSection({
    required BuildContext context,
    required String title,
    required Widget content,
    VoidCallback? onTap,
  }) {
    Widget tileContent = ExpansionTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      childrenPadding: const EdgeInsets.only(bottom: 8.0),
      initiallyExpanded: title == "Your Plans", // Keep history expanded by default
      children: [content],
    );

    Widget tileContainer = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: onTap != null
          ? InkWell( onTap: onTap, child: IgnorePointer(child: tileContent) )
          : tileContent,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: tileContainer,
    );
  }


  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2026, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        final events = _getEventsForDay(selectedDay);
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });

        if (events.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Meals for ${DateFormat('MMM d, yyyy').format(selectedDay)}'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: events.map((mealDetail) {
                      String mealTime = mealDetail['meal'] ?? 'Meal';
                      String dishName = mealDetail['dish'] ?? 'Unknown';
                      return TextButton(
                        child: Text('$dishName ($mealTime)'),
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          Navigator.pop(context); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroceryListPage(
                                selectedItems: {mealTime: dishName},
                                showEditButton: true,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      eventLoader: _getEventsForDay,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return null;
        },
      ),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
    );
  }
}
