import 'package:flutter/material.dart';
// Import math for rounding
import 'package:supabase_flutter/supabase_flutter.dart';
import 'menu_items.dart';
// import 'grocery_list_page.dart'; // No longer navigating directly here
import 'day_side_dish_page.dart'; // Import DaySideDishPage

class DayPlannerPage extends StatefulWidget {
  const DayPlannerPage({super.key});

  @override
  _DayPlannerPageState createState() => _DayPlannerPageState();
}

class _DayPlannerPageState extends State<DayPlannerPage> {

  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchBFItems() async {
    final response = await supabase.from('menu_items').select('*');

    if (response.isEmpty) {
      return [];
    }

    return List<Map<String,dynamic>>.from(response);
  }
  ///Future<List<Map<String, dynamic>>> fetchLUItems() async {
   /// final response2 = await supabase.from('tamil_nadu_lunch').select('*');
//
    //if (response2.isEmpty) {
    //  return [];
    //}

    //return List<Map<String,dynamic>>.from(response2);
  //}

  // Store selected items with quantities: Map<CategoryName, Map<DishName, Quantity>>
  final Map<String, Map<String, int>> _selectedItemsWithQuantity = {
    'Breakfast': {},
    'Lunch': {},
    'Dinner': {},
    'Snacks': {},
  };

  // Page controllers for carousels
  final PageController _breakfastController = PageController(viewportFraction: 0.38);
  final PageController _lunchController = PageController(viewportFraction: 0.38);
  final PageController _dinnerController = PageController(viewportFraction: 0.38);
  final PageController _snacksController = PageController(viewportFraction: 0.38);

  // Page values for animation calculation
  double _currentBreakfastPageValue = 0.0;
  double _currentLunchPageValue = 0.0;
  double _currentDinnerPageValue = 0.0;
  double _currentSnacksPageValue = 0.0;


  List<Map<String, dynamic>> _bfitems = []; 
  bool _isBFLoading = true; 

  //List<Map<String, dynamic>> _luitems = []; 
  //bool _isLULoading = true; 



