import 'package:flutter/material.dart';
// Import math for rounding
import 'menu_items.dart'; // Import menu items data
import 'week_side_dish_page.dart'; // Import the side dish page
// For AppColors (if needed, though Theme is preferred)
// Import for potential direct navigation later

// Enum to track day status
enum DayStatus { unvisited, skipped, selected }

class WeekPlannerPage extends StatefulWidget {
  const WeekPlannerPage({super.key});

  @override
  State<WeekPlannerPage> createState() => _WeekPlannerPageState();
}

class _WeekPlannerPageState extends State<WeekPlannerPage> {
  int _selectedDayIndex = 0; // Default to Monday (index 0)
  final List<String> _daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  // Track status for all days
  final Map<int, DayStatus> _dayStatuses = {}; // Map<dayIndex, DayStatus>

  // Store selected items with quantities: Map<DayIndex, Map<CategoryName, Map<DishName, Quantity>>>
  final Map<int, Map<String, Map<String, int>>> _weeklySelections = {};

  // Page controllers for carousels - one set reused for the selected day
  final PageController _breakfastController = PageController(viewportFraction: 0.38);
  final PageController _lunchController = PageController(viewportFraction: 0.38);
  final PageController _dinnerController = PageController(viewportFraction: 0.38);
  final PageController _snacksController = PageController(viewportFraction: 0.38);

