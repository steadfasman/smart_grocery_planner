import 'package:flutter/material.dart';
import 'api/recipeApi.dart';

import 'menu_items.dart'; // For SideDishItem and ingredients map
import 'insta_cook/insta_cook_menu_screen.dart'; // For Edit button navigation
// Fallback for Edit button if category unknown

// Define GroceryItem model here
class GroceryItem {
  final String name;
  final String category; // Added category
  int quantity; // Placeholder
  String unit; // Placeholder
  bool isChecked; // Renamed from isAvailable for clarity in this context

  GroceryItem({
    required this.name,
    this.category = 'Other',
    this.quantity = 1, // Default quantity to 1 for simplicity
    this.unit = 'item', // Default unit
    this.isChecked = false, // Renamed from isAvailable
  });
}

class GroceryListPage extends StatefulWidget {
  // Existing parameters (make selectedItems nullable)
  final Map<String, String?>? selectedItems;
  final List<SideDishItem>? selectedSideDishes;
  final bool showEditButton;
  final String apiResponse;
  final bool fetchApi;

  // New parameter for quantity-based selections
  final Map<String, Map<String, int>>? selectedItemsWithQuantity;

  const GroceryListPage({
    super.key,
    // Make selectedItems optional, require one of the selection types
    this.selectedItems,
    this.selectedSideDishes,
    this.showEditButton = false,
    this.selectedItemsWithQuantity,
    this.apiResponse = "",
    this.fetchApi = false,
  })  : assert(selectedItems != null || selectedItemsWithQuantity != null,
            'Either selectedItems or selectedItemsWithQuantity must be provided');

  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  late List<GroceryItem> _groceryList;
  late Map<String, List<GroceryItem>> _categorizedGroceryList;
  bool _selectAll = false; // State for Select All checkbox

  bool _isApiLoading = false;
  String _apiResponse = "";