  @override
  void initState() {
    super.initState();
     _loadBFItems();







    // Add listeners to update page values for animations
    _breakfastController.addListener(() {
      if (_breakfastController.page != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _currentBreakfastPageValue = _breakfastController.page!);
        });
      }
    });
    _lunchController.addListener(() {
      if (_lunchController.page != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _currentLunchPageValue = _lunchController.page!);
        });
      }
    });
    _dinnerController.addListener(() {
      if (_dinnerController.page != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _currentDinnerPageValue = _dinnerController.page!);
        });
      }
    });
    _snacksController.addListener(() {
      if (_snacksController.page != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _currentSnacksPageValue = _snacksController.page!);
        });
      }
    });
  }

  Future<void> _loadBFItems() async {
  final fetchedBFItems = await fetchBFItems();
  setState(() {
    _bfitems = fetchedBFItems;
    _isBFLoading = false; // Stop loading
  });


  //Future<void> _loadLUItems() async {
  //final fetchedLUItems = await fetchLUItems();
  //setState(() {
   // _luitems = fetchedLUItems;
  //  _isLULoading = false; // Stop loading
  //});







  
}

  @override
  void dispose() {
    _breakfastController.dispose();
    _lunchController.dispose();
    _dinnerController.dispose();
    _snacksController.dispose();
    super.dispose();
  }

  // Function to increment quantity
  void _incrementQuantity(String category, String dishName) {
    setState(() {
      _selectedItemsWithQuantity[category] ??= {}; // Ensure category map exists
      _selectedItemsWithQuantity[category]![dishName] =
          (_selectedItemsWithQuantity[category]![dishName] ?? 0) + 1;
    });
  }

  // Function to decrement quantity
  void _decrementQuantity(String category, String dishName) {
    setState(() {
      if (_selectedItemsWithQuantity[category] == null ||
          _selectedItemsWithQuantity[category]![dishName] == null) {
        return; // Should not happen
      }

      int currentQuantity = _selectedItemsWithQuantity[category]![dishName]!;
      if (currentQuantity > 1) {
        _selectedItemsWithQuantity[category]![dishName] = currentQuantity - 1;
      } else {
        // Remove item if quantity becomes 0
        _selectedItemsWithQuantity[category]!.remove(dishName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Planner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildDishCarousel(
              'Breakfast',
              _bfitems.cast<MenuItem>(),
              _breakfastController,
              _currentBreakfastPageValue,
            ),
            const SizedBox(height: 15),
            _buildDishCarousel(
              'Lunch',
              lunchItems,
              _lunchController,
              _currentLunchPageValue,
            ),
            const SizedBox(height: 15),
            _buildDishCarousel(
              'Dinner',
              dinnerItems,
              _dinnerController,
              _currentDinnerPageValue,
            ),
            const SizedBox(height: 15),
            _buildDishCarousel(
              'Snacks',
              snackItems,
              _snacksController,
              _currentSnacksPageValue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Map<String, Map<String, int>> finalSelections = {};
            _selectedItemsWithQuantity.forEach((category, dishes) {
              if (dishes.isNotEmpty) {
                finalSelections[category] = Map.from(dishes);
              }
            });

            if (finalSelections.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select at least one item.')),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                // Navigate to DaySideDishPage instead
                builder: (context) => DaySideDishPage(
                  // Pass the selections with quantities
                  // NOTE: DaySideDishPage needs to be updated to accept this type
                  dayMainSelections: finalSelections,
                ),
              ),
            );
          },
          // Update button text maybe?
          child: const Text('Select Side Dishes'),
        ),
      ),
    );
  }

  Widget _buildDishCarousel(
    String categoryName,
    List<MenuItem> menuItems,
    PageController pageController,
    double currentPageValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 15.0),
          child: Text(
            categoryName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 160, // Increased height to accommodate quantity selector
          child: menuItems.isEmpty
              ? const Center(child: Text("No items available"))
              : PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    final diff = (currentPageValue - index).abs();
                    final bool isCenter = diff < 0.5; // For animation

                    // Determine scale and opacity based on distance from center
                    double scale = 1.0 - diff * 0.25;
                    scale = scale.clamp(0.75, 1.0);
                    if (isCenter) {
                       double factor = 1 - (diff / 0.5);
                       scale = scale * (1.0 + (0.15 * factor)); // Center pop effect
                    }
                    double opacity = isCenter ? 1.0 : 0.7; // More opaque when center

                    // Get current quantity for this item
                    int currentQuantity = _selectedItemsWithQuantity[categoryName]?[item.name] ?? 0;

                    return Transform.scale(
                      scale: scale,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(milliseconds: 150),
                          child: _buildDishItemCard(
                            categoryName,
                            item,
                            currentQuantity,
                            () { // onTap callback for the card
                              if (currentQuantity == 0) {
                                _incrementQuantity(categoryName, item.name);
                              }
                              // Optional: Animate to tapped page if not center?
                              // if (!isCenter) {
                              //   pageController.animateToPage(
                              //     index,
                              //     duration: const Duration(milliseconds: 300),
                              //     curve: Curves.easeInOut,
                              //   );
                              // }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDishItemCard(
      String category, MenuItem menuItem, int quantity, VoidCallback onTap) {
    bool isSelected = quantity > 0;

    return GestureDetector(
      onTap: onTap, // Use the passed onTap callback
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: isSelected // Highlight based on selection state (quantity > 0)
              ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0)
              : BorderSide.none,
        ),
        child: SizedBox( // Constrain card width
          width: 130, // Adjust width if needed
          child: Column(
            mainAxisSize: MainAxisSize.min, // Fit content
            children: [
              // Image
              Expanded(
                // flex: 3, // Adjust flex if needed
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: Image.asset(
                    menuItem.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
                    },
                  ),
                ),
              ),
              // Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                child: Text(
                  menuItem.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, // Bold if selected
                        color: isSelected ? Theme.of(context).colorScheme.primary : null,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Quantity Selector (Conditional)
              if (isSelected) // Only show if quantity > 0
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 4.0, left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => _decrementQuantity(category, menuItem.name),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      Text(
                        '$quantity',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () => _incrementQuantity(category, menuItem.name),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              else // Add SizedBox to maintain height when selector is hidden
                const SizedBox(height: 36), // Adjust height to match selector row approx
            ],
          ),
        ),
      ),
    );
  }
}
