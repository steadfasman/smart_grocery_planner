import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../menu_items.dart'; // For SideDishItem and allSideDishes
// For AuthService (if needed for profile icon)
// For profile icon navigation
import '../grocery_list_page.dart'; // Import the standard grocery list page
// import '../recipe_page.dart'; // No longer needed

// Re-defining InstaCookItem here for clarity, or import if moved to a central model file
class InstaCookItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;

  const InstaCookItem({ // Make constructor const
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });
}

// --- Sample Data (Moved here or fetched) ---
const List<InstaCookItem> _allItems = [ // Make list const
  // Breakfast
  InstaCookItem(id: 'b1', name: 'Instant Poha Mix', description: 'Quick flattened rice breakfast', imageUrl: 'assets/images/insta_poha.png', price: 45.00, category: 'Breakfast'), // Added assets/
  InstaCookItem(id: 'b2', name: 'Ready-to-Eat Upma', description: 'Semolina porridge, just add hot water', imageUrl: 'assets/images/insta_upma.png', price: 50.00, category: 'Breakfast'), // Added assets/
  InstaCookItem(id: 'b3', name: 'Oats - Masala Magic', description: 'Savory oats ready in 3 minutes', imageUrl: 'assets/images/insta_oats.png', price: 60.00, category: 'Breakfast'), // Added assets/
  // Lunch
  InstaCookItem(id: 'l1', name: 'Cup Noodles - Masala', description: 'Classic instant noodles', imageUrl: 'assets/images/insta_noodles.png', price: 30.00, category: 'Lunch'), // Added assets/
  InstaCookItem(id: 'l2', name: 'Ready-to-Eat Veg Pulao', description: 'Flavorful rice dish', imageUrl: 'assets/images/insta_pulao.png', price: 80.00, category: 'Lunch'), // Added assets/
  InstaCookItem(id: 'l3', name: 'Instant Lemon Rice', description: 'Tangy rice, ready quickly', imageUrl: 'assets/images/insta_lemon_rice.png', price: 75.00, category: 'Lunch'), // Added assets/
  // Dinner
  InstaCookItem(id: 'd1', name: 'Ready-to-Eat Dal Makhani', description: 'Creamy black lentils', imageUrl: 'assets/images/insta_dal_makhani.png', price: 90.00, category: 'Dinner'), // Added assets/
  InstaCookItem(id: 'd2', name: 'Instant Paneer Butter Masala', description: 'Rich paneer curry', imageUrl: 'assets/images/insta_paneer.png', price: 110.00, category: 'Dinner'), // Added assets/
  InstaCookItem(id: 'd3', name: 'Heat & Eat Chicken Curry', description: 'Homestyle chicken curry', imageUrl: 'assets/images/insta_chicken.png', price: 120.00, category: 'Dinner'), // Added assets/
  // Snacks
  InstaCookItem(id: 's1', name: 'Instant Popcorn - Butter', description: 'Microwave popcorn', imageUrl: 'assets/images/insta_popcorn.png', price: 25.00, category: 'Snacks'), // Added assets/
  InstaCookItem(id: 's2', name: 'Ready-to-Eat Samosa (Frozen)', description: 'Heat and serve crispy samosas', imageUrl: 'assets/images/insta_samosa.png', price: 70.00, category: 'Snacks'), // Added assets/
  InstaCookItem(id: 's3', name: 'Cup Soup - Tomato', description: 'Warm tomato soup in minutes', imageUrl: 'assets/images/insta_soup.png', price: 20.00, category: 'Snacks'), // Added assets/
];
// --- End Sample Data ---


class InstaCookFlow extends StatefulWidget {
  const InstaCookFlow({super.key});

  @override
  State<InstaCookFlow> createState() => _InstaCookFlowState();
}