  // Page values for animation calculation - reset when day changes
  double _currentBreakfastPageValue = 0.0;
  double _currentLunchPageValue = 0.0;
  double _currentDinnerPageValue = 0.0;
  double _currentSnacksPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize status and selections for all days
    for (int i = 0; i < 7; i++) {
      _dayStatuses[i] = DayStatus.unvisited;
      _weeklySelections[i] = { // Initialize inner maps
        'Breakfast': {},
        'Lunch': {},
        'Dinner': {},
        'Snacks': {},
      };
    }
    _selectDay(0); // Select Monday by default and add listeners
    _addListeners(); // Add listeners once
  }

  void _addListeners() {
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


  @override
  void dispose() {
    _breakfastController.dispose();
    _lunchController.dispose();
    _dinnerController.dispose();
    _snacksController.dispose();
    super.dispose();
  }

  // Selects a single day and resets page controllers/values
  void _selectDay(int dayIndex) {
    setState(() {
      _selectedDayIndex = dayIndex;
      // Reset page values for animation
      _currentBreakfastPageValue = 0.0;
      _currentLunchPageValue = 0.0;
      _currentDinnerPageValue = 0.0;
      _currentSnacksPageValue = 0.0;
      // Jump controllers to the beginning when day changes
      // Use jumpToPage(0) only if controller has clients (attached to a PageView)
      if (_breakfastController.hasClients) _breakfastController.jumpToPage(0);
      if (_lunchController.hasClients) _lunchController.jumpToPage(0);
      if (_dinnerController.hasClients) _dinnerController.jumpToPage(0);
      if (_snacksController.hasClients) _snacksController.jumpToPage(0);
    });
  }

  // Function to increment quantity for the selected day
  void _incrementQuantity(String category, String dishName) {
    setState(() {
      final daySelections = _weeklySelections[_selectedDayIndex]!;
      daySelections[category] ??= {};
      daySelections[category]![dishName] = (daySelections[category]![dishName] ?? 0) + 1;
      _updateDayStatus(_selectedDayIndex); // Update status after change
    });
  }

  // Function to decrement quantity for the selected day
  void _decrementQuantity(String category, String dishName) {
    setState(() {
      final daySelections = _weeklySelections[_selectedDayIndex]!;
      if (daySelections[category] == null || daySelections[category]![dishName] == null) {
        return;
      }
      int currentQuantity = daySelections[category]![dishName]!;
      if (currentQuantity > 1) {
        daySelections[category]![dishName] = currentQuantity - 1;
      } else {
        daySelections[category]!.remove(dishName); // Remove dish if quantity becomes 0
      }
      _updateDayStatus(_selectedDayIndex); // Update status after change
    });
  }

  // Update day status based on selections
  void _updateDayStatus(int dayIndex) {
     bool dayHasSelection = false;
     _weeklySelections[dayIndex]?.forEach((category, dishes) {
       if (dishes.isNotEmpty) {
         dayHasSelection = true;
       }
     });

     // Only update if status needs changing (and not explicitly skipped)
     if (_dayStatuses[dayIndex] != DayStatus.skipped) {
        DayStatus newStatus = dayHasSelection ? DayStatus.selected : DayStatus.unvisited;
        if (_dayStatuses[dayIndex] != newStatus) {
           _dayStatuses[dayIndex] = newStatus;
        }
     }
     // Note: Need a way to explicitly set DayStatus.skipped
  }

  // TODO: Implement a way to mark a day as skipped
  // void _skipDay(int dayIndex) { ... }

  // Check if any meal has been selected for any day
  bool _hasAnySelection() {
    for (var daySelections in _weeklySelections.values) {
      for (var categorySelections in daySelections.values) {
        if (categorySelections.isNotEmpty) {
          return true; // Found at least one selected dish
        }
      }
    }
    return false; // No selections found for any day
  }

  // Check if all days have been visited (selected or skipped) - No longer needed for button enablement
  // bool _areAllDaysVisited() {
  //   return _dayStatuses.values.every((status) => status != DayStatus.unvisited);
  // }

  // --- Color Helper Functions (copied from previous version) ---
  Color _getDayColor(int index, BuildContext context) {
     final bool isCurrentlySelected = _selectedDayIndex == index;
     const Color selectedColor = Color(0xFF4CAF50); // Green
     const Color skippedColor = Color(0xFFF44336); // Red
     final Color defaultColor = Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5);
     final Color selectedHighlight = Theme.of(context).colorScheme.primary.withOpacity(0.2);

     switch (_dayStatuses[index]) {
       case DayStatus.selected:
         return isCurrentlySelected ? selectedColor : selectedColor.withOpacity(0.7);
       case DayStatus.skipped:
         return isCurrentlySelected ? skippedColor : skippedColor.withOpacity(0.7);
       case DayStatus.unvisited:
       default:
         return isCurrentlySelected ? selectedHighlight : defaultColor;
     }
  }
   Color _getDayBorderColor(int index, BuildContext context) {
     final bool isCurrentlySelected = _selectedDayIndex == index;
     const Color selectedColor = Color(0xFF4CAF50);
     const Color skippedColor = Color(0xFFF44336);
     final Color defaultColor = Colors.grey.shade400;
     final Color selectedHighlight = Theme.of(context).colorScheme.primary;

      switch (_dayStatuses[index]) {
       case DayStatus.selected: return selectedColor;
       case DayStatus.skipped: return skippedColor;
       case DayStatus.unvisited:
       default: return isCurrentlySelected ? selectedHighlight : defaultColor;
     }
  }
   Color _getDayTextColor(int index, BuildContext context) {
     final bool isCurrentlySelected = _selectedDayIndex == index;
     const Color selectedColor = Colors.white;
     const Color skippedColor = Colors.white;
     final Color defaultColor = Theme.of(context).colorScheme.onSurfaceVariant;
     final Color selectedHighlight = Theme.of(context).colorScheme.primary;

      switch (_dayStatuses[index]) {
       case DayStatus.selected:
       case DayStatus.skipped:
         return isCurrentlySelected ? selectedColor : Theme.of(context).colorScheme.onSurface;
       case DayStatus.unvisited:
       default: return isCurrentlySelected ? selectedHighlight : defaultColor;
     }
  }
  // --- End Color Helpers ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan for a Week'),
      ),
      body: Column(
        children: [
          // 1. Week Day Selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_daysOfWeek.length, (index) {
                final Color bgColor = _getDayColor(index, context);
                final Color borderColor = _getDayBorderColor(index, context);
                final Color textColor = _getDayTextColor(index, context);
                return GestureDetector(
                  onTap: () => _selectDay(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Text(
                      _daysOfWeek[index],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(),

          // 2. Meal Selection Area for the selected day
          Expanded(
            child: _buildMealSelectionArea(),
          ),

          // 3. Proceed Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              // Enable button if at least one selection exists
              onPressed: _hasAnySelection() ? () {
                 // Prepare data for WeekSideDishPage
                 Map<int, Map<String, Map<String, int>>> finalSelections = {};
                 _weeklySelections.forEach((dayIndex, categories) {
                   finalSelections[dayIndex] = {};
                   categories.forEach((category, dishes) {
                     if (dishes.isNotEmpty) {
                       finalSelections[dayIndex]![category] = Map.from(dishes);
                     }
                   });
                   // Keep day entry even if empty, WeekSideDishPage might need it
                 });

                 // TODO: Update WeekSideDishPage to accept the new quantity structure
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => WeekSideDishPage(
                       // Pass the selections with quantities.
                       // NOTE: WeekSideDishPage currently expects Map<int, Map<String, String?>>
                       // This will require modification in week_side_dish_page.dart
                       weeklyMainSelections: finalSelections, // Pass the new structure
                     ),
                   ),
                 );
              } : null,
              style: ElevatedButton.styleFrom(
                 disabledBackgroundColor: Colors.grey.shade300,
                 disabledForegroundColor: Colors.grey.shade500,
              ),
              child: const Text('Proceed'),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the meal selection carousels for the currently selected day
  Widget _buildMealSelectionArea() {
    return SingleChildScrollView(
      key: ValueKey(_selectedDayIndex), // Add key to force rebuild on day change
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(bottom: 10.0),
             child: Text(
                'Planning for: ${_dayNames[_selectedDayIndex]}',
                style: Theme.of(context).textTheme.titleLarge,
             ),
           ),
           // TODO: Add Skip Day button?
           _buildDishCarousel(
             'Breakfast',
             breakfastItems,
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
    );
  }

  // --- Copied and adapted from DayPlannerPage ---
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 160, // Increased height
          child: menuItems.isEmpty
              ? const Center(child: Text("No items available"))
              : PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    final diff = (currentPageValue - index).abs();
                    final bool isCenter = diff < 0.5;

                    double scale = 1.0 - diff * 0.25;
                    scale = scale.clamp(0.75, 1.0);
                    if (isCenter) {
                       double factor = 1 - (diff / 0.5);
                       scale = scale * (1.0 + (0.15 * factor));
                    }
                    double opacity = isCenter ? 1.0 : 0.7;

                    // Get quantity for the CURRENTLY SELECTED DAY
                    int currentQuantity = _weeklySelections[_selectedDayIndex]?[categoryName]?[item.name] ?? 0;

                    return Transform.scale(
                      scale: scale,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(milliseconds: 150),
                          child: _buildDishItemCard(
                            categoryName, // Pass category
                            item,
                            currentQuantity,
                            () { // onTap callback
                              if (currentQuantity == 0) {
                                _incrementQuantity(categoryName, item.name);
                              }
                              // Tapping card only adds if not present, doesn't navigate carousel
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

  // --- Copied and adapted from DayPlannerPage ---
  Widget _buildDishItemCard(
      String category, MenuItem menuItem, int quantity, VoidCallback onTap) {
    bool isSelected = quantity > 0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: isSelected
              ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0)
              : BorderSide.none,
        ),
        child: SizedBox(
          width: 130,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                child: Text(
                  menuItem.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Theme.of(context).colorScheme.primary : null,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 4.0, left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => _decrementQuantity(category, menuItem.name), // Pass category
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
                        onTap: () => _incrementQuantity(category, menuItem.name), // Pass category
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
              else
                const SizedBox(height: 36), // Maintain height
            ],
          ),
        ),
      ),
    );
  }
}