  @override
  void initState() {
    super.initState();
    if (widget.fetchApi) {
      // React's useEffect(() => {...}, []) equivalent
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchCookingAssistantResponse();
      });
    }
    // Generate list based on which selection type is provided
    if (widget.selectedItemsWithQuantity != null) {
      _groceryList =
          _generateGroceryListFromQuantity(widget.selectedItemsWithQuantity!);
    } else {
      // Fallback to original logic if quantity map isn't provided
      _groceryList = _generateGroceryListFromSingle(
          widget.selectedItems ?? {}, widget.selectedSideDishes);
    }

    _categorizedGroceryList = _categorizeGroceryList(_groceryList);
    _updateSelectAllState(); // Initial check for Select All state
  }

  Future<void> _fetchCookingAssistantResponse() async {
    setState(() => _isApiLoading = true);

    try {
      final dishName = widget.selectedItems?.values.first ?? '';
      final sideDishName = widget.selectedSideDishes?.firstOrNull?.name ?? '';

      final result = await getCookingAssistantResponse(
        dishName: dishName,
        sideDishName: sideDishName,
        dishServings: 1,
        sideDishServings: 1,
        userNotes: 'Make it less spicy.',
      );

      setState(() {
        _apiResponse = result;
        // Optionally: use _apiResponse to populate grocery list
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    } finally {
      setState(() => _isApiLoading = false);
    }
  }

  // Original generator for single selections and side dishes
  List<GroceryItem> _generateGroceryListFromSingle(
      Map<String, String?> mainDishes, List<SideDishItem>? sideDishes) {
    Set<String> ingredientSet = {};

    // Add ingredients from main dishes
    mainDishes.forEach((mealCategory, dishName) {
      if (dishName != null && ingredients.containsKey(dishName)) {
        ingredientSet.addAll(ingredients[dishName]!);
      }
    });

    // Add ingredients from side dishes if provided
    if (sideDishes != null) {
      for (var sideDish in sideDishes) {
        List<String> sideIngredients = sideDish.ingredients.isNotEmpty
            ? sideDish.ingredients
            : (ingredients[sideDish.name] ?? []);
        ingredientSet.addAll(sideIngredients);
      }
    }

    return _createGroceryItemsFromSet(ingredientSet);
  }

  // New generator for quantity-based selections
  List<GroceryItem> _generateGroceryListFromQuantity(
      Map<String, Map<String, int>> mainDishesWithQuantity) {
    Set<String> ingredientSet = {};

    mainDishesWithQuantity.forEach((category, dishes) {
      dishes.forEach((dishName, quantity) {
        if (quantity > 0 && ingredients.containsKey(dishName)) {
          // For now, just add unique ingredients, ignoring quantity multiplication
          // TODO: Optionally multiply ingredients by quantity if needed later
          ingredientSet.addAll(ingredients[dishName]!);
        }
      });
    });

    // Note: Side dishes are not currently handled in the quantity flow from DayPlannerPage
    // If side dishes need to be added here, the DayPlannerPage needs modification.

    return _createGroceryItemsFromSet(ingredientSet);
  }

  // Helper to convert ingredient set to sorted GroceryItem list
  List<GroceryItem> _createGroceryItemsFromSet(Set<String> ingredientSet) {
    if (ingredientSet.isEmpty) return [];

    var items = ingredientSet.map((ingredient) {
      String category = _getIngredientCategory(ingredient);
      return GroceryItem(name: ingredient, category: category);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return items;
  }

  // Simple placeholder for categorization - replace with better logic or API
  String _getIngredientCategory(String ingredientName) {
    // Basic categorization example (same as in WeekGroceryListPage)
    // Consider making this case-insensitive
    String lowerIngredient = ingredientName.toLowerCase();
    if ([
      'lettuce',
      'tomato',
      'cucumber',
      'onion',
      'potato',
      'garlic',
      'ginger',
      'mint leaves',
      'coriander leaves',
      'green chilies',
      'mixed vegetables',
      'broccoli',
      'bell peppers',
      'zucchini',
      'celery',
      'asparagus',
      'parsley',
      'lemon',
      'blueberries',
      'strawberries'
    ].contains(lowerIngredient)) {
      return 'Produce';
    }
    if ([
      'rice flour',
      'urad dal',
      'fenugreek seeds',
      'salt',
      'oil',
      'toor dal',
      'tamarind',
      'sambar powder',
      'mustard seeds',
      'curry leaves',
      'coconut',
      'idli rice',
      'basmati rice',
      'water',
      'spices',
      'yogurt',
      'ginger-garlic paste',
      'biryani masala',
      'mint',
      'coriander',
      'red chilies',
      'sesame seeds',
      'asafoetida',
      'lentils',
      'rasam powder',
      'ghee',
      'cumin seeds',
      'sugar',
      'yeast',
      'all-purpose flour',
      'peanuts',
      'jaggery',
      'tomato concentrate',
      'vinegar',
      'soy sauce',
      'olive oil',
      'vinaigrette',
      'baguette',
      'quinoa',
      'honey',
      'mayonnaise',
      'bread',
      'rolled oats',
      'pasta',
      'tikka masala spice'
    ].contains(lowerIngredient)) {
      return 'Pantry';
    }
    if ([
      'paneer',
      'milk',
      'cream',
      'butter',
      'curd',
      'chicken/vegetables',
      'black lentils',
      'kidney beans',
      'moong dal',
      'salmon fillet',
      'cooked chicken'
    ].contains(ingredientName)) {
      return 'Dairy/Protein'; // Note: Chicken/Vegetables might need refinement
    }
    return 'Other';
  }

  // Categorize the generated list
  Map<String, List<GroceryItem>> _categorizeGroceryList(
      List<GroceryItem> list) {
    Map<String, List<GroceryItem>> categorized = {
      'Produce': [],
      'Pantry': [],
      'Dairy/Protein': [],
      'Other': [],
    };
    for (var item in list) {
      categorized.putIfAbsent(item.category, () => []).add(item);
    }
    // Sort categories for consistent order
    var sortedKeys = categorized.keys.toList()..sort();
    Map<String, List<GroceryItem>> sortedCategorized = {};
    for (var key in sortedKeys) {
      if (categorized[key]!.isNotEmpty) {
        sortedCategorized[key] = categorized[key]!;
      }
    }
    return sortedCategorized;
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
      if (index >= 0 && index < _groceryList.length) {
        _groceryList.removeAt(index);
        _categorizedGroceryList =
            _categorizeGroceryList(_groceryList); // Re-categorize after removal
        _updateSelectAllState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get active items (not checked off)
    List<GroceryItem> activeGroceryItems =
        _groceryList.where((item) => !item.isChecked).toList();

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.showEditButton ? 'Meal Grocery List' : 'Grocery List'),
        // Dynamic title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Conditionally show Edit Button (relies on selectedItems, won't show for quantity flow)
          if (widget.showEditButton && widget.selectedItems != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Meal',
              onPressed: () {
                // Navigate to InstaCook Menu Screen to allow changing the dish
                // Determine the category from selectedItems if possible
                String categoryToOpen = widget.selectedItems!.keys.firstWhere(
                    (k) => widget.selectedItems![k] != null,
                    orElse: () => 'Breakfast' // Default if no category found
                    );
                Navigator.pushReplacement(
                  // Use pushReplacement to avoid stacking pages unnecessarily
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InstaCookMenuScreen(category: categoryToOpen)),
                );
              },
            ),
        ],
      ),
      body: _groceryList.isEmpty
          ? Center(
              // child: Text('No ingredients needed for the selected meals.'),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _isApiLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        _apiResponse.isNotEmpty
                            ? _apiResponse
                            : 'No recipe generated yet.',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                    children:
                        _categorizedGroceryList.entries.expand((categoryEntry) {
                      String categoryName = categoryEntry.key;
                      List<GroceryItem> itemsInCategory = categoryEntry.value;

                      return [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: Text(
                            categoryName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        ...itemsInCategory.map((item) {
                          // Find the original index to modify the correct item in _groceryList
                          int originalIndex = _groceryList
                              .indexOf(item); // More reliable way to find index
                          return ListTile(
                            contentPadding:
                                EdgeInsets.zero, // Remove default padding
                            leading: Checkbox(
                              value: item.isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (originalIndex != -1) {
                                    _groceryList[originalIndex].isChecked =
                                        value ?? false;
                                    _updateSelectAllState(); // Update select all state
                                  }
                                });
                              },
                              activeColor: Colors.grey, // Color when checked
                              checkColor:
                                  Colors.white, // Color of the check mark
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: item.isChecked ? Colors.grey : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: 'Remove Item',
                              onPressed: () => _removeItem(
                                  originalIndex), // Call remove item function
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
                      // Conditionally show Edit button based on source (Today/Calendar)
                      // This button relies on selectedItems, won't show for quantity flow
                      if (widget.showEditButton && widget.selectedItems != null)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Meal'), // Changed label
                          onPressed: () {
                            // Navigate to InstaCook Menu Screen to allow changing the dish
                            String categoryToOpen = widget.selectedItems!.keys
                                .firstWhere(
                                    (k) => widget.selectedItems![k] != null,
                                    orElse: () => 'Breakfast');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InstaCookMenuScreen(
                                      category: categoryToOpen)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                                double.infinity, 45), // Make button full width
                          ),
                        ),
                      if (widget.showEditButton && widget.selectedItems != null)
                        const SizedBox(height: 8),
                      // Add space if Edit button is shown

                      // Add Start Cooking button conditionally
                      if (widget.showEditButton)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Start Cooking'),
                          onPressed: () {
                            // TODO: Implement navigation or action for starting cooking
                            print('Start Cooking Tapped!');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Start Cooking feature not implemented yet.')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            // Optional: Style differently? e.g., different color
                            minimumSize: const Size(
                                double.infinity, 45), // Make button full width
                          ),
                        ),
                      if (widget.showEditButton) const SizedBox(height: 8),
                      // Add space if Start Cooking button is shown

                      ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart_checkout),
                        label: const Text('Order Remaining Items'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: activeGroceryItems.isEmpty
                            ? null
                            : () {
                                // TODO: Integrate with Zomato/Swiggy API
                                List<String> itemsToOrder = activeGroceryItems
                                    .map((item) => item.name)
                                    .toList();
                                print(
                                    'Items to send to Zomato/Swiggy: $itemsToOrder');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Ordering integration not yet implemented.')),
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
