import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu_items.dart'; // For SideDishItem, allSideDishes, ingredients map
import 'grocery_list_page.dart'; // Import the separate GroceryListPage
// For AppColors (optional, use theme)

class DaySideDishPage extends StatefulWidget {
  // Updated type to accept quantities
  final Map<String, Map<String, int>> dayMainSelections; // Receive main dish selections for the day with quantities

  const DaySideDishPage({
    super.key,
    required this.dayMainSelections,
  });

  @override
  State<DaySideDishPage> createState() => _DaySideDishPageState();
}

class _DaySideDishPageState extends State<DaySideDishPage> {
  // State to hold selected side dishes for the day
  // Map<mealCategory, List<SideDishItem>> - though simpler to just have one list for the day
  final List<SideDishItem> _selectedSideDishes = [];

  @override
  void initState() {
    super.initState();
    // No complex initialization needed as we only deal with one day
  }

  // Callback to update side dish selection
  void _updateSideDishes(SideDishItem sideDish, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!_selectedSideDishes.any((s) => s.name == sideDish.name)) {
          _selectedSideDishes.add(sideDish);
        }
      } else {
        _selectedSideDishes.removeWhere((s) => s.name == sideDish.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter categories that have selected dishes (dish map is not empty)
    final selectedCategories = widget.dayMainSelections.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();

    if (selectedCategories.isEmpty) { // Corrected variable name here
      // Handle case where no main dishes were selected (shouldn't happen if navigated correctly)
      return Scaffold(
        appBar: AppBar(title: const Text('Select Side Dishes')),
        body: const Center(child: Text("No main dishes were selected.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Side Dishes for Today'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  "Select side dishes for your chosen meals:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // Iterate through categories with selected main meals
                ...selectedCategories.expand((categoryEntry) {
                  String mealCategory = categoryEntry.key;
                  Map<String, int> dishes = categoryEntry.value;

                  // For each dish in the category, create a selection card
                  return dishes.keys.map((mealName) {
                     List<SideDishItem> availableSides = allSideDishes; // Use the global list

                     return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$mealCategory: $mealName - Select Sides:", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: availableSides.map((sideDish) {
                              bool isSelected = _selectedSideDishes.any((s) => s.name == sideDish.name);
                              return FilterChip(
                                label: Text(sideDish.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  _updateSideDishes(sideDish, selected); // Update state
                                },
                                selectedColor: Colors.lightGreen.withOpacity(0.3),
                                checkmarkColor: Colors.black,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                  }); // End dishes.keys.map
                }), // End selectedCategories.expand
              ],
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
                    builder: (context) => GroceryListPage(
                      // Pass main selections with quantity
                      selectedItemsWithQuantity: widget.dayMainSelections,
                      selectedSideDishes: _selectedSideDishes,
                      showEditButton: false,
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
