import 'package:flutter/material.dart';
// For custom fonts
// For date formatting (though not used in this version)
import 'menu_items.dart'; // Need this for the ingredients map and SideDishItem
// import 'recipe_page.dart'; // No longer needed

// Model for grocery items with day tracking
class WeeklyGroceryItem {
  final String name;
  final Set<String> days; // Store day names
  final String category; // e.g., Produce, Pantry
  int quantity; // Placeholder for smart quantity (e.g., 1 packet, 250g) - Needs API logic
  String unit; // Placeholder for unit (e.g., 'g', 'packet', 'item') - Needs API logic
  bool isChecked; // Renamed from isAvailable for clarity in this context

  WeeklyGroceryItem({
    required this.name,
    required this.days,
    this.category = 'Other', // Default category
    this.quantity = 1, // Default quantity to 1 for simplicity
    this.unit = 'item', // Default unit
    this.isChecked = false, // Default to not checked
  });
}

// --- Main Widget ---
class WeekGroceryListPage extends StatefulWidget {
  // Updated type for main selections to include quantity
  final Map<int, Map<String, Map<String, int>>> weeklySelections;
  final Map<int, List<SideDishItem>>? weeklySideDishSelections;

  const WeekGroceryListPage({
    super.key,
    required this.weeklySelections,
    this.weeklySideDishSelections,
  });

  @override
  State<WeekGroceryListPage> createState() => _WeekGroceryListPageState();
}

class _WeekGroceryListPageState extends State<WeekGroceryListPage> {
  late List<WeeklyGroceryItem> _groceryList; // The final list displayed
  late Map<String, List<WeeklyGroceryItem>> _categorizedGroceryList; // List categorized
  // No longer need separate filtered maps, filtering happens during generation
  // late Map<int, Map<String, Map<String, int>>> _filteredSelections;
  // late Map<int, List<SideDishItem>> _filteredSideDishSelections;
  bool _selectAll = false; // State for Select All checkbox

  @override
  void initState() {
    super.initState();
    // Generate list directly from widget props
    _groceryList = _generateWeeklyGroceryList(widget.weeklySelections, widget.weeklySideDishSelections ?? {});
    _categorizedGroceryList = _categorizeGroceryList(_groceryList);
    _updateSelectAllState(); // Initial check for Select All state
  }

  // Filter side dishes to only include days that have main selections
  Map<int, List<SideDishItem>> _filterValidSideDishes(Map<int, List<SideDishItem>>? sideDishes, Set<int> validDayIndices) {
    if (sideDishes == null) return {};
    Map<int, List<SideDishItem>> filtered = {};
    sideDishes.forEach((dayIndex, sides) {
      if (validDayIndices.contains(dayIndex)) {
        filtered[dayIndex] = sides;
      }
    });
    return filtered;
  }

  // Helper to remove days/meals with no selections - No longer needed as generation handles empty maps