class _InstaCookFlowState extends State<InstaCookFlow> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late TabController _tabController;
  int _currentStep = 0;
  final int _totalSteps = 3; // Meal, Side Dish, Grocery/Order

  // State for selections
  InstaCookItem? _selectedMainDish;
  List<SideDishItem> _selectedSideDishes = [];

  final List<String> _mealCategories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _mealCategories.length, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle "Order" action on the last step
      _placeOrder();
    }
  }

  void _previousStep() {
     if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
       // If on the first step, pop the route to go back to MainNavigationPage
       Navigator.pop(context);
    }
  }

  void _updateMainDishSelection(InstaCookItem? item) {
     setState(() {
       _selectedMainDish = item;
       _selectedSideDishes = []; // Reset side dishes when main dish changes
     });
     print("Selected Main Dish: ${item?.name}");
  }

   void _updateSideDishSelection(List<SideDishItem> items) {
     setState(() {
       _selectedSideDishes = items;
     });
      print("Selected Side Dishes: ${items.map((s) => s.name).toList()}");
   }

  void _placeOrder() {
    // Implement order logic
    print("Placing Order!");
    print("Main Dish: ${_selectedMainDish?.name}");
    print("Side Dishes: ${_selectedSideDishes.map((s) => s.name).toList()}");
    // Show confirmation, navigate to order summary, etc.
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Order placed successfully (simulation)!')),
     );
    Navigator.pop(context); // Go back after order
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InstaCook - Step ${_currentStep + 1} of $_totalSteps'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
        // Optional: Add profile icon if needed
        // actions: [ ... ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                // Step 1: Meal Selection
                _InstaCookMealSelectionStep(
                  tabController: _tabController,
                  categories: _mealCategories,
                  allItems: _allItems,
                  selectedItem: _selectedMainDish,
                  onItemSelected: _updateMainDishSelection,
                ),
                // Step 2: Side Dish Selection
                _InstaCookSideDishSelectionStep(
                   selectedMainDish: _selectedMainDish, // Pass selected main dish
                   initialSideDishes: _selectedSideDishes,
                   onSideDishesChanged: _updateSideDishSelection,
                ),
                // Step 3: Grocery List & Order
                _InstaCookGroceryOrderStep(
                  selectedMainDish: _selectedMainDish,
                  selectedSideDishes: _selectedSideDishes,
                ),
              ],
            ),
          ),
          // Fixed Bottom Navigation Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Disable button logic might be needed based on selections
              onPressed: (_currentStep == 0 && _selectedMainDish == null) ? null : _nextStep,
              child: Text(
                _currentStep == _totalSteps - 1 ? 'Place Order' : 'Next',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== Step 1: Meal Selection ==================
class _InstaCookMealSelectionStep extends StatelessWidget {
  final TabController tabController;
  final List<String> categories;
  final List<InstaCookItem> allItems;
  final InstaCookItem? selectedItem;
  final Function(InstaCookItem?) onItemSelected;

  const _InstaCookMealSelectionStep({
    required this.tabController,
    required this.categories,
    required this.allItems,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: categories.map((category) {
        final itemsForCategory = allItems.where((item) => item.category == category).toList();
        return itemsForCategory.isEmpty
            ? Center(child: Text('No items found for $category.'))
            : GridView.builder(
                padding: const EdgeInsets.all(15.0),
                itemCount: itemsForCategory.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final item = itemsForCategory[index];
                  final bool isSelected = selectedItem?.id == item.id;
                  return _buildInstaCookItemCard(context, item, isSelected, onItemSelected);
                },
              );
      }).toList(),
    );
  }

  // Copied and adapted from InstaCookMenuScreen
   Widget _buildInstaCookItemCard(BuildContext context, InstaCookItem item, bool isSelected, Function(InstaCookItem?) onTap) {
    return Card(
      clipBehavior: Clip.antiAlias,
       shape: isSelected
            ? RoundedRectangleBorder( // Add border only when selected
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.5),
                borderRadius: BorderRadius.circular(12.0) // Match theme card radius
              )
            : null, // Use default shape otherwise (which comes from CardTheme)
      child: InkWell(
        onTap: () => onTap(item), // Call the selection callback
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                'assets/${item.imageUrl}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Theme.of(context).colorScheme.primary : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // const Spacer(), // Removed Spacer to allow description to take more space if needed
                    // Text( // Removed Price Display
                    //   '₹${item.price.toStringAsFixed(2)}',
                    //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    //         fontWeight: FontWeight.bold,
                    //         color: Theme.of(context).colorScheme.primary,
                    //       ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== Step 2: Side Dish Selection (Placeholder) ==================
class _InstaCookSideDishSelectionStep extends StatefulWidget {
  final InstaCookItem? selectedMainDish;
  final List<SideDishItem> initialSideDishes;
  final Function(List<SideDishItem>) onSideDishesChanged;

  const _InstaCookSideDishSelectionStep({
    required this.selectedMainDish,
    required this.initialSideDishes,
    required this.onSideDishesChanged,
  });

  @override
  State<_InstaCookSideDishSelectionStep> createState() => _InstaCookSideDishSelectionStepState();
}

class _InstaCookSideDishSelectionStepState extends State<_InstaCookSideDishSelectionStep> {
  late List<SideDishItem> _selectedSideDishes;
  List<SideDishItem> _availableSideDishes = []; // Will be filtered based on main dish

  @override
  void initState() {
    super.initState();
    _selectedSideDishes = List.from(widget.initialSideDishes);
    _filterAvailableSideDishes();
  }

  @override
  void didUpdateWidget(covariant _InstaCookSideDishSelectionStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the main dish changes, re-filter available side dishes
    if (widget.selectedMainDish?.id != oldWidget.selectedMainDish?.id) {
      _filterAvailableSideDishes();
      // Reset selection if main dish changes? Optional.
      // _selectedSideDishes = [];
      // widget.onSideDishesChanged(_selectedSideDishes);
    }
     // Update internal state if initial list changes externally (might happen if user goes back and forth)
    if (widget.initialSideDishes != oldWidget.initialSideDishes) {
       _selectedSideDishes = List.from(widget.initialSideDishes);
    }
  }


  void _filterAvailableSideDishes() {
    // TODO: Implement logic to suggest/filter side dishes based on widget.selectedMainDish
    // For now, just show all available side dishes from menu_items.dart
    setState(() {
       _availableSideDishes = allSideDishes; // Using the global list from menu_items.dart
    });
  }

  void _toggleSideDishSelection(SideDishItem sideDish) {
     final isSelected = _selectedSideDishes.any((s) => s.name == sideDish.name);
     List<SideDishItem> updatedList = List.from(_selectedSideDishes);
     if (isSelected) {
       updatedList.removeWhere((s) => s.name == sideDish.name);
     } else {
       updatedList.add(sideDish);
     }
     setState(() {
       _selectedSideDishes = updatedList;
     });
     widget.onSideDishesChanged(updatedList);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedMainDish == null) {
      return const Center(child: Text("Please select a main dish first."));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          "Select side dishes for ${widget.selectedMainDish!.name}:",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_availableSideDishes.isEmpty)
           const Center(child: Text("No suggested side dishes for this item.")),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _availableSideDishes.map((sideDish) {
            final bool isSelected = _selectedSideDishes.any((s) => s.name == sideDish.name);
            return FilterChip(
              label: Text(sideDish.name),
              selected: isSelected,
              onSelected: (selected) => _toggleSideDishSelection(sideDish),
              selectedColor: Colors.lightGreen.withOpacity(0.3),
              checkmarkColor: Colors.black,
              labelStyle: GoogleFonts.poppins(
                 color: isSelected ? Colors.black : Colors.black87,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


// ================== Step 3: Grocery List & Order ==================
class _InstaCookGroceryOrderStep extends StatelessWidget {
  final InstaCookItem? selectedMainDish;
  final List<SideDishItem> selectedSideDishes;

  const _InstaCookGroceryOrderStep({
    required this.selectedMainDish,
    required this.selectedSideDishes,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare the selectedItems map for GroceryListPage
    Map<String, String?> mainDishSelection = {};
    if (selectedMainDish != null) {
      // Assuming category is like 'Breakfast', 'Lunch', etc.
      mainDishSelection[selectedMainDish!.category] = selectedMainDish!.name;
    }

    return GroceryListPage(
      selectedItems: mainDishSelection,
      selectedSideDishes: selectedSideDishes,
      showEditButton: false, // Edit button not needed in InstaCook flow's final step
    );
  }
}
