import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu_items.dart'; // For SideDishItem and allSideDishes
import 'week_grocery_list_page.dart'; // To navigate to next step
// For AppColors

class WeekSideDishPage extends StatefulWidget {
  // Updated type to handle quantities
  final Map<int, Map<String, Map<String, int>>> weeklyMainSelections; // Receive main dish selections with quantities

  const WeekSideDishPage({
    super.key,
    required this.weeklyMainSelections,
  });

  @override
  State<WeekSideDishPage> createState() => _WeekSideDishPageState();
}

class _WeekSideDishPageState extends State<WeekSideDishPage> {
  // State to hold selected side dishes for each day
  // Map<dayIndex, List<SideDishItem>>
  final Map<int, List<SideDishItem>> _weeklySideDishSelections = {};

  @override
  void initState() {
    super.initState();
    // Initialize the side dish map for days that have main selections (check if dish map is not empty)
    widget.weeklyMainSelections.forEach((dayIndex, categories) {
      bool dayHasMeals = categories.values.any((dishes) => dishes.isNotEmpty);
      if (dayHasMeals) {
        _weeklySideDishSelections[dayIndex] = []; // Initialize with empty list
      }
    });
  }

  // Callback to update side dish selection for a specific day
  void _updateSideDishes(int dayIndex, List<SideDishItem> selectedSides) {
    setState(() {
      _weeklySideDishSelections[dayIndex] = selectedSides;
    });
  }

  String _getDayName(int index) {
    const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return dayNames[index];
  }

  @override
  Widget build(BuildContext context) {
    // Filter days that actually have main course selections (any category has a non-empty dish map)
    final daysWithMeals = widget.weeklyMainSelections.entries
        .where((entry) => entry.value.values.any((dishes) => dishes.isNotEmpty))
        .map((entry) => entry.key) // Get only the day indices
        .toList()..sort(); // Sort the indices

    if (daysWithMeals.isEmpty) {
      // Should ideally not happen if navigation logic is correct, but handle defensively
      return Scaffold(
        appBar: AppBar(title: const Text('Select Side Dishes')),
        body: const Center(child: Text("No main dishes selected for any day.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Side Dishes'),
        // Remove leading to allow default back button when pushed
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: daysWithMeals.length,
              itemBuilder: (context, index) {
                final dayIndex = daysWithMeals[index];
                final mainMeals = widget.weeklyMainSelections[dayIndex]!;
                final currentSideDishes = _weeklySideDishSelections[dayIndex] ?? [];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDayName(dayIndex), // Display day name
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        // Iterate through categories and selected main meals (dishes with quantity > 0) for this day
                        ...mainMeals.entries.expand((categoryEntry) {
                           String mealCategory = categoryEntry.key;
                           Map<String, int> dishes = categoryEntry.value;

                           // For each dish in the category, create a selection section
                           return dishes.entries.map((dishEntry) {
                              String mealName = dishEntry.key;
                              // int quantity = dishEntry.value; // Quantity not needed for display here
                              List<SideDishItem> availableSides = allSideDishes; // Use the global list

                              return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$mealCategory: $mealName - Select Sides:", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: availableSides.map((sideDish) {
                                    bool isSelected = currentSideDishes.any((s) => s.name == sideDish.name);
                                    return FilterChip(
                                      label: Text(sideDish.name),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        List<SideDishItem> updatedList = List.from(currentSideDishes);
                                        if (selected) {
                                          if (!isSelected) updatedList.add(sideDish); // Add only if not already present
                                        } else {
                                          updatedList.removeWhere((s) => s.name == sideDish.name);
                                        }
                                        _updateSideDishes(dayIndex, updatedList); // Update state
                                      },
                                      selectedColor: Colors.lightGreen.withOpacity(0.3),
                                      checkmarkColor: Colors.black,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                           }); // End dishes.entries.map
                        }), // End mainMeals.entries.expand
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Proceed Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen, // Use AppColors if defined
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // Navigate to Grocery List Page, passing BOTH main and side dish selections
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeekGroceryListPage(
                      weeklySelections: widget.weeklyMainSelections,
                      weeklySideDishSelections: _weeklySideDishSelections, // Pass side dishes
                    ),
                  ),
                );
              },
              child: Text(
                'Generate Grocery List',
                style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