  // Generate the basic grocery list (ingredient -> days needed)
  List<WeeklyGroceryItem> _generateWeeklyGroceryList(
    Map<int, Map<String, Map<String, int>>> mainSelections, // Updated type
    Map<int, List<SideDishItem>> sideDishSelections, // Made non-nullable in initState
  ) {
    Map<String, Set<String>> ingredientDays = {}; // Ingredient name -> Set of day names

    // Process main selections (with quantities)
    mainSelections.forEach((dayIndex, categories) {
      String dayName = _getDayName(dayIndex); // Use helper method
      categories.forEach((category, dishes) {
        dishes.forEach((dishName, quantity) {
          if (quantity > 0 && ingredients.containsKey(dishName)) {
            // Add ingredients for this dish
            for (var ingredient in ingredients[dishName]!) {
              ingredientDays.putIfAbsent(ingredient, () => <String>{});
              ingredientDays[ingredient]!.add(dayName);
            }
          }
        });
      });
    });

    // Process side dish selections
    sideDishSelections.forEach((dayIndex, sides) {
      String dayName = _getDayName(dayIndex); // Use helper method
      for (var sideDish in sides) {
        List<String> sideIngredients = sideDish.ingredients.isNotEmpty
            ? sideDish.ingredients
            : (ingredients[sideDish.name] ?? []);
        for (var ingredient in sideIngredients) {
          ingredientDays.putIfAbsent(ingredient, () => <String>{});
          ingredientDays[ingredient]!.add(dayName);
        }
      }
    });

    if (ingredientDays.isEmpty) return [];

    // Convert to WeeklyGroceryItem
    var items = ingredientDays.entries.map((entry) {
      String category = _getIngredientCategory(entry.key);
      return WeeklyGroceryItem(
        name: entry.key,
        days: entry.value,
        category: category,
      );
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return items;
  }

  // Simple placeholder for categorization - replace with better logic or API
  String _getIngredientCategory(String ingredientName) {
    String lowerIngredient = ingredientName.toLowerCase();
    if (['lettuce', 'tomato', 'cucumber', 'onion', 'potato', 'garlic', 'ginger', 'mint leaves', 'coriander leaves', 'green chilies', 'mixed vegetables', 'broccoli', 'bell peppers', 'zucchini', 'celery', 'asparagus', 'parsley', 'lemon', 'blueberries', 'strawberries'].contains(lowerIngredient)) return 'Produce';
    if (['rice flour', 'urad dal', 'fenugreek seeds', 'salt', 'oil', 'toor dal', 'tamarind', 'sambar powder', 'mustard seeds', 'curry leaves', 'coconut', 'idli rice', 'basmati rice', 'water', 'spices', 'yogurt', 'ginger-garlic paste', 'biryani masala', 'mint', 'coriander', 'red chilies', 'sesame seeds', 'asafoetida', 'lentils', 'rasam powder', 'ghee', 'cumin seeds', 'sugar', 'yeast', 'all-purpose flour', 'peanuts', 'jaggery', 'tomato concentrate', 'vinegar', 'soy sauce', 'olive oil', 'vinaigrette', 'baguette', 'quinoa', 'honey', 'mayonnaise', 'bread', 'rolled oats', 'pasta', 'tikka masala spice'].contains(lowerIngredient)) return 'Pantry';
    if (['paneer', 'milk', 'cream', 'butter', 'curd', 'chicken/vegetables', 'black lentils', 'kidney beans', 'moong dal', 'salmon fillet', 'cooked chicken'].contains(ingredientName)) return 'Dairy/Protein';
    return 'Other';
  }

  // Categorize the generated list
  Map<String, List<WeeklyGroceryItem>> _categorizeGroceryList(List<WeeklyGroceryItem> list) {
    Map<String, List<WeeklyGroceryItem>> categorized = {
      'Produce': [], 'Pantry': [], 'Dairy/Protein': [], 'Other': [],
    };
    for (var item in list) {
      categorized.putIfAbsent(item.category, () => []).add(item);
    }
    // Sort categories for consistent order
    var sortedKeys = categorized.keys.toList()..sort();
    Map<String, List<WeeklyGroceryItem>> sortedCategorized = {};
    for (var key in sortedKeys) {
        if (categorized[key]!.isNotEmpty) {
             sortedCategorized[key] = categorized[key]!;
        }
    }
    return sortedCategorized;
  }

  // Helper to get day name
  String _getDayName(int index) {
    const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return dayNames[index % 7]; // Ensure index is within bounds
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var item in _groceryList) {
        item.isChecked = _selectAll;
      }
    });
  }

  void _updateSelectAllState() {
    if (_groceryList.isEmpty) {
      _selectAll = false;
      return;
    }
    _selectAll = _groceryList.every((item) => item.isChecked);
  }

  void _removeItem(int index) {
     setState(() {
       _groceryList.removeAt(index);
       _categorizedGroceryList = _categorizeGroceryList(_groceryList); // Re-categorize after removal
       _updateSelectAllState();
     });
  }

  @override
  Widget build(BuildContext context) {
    // Get active items (not checked off)
    List<WeeklyGroceryItem> activeGroceryItems = _groceryList.where((item) => !item.isChecked).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Grocery List'), // Updated title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // No actions (Edit/Recipe) in the AppBar for Week Plan
      ),
      body: _groceryList.isEmpty
          ? const Center(
              child: Text('No ingredients needed for the selected meals.'),
            )
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Select All'),
                    Checkbox(
                      value: _selectAll,
                      onChanged: _toggleSelectAll,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: _categorizedGroceryList.entries.expand((categoryEntry) {
                      String categoryName = categoryEntry.key;
                      List<WeeklyGroceryItem> itemsInCategory = categoryEntry.value;

                      return [
                         Padding(
                           padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                           child: Text(
                             categoryName,
                             style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                           ),
                         ),
                         ...itemsInCategory.map((item) {
                            // Find the original index to modify the correct item in _groceryList
                            int originalIndex = _groceryList.indexOf(item); // More reliable way to find index
                            return ListTile(
                              contentPadding: EdgeInsets.zero, // Remove default padding
                              leading: Checkbox(
                                value: item.isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (originalIndex != -1) {
                                      _groceryList[originalIndex].isChecked = value ?? false;
                                      _updateSelectAllState(); // Update select all state
                                    }
                                  });
                                },
                                activeColor: Colors.grey, // Color when checked
                                checkColor: Colors.white, // Color of the check mark
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  decoration: item.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                                  color: item.isChecked ? Colors.grey : null,
                                ),
                              ),
                              subtitle: Text( // Show days needed
                                'Needed for: ${item.days.join(', ')}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: item.isChecked ? Colors.grey : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Remove Item',
                                onPressed: () => _removeItem(originalIndex), // Call remove item function
                              ),
                            );
                         }),
                      ];
                    }).toList(),
                ),
              ),
              // Bottom Action Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // No Edit button for Week Plan Grocery List
                    // View Recipe button removed
                    // const SizedBox(height: 8), // Remove space if View Recipe is removed
                    ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text('Order Remaining Items'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: activeGroceryItems.isEmpty ? null : () {
                        // TODO: Integrate with Zomato/Swiggy API
                        List<String> itemsToOrder = activeGroceryItems.map((item) => item.name).toList();
                        print('Items to send to Zomato/Swiggy: $itemsToOrder');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ordering integration not yet implemented.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
