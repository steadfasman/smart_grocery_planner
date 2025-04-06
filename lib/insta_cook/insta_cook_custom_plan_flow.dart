import 'package:flutter/material.dart';
// For PageView animation calculation
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../menu_items.dart'; // For MenuItem, SideDishItem, ingredients map etc.
import '../grocery_list_page.dart'; // Import GroceryListPage for GroceryItem model and navigation

// Enum to track day status (can be reused or defined locally)
enum DayStatus { unvisited, skipped, selected }

// --- Main Flow Widget ---
class InstaCookCustomPlanFlow extends StatefulWidget {
  const InstaCookCustomPlanFlow({super.key});

  @override
  State<InstaCookCustomPlanFlow> createState() => _InstaCookCustomPlanFlowState();
}

class _InstaCookCustomPlanFlowState extends State<InstaCookCustomPlanFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  // Steps: Calendar, Dish Select (multi-item/qty), Side Dish Select, Grocery List
  final int _totalSteps = 4; // Reverted to 4 steps

  // State variables
  List<DateTime> _selectedDaysList = [];
  Map<DateTime, DayStatus> _dayStatuses = {};
  // Main dish selections with quantities: Date -> Category -> Dish -> Quantity
  Map<DateTime, Map<String, Map<String, int>>> _customSelections = {};
  // Side dish selections: Date -> List<SideDishItem>
  Map<DateTime, List<SideDishItem>> _customSideDishes = {}; // Added back

  // Index for the currently viewed date tab in Step 2
  int _currentDateIndexInStep2 = 0;

  // Page controllers for carousels - reused for the selected date
  final PageController _breakfastController = PageController(viewportFraction: 0.38);
  final PageController _lunchController = PageController(viewportFraction: 0.38);
  final PageController _dinnerController = PageController(viewportFraction: 0.38);
  final PageController _snacksController = PageController(viewportFraction: 0.38);

  // Page values for animation calculation - reset when date tab changes
  double _currentBreakfastPageValue = 0.0;
  double _currentLunchPageValue = 0.0;
  double _currentDinnerPageValue = 0.0;
  double _currentSnacksPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _addListeners(); // Add listeners once
  }

  @override
  void dispose() {
    _pageController.dispose();
    _breakfastController.dispose();
    _lunchController.dispose();
    _dinnerController.dispose();
    _snacksController.dispose();
    super.dispose();
  }

  void _addListeners() {
     _breakfastController.addListener(() { _updatePageValue(ref: _breakfastController, stateSetter: (v) => _currentBreakfastPageValue = v); });
     _lunchController.addListener(() { _updatePageValue(ref: _lunchController, stateSetter: (v) => _currentLunchPageValue = v); });
     _dinnerController.addListener(() { _updatePageValue(ref: _dinnerController, stateSetter: (v) => _currentDinnerPageValue = v); });
     _snacksController.addListener(() { _updatePageValue(ref: _snacksController, stateSetter: (v) => _currentSnacksPageValue = v); });
  }

  void _updatePageValue({required PageController ref, required Function(double) stateSetter}) {
     if (ref.page != null) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
         if (mounted) setState(() => stateSetter(ref.page!));
       });
     }
  }

  void _resetPageControllersAndValues() {
     _currentBreakfastPageValue = 0.0;
     _currentLunchPageValue = 0.0;
     _currentDinnerPageValue = 0.0;
     _currentSnacksPageValue = 0.0;
     if (_breakfastController.hasClients) _breakfastController.jumpToPage(0);
     if (_lunchController.hasClients) _lunchController.jumpToPage(0);
     if (_dinnerController.hasClients) _dinnerController.jumpToPage(0);
     if (_snacksController.hasClients) _snacksController.jumpToPage(0);
  }


  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_currentStep == 0 && _selectedDaysList.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one date.')));
         return;
      }
      if (_currentStep == 1 && !_areAllSelectedDatesVisited()) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select or skip meals for all chosen dates.')));
         return;
      }
      // Add check for step 3 (side dishes) if needed later

      setState(() { _currentStep++; });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finalizePlan(); // Called only from the last step (Side Dish Selection)
    }
  }

  void _previousStep() {
     if (_currentStep > 0) {
      setState(() { _currentStep--; });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
       Navigator.pop(context);
    }
  }

  bool _areAllSelectedDatesVisited() {
    if (_selectedDaysList.isEmpty) return false;
    return _selectedDaysList.every((day) => _dayStatuses[day] != DayStatus.unvisited);
  }

  void _updateSelectedDays(Set<DateTime> days) {
    List<DateTime> sortedDays = days.toList()..sort();
    setState(() {
      _selectedDaysList = sortedDays;
      _currentDateIndexInStep2 = 0;
      _dayStatuses = { for (var day in sortedDays) day : DayStatus.unvisited };
      _customSelections = {
        for (var day in sortedDays) day : { 'Breakfast': {}, 'Lunch': {}, 'Dinner': {}, 'Snacks': {} }
      };
      _customSideDishes = { for (var day in sortedDays) day : [] }; // Initialize side dishes
      _resetPageControllersAndValues();
    });
  }

  void _onDateIndexChanged(int index) {
     if (mounted && index != _currentDateIndexInStep2) {
        setState(() {
           _currentDateIndexInStep2 = index;
           _resetPageControllersAndValues();
        });
     }
  }

  // --- Quantity and Status Update Logic ---
  void _incrementQuantity(DateTime date, String category, String dishName) {
    setState(() {
      final dateSelections = _customSelections[date]!;
      dateSelections[category] ??= {};
      dateSelections[category]![dishName] = (dateSelections[category]![dishName] ?? 0) + 1;
      _updateDayStatus(date);
    });
  }

  void _decrementQuantity(DateTime date, String category, String dishName) {
    setState(() {
      final dateSelections = _customSelections[date]!;
      if (dateSelections[category] == null || dateSelections[category]![dishName] == null) return;
      int currentQuantity = dateSelections[category]![dishName]!;
      if (currentQuantity > 1) {
        dateSelections[category]![dishName] = currentQuantity - 1;
      } else {
        dateSelections[category]!.remove(dishName);
      }
      _updateDayStatus(date);
    });
  }

  void _updateDayStatus(DateTime date) {
     bool dayHasSelection = false;
     _customSelections[date]?.forEach((category, dishes) { if (dishes.isNotEmpty) dayHasSelection = true; });
     if (_dayStatuses[date] != DayStatus.skipped) {
        DayStatus newStatus = dayHasSelection ? DayStatus.selected : DayStatus.unvisited;
        if (_dayStatuses[date] != newStatus) _dayStatuses[date] = newStatus;
     }
  }

  // Callback for side dish step
  void _updateCustomSideDishes(DateTime date, List<SideDishItem> sideDishes) {
     if (mounted && _customSelections.containsKey(date)) { // Check if date is valid
       setState(() { _customSideDishes[date] = sideDishes; });
     }
   }

  // TODO: Implement skip day logic
  void _skipDate(DateTime date) { /* ... */ }
  // --- End Quantity Logic ---

  void _finalizePlan() {
    // Prepare data for Grocery List
    // Aggregate main dishes and quantities across all dates
    Map<String, Map<String, int>> combinedMainSelections = {};
    _customSelections.forEach((date, categories) {
       categories.forEach((category, dishes) {
          dishes.forEach((dishName, quantity) {
             combinedMainSelections[category] ??= {};
             combinedMainSelections[category]![dishName] = (combinedMainSelections[category]![dishName] ?? 0) + quantity;
          });
       });
    });

    // Combine all selected side dishes into a single list (duplicates allowed if selected on multiple days)
    List<SideDishItem> combinedSideDishes = [];
    _customSideDishes.forEach((date, sides) {
       combinedSideDishes.addAll(sides);
    });

     if (combinedMainSelections.isEmpty || combinedMainSelections.values.every((dishes) => dishes.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No meals selected for any date.')));
        return;
     }

    // Navigate directly to Grocery List Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GroceryListPage(
          selectedItemsWithQuantity: combinedMainSelections,
          selectedSideDishes: combinedSideDishes, // Pass combined list
          showEditButton: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool proceedEnabled = true;
    if (_currentStep == 0 && _selectedDaysList.isEmpty) proceedEnabled = false;
    if (_currentStep == 1 && !_areAllSelectedDatesVisited()) proceedEnabled = false;
    // Add check for step 3 (side dishes) if needed

    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Plan - Step ${_currentStep + 1} of $_totalSteps'),
        leading: IconButton( icon: const Icon(Icons.arrow_back), onPressed: _previousStep ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Calendar
                _CalendarDateSelectionStep(
                  initialSelectedDays: _selectedDaysList.toSet(),
                  onSelectionChanged: _updateSelectedDays,
                ),
                // Step 2: Dish Selection (with quantity)
                _CustomDishSelectionStep(
                  selectedDates: _selectedDaysList,
                  dayStatuses: _dayStatuses,
                  currentSelections: _customSelections,
                  currentDateIndex: _currentDateIndexInStep2,
                  onDateIndexChanged: _onDateIndexChanged,
                  incrementQuantity: _incrementQuantity,
                  decrementQuantity: _decrementQuantity,
                  breakfastController: _breakfastController,
                  lunchController: _lunchController,
                  dinnerController: _dinnerController,
                  snacksController: _snacksController,
                  currentBreakfastPageValue: _currentBreakfastPageValue,
                  currentLunchPageValue: _currentLunchPageValue,
                  currentDinnerPageValue: _currentDinnerPageValue,
                  currentSnacksPageValue: _currentSnacksPageValue,
                  // onSkipDate: _skipDate,
                ),
                // Step 3: Side Dish Selection (Added back)
                _CustomSideDishSelectionStep(
                  selectedDates: _selectedDaysList,
                  mainDishSelections: _customSelections, // Pass quantity map
                  initialSideDishSelections: _customSideDishes,
                  onSideDishesChanged: _updateCustomSideDishes,
                ),
                // Step 4: Grocery List (Placeholder - generation happens in _finalizePlan)
                 Center(child: Text("Grocery List will be generated on 'Done'.")),
              ],
            ),
          ),
          // Bottom Navigation Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.lightGreen,
                 foregroundColor: Colors.black,
                 minimumSize: const Size(double.infinity, 50),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                 disabledBackgroundColor: Colors.grey.shade300,
                 disabledForegroundColor: Colors.grey.shade500,
              ),
              onPressed: proceedEnabled ? _nextStep : null,
              child: Text(
                // Text changes based on the *next* step
                _currentStep == _totalSteps - 2 ? 'Generate Grocery List' : 'Next',
                style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== Step 1: Calendar Date Selection (Unchanged) ==================
class _CalendarDateSelectionStep extends StatefulWidget { /* ... content unchanged ... */
  final Set<DateTime> initialSelectedDays;
  final Function(Set<DateTime>) onSelectionChanged;

  const _CalendarDateSelectionStep({
    required this.initialSelectedDays,
    required this.onSelectionChanged,
  });

  @override
  State<_CalendarDateSelectionStep> createState() => _CalendarDateSelectionStepState();
}

class _CalendarDateSelectionStepState extends State<_CalendarDateSelectionStep> {
  late Set<DateTime> _selectedDays;
  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.now().subtract(const Duration(days: 365));
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.initialSelectedDays.map((day) => DateTime.utc(day.year, day.month, day.day)).toSet();
    if (_selectedDays.isNotEmpty) {
      _focusedDay = _selectedDays.first;
    }
     if (_focusedDay.isBefore(_firstDay)) _focusedDay = _firstDay;
     if (_focusedDay.isAfter(_lastDay)) _focusedDay = _lastDay;
  }

  DateTime _normalizeDay(DateTime day) {
    return DateTime.utc(day.year, day.month, day.day);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            "Select the days for your custom plan:",
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.lightGreen.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.lightGreen, width: 2),
              ),
               selectedTextStyle: const TextStyle(color: Colors.white),
               defaultTextStyle: const TextStyle(color: Colors.black),
               weekendTextStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
               outsideTextStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
            ),
            selectedDayPredicate: (day) {
              return _selectedDays.contains(_normalizeDay(day));
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                DateTime normalizedSelectedDay = _normalizeDay(selectedDay);
                if (_selectedDays.contains(normalizedSelectedDay)) {
                  _selectedDays.remove(normalizedSelectedDay);
                } else {
                  _selectedDays.add(normalizedSelectedDay);
                }
                _focusedDay = focusedDay; // Update focused day on selection
                widget.onSelectionChanged(_selectedDays);
              });
            },
            onPageChanged: (focusedDay) {
              // Update focused day when page changes
              setState(() {
                 _focusedDay = focusedDay;
              });
            },
          ),
        ],
      ),
    );
  }
}


// ================== Step 2: Dish Selection (with Quantity) (Unchanged) ==================
class _CustomDishSelectionStep extends StatefulWidget { /* ... content unchanged ... */
  final List<DateTime> selectedDates;
  final Map<DateTime, DayStatus> dayStatuses;
  // Updated signature for quantity map
  final Map<DateTime, Map<String, Map<String, int>>> currentSelections;
  final int currentDateIndex;
  final Function(int) onDateIndexChanged;
  // Callbacks for quantity changes
  final Function(DateTime date, String category, String dishName) incrementQuantity;
  final Function(DateTime date, String category, String dishName) decrementQuantity;
  // final Function(DateTime) onSkipDate; // Keep for future skip logic

  // Pass PageControllers and values
  final PageController breakfastController;
  final PageController lunchController;
  final PageController dinnerController;
  final PageController snacksController;
  final double currentBreakfastPageValue;
  final double currentLunchPageValue;
  final double currentDinnerPageValue;
  final double currentSnacksPageValue;


  const _CustomDishSelectionStep({
    required this.selectedDates,
    required this.dayStatuses,
    required this.currentSelections,
    required this.currentDateIndex,
    required this.onDateIndexChanged,
    required this.incrementQuantity,
    required this.decrementQuantity,
    // required this.onSkipDate,
    required this.breakfastController,
    required this.lunchController,
    required this.dinnerController,
    required this.snacksController,
    required this.currentBreakfastPageValue,
    required this.currentLunchPageValue,
    required this.currentDinnerPageValue,
    required this.currentSnacksPageValue,
  });

  @override
  State<_CustomDishSelectionStep> createState() => _CustomDishSelectionStepState();
}

class _CustomDishSelectionStepState extends State<_CustomDishSelectionStep> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  @override
  void didUpdateWidget(covariant _CustomDishSelectionStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize TabController if the number of dates changes
    if (widget.selectedDates.length != oldWidget.selectedDates.length) {
      _tabController.removeListener(_handleTabSelection);
      _tabController.dispose();
      _initializeTabController();
    } else if (widget.currentDateIndex != oldWidget.currentDateIndex && widget.currentDateIndex != _tabController.index) {
       // Animate to the correct tab if the parent state's index changed
       _tabController.animateTo(widget.currentDateIndex);
    }
  }

  void _initializeTabController() {
     _tabController = TabController(
        length: widget.selectedDates.isNotEmpty ? widget.selectedDates.length : 1,
        vsync: this,
        initialIndex: widget.selectedDates.isNotEmpty ? widget.currentDateIndex.clamp(0, widget.selectedDates.length - 1) : 0
     );
     _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    // Notify parent state only if the index actually changed by user interaction
    if (!_tabController.indexIsChanging && _tabController.index != widget.currentDateIndex) {
       widget.onDateIndexChanged(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  // --- Color Helper Functions (copied from WeekPlannerPage) ---
  Color _getDateTabColor(DateTime date, bool isSelected, BuildContext context) {
     final status = widget.dayStatuses[date] ?? DayStatus.unvisited;
     const Color selectedColor = Color(0xFF4CAF50); // Green
     const Color skippedColor = Color(0xFFF44336); // Red
     final Color defaultColor = Theme.of(context).colorScheme.surface;
     final Color selectedHighlight = Theme.of(context).colorScheme.primary.withOpacity(0.1);
     switch (status) {
       case DayStatus.selected: return isSelected ? selectedColor : selectedColor.withOpacity(0.1);
       case DayStatus.skipped: return isSelected ? skippedColor : skippedColor.withOpacity(0.1);
       case DayStatus.unvisited: default: return isSelected ? selectedHighlight : defaultColor;
     }
  }
   Color _getDateTabTextColor(DateTime date, bool isSelected, BuildContext context) {
     final status = widget.dayStatuses[date] ?? DayStatus.unvisited;
     const Color selectedColor = Color(0xFF4CAF50);
     const Color skippedColor = Color(0xFFF44336);
     switch (status) {
       case DayStatus.selected: return isSelected ? Colors.white : selectedColor;
       case DayStatus.skipped: return isSelected ? Colors.white : skippedColor;
       case DayStatus.unvisited: default: return isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface;
     }
  }
  // --- End Color Helpers ---

  @override
  Widget build(BuildContext context) {
    if (widget.selectedDates.isEmpty) {
      return const Center(child: Text("Please go back and select dates."));
    }

    return Column(
      children: [
        // Date Tab Bar
        Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            indicator: BoxDecoration(
               border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.primary, width: 3.0))
            ),
            tabs: List.generate(widget.selectedDates.length, (index) {
              final date = widget.selectedDates[index];
              final isSelected = index == widget.currentDateIndex; // Use parent's index state
              final bgColor = _getDateTabColor(date, isSelected, context);
              final textColor = _getDateTabTextColor(date, isSelected, context);
              return Tab(
                child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   decoration: BoxDecoration( color: bgColor, borderRadius: BorderRadius.circular(6) ),
                   child: Text( DateFormat('MMM d').format(date), style: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              );
            }),
          ),
        ),
        // Meal Selection Carousels for the selected date
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe here, controlled by parent
            children: widget.selectedDates.map((date) {
              // Build the meal selection UI for this specific date
              return SingleChildScrollView(
                 key: ValueKey(date), // Ensure state resets correctly if needed
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      // TODO: Add Skip Day button? -> widget.onSkipDate(date)
                      _buildDishCarousel(
                        date, 'Breakfast', breakfastItems,
                        widget.breakfastController, widget.currentBreakfastPageValue
                      ),
                      const SizedBox(height: 15),
                      _buildDishCarousel(
                        date, 'Lunch', lunchItems,
                        widget.lunchController, widget.currentLunchPageValue
                      ),
                      const SizedBox(height: 15),
                      _buildDishCarousel(
                        date, 'Dinner', dinnerItems,
                        widget.dinnerController, widget.currentDinnerPageValue
                      ),
                      const SizedBox(height: 15),
                      _buildDishCarousel(
                        date, 'Snacks', snackItems,
                        widget.snacksController, widget.currentSnacksPageValue
                      ),
                   ],
                 ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // --- Carousel Building Logic (Adapted from WeekPlannerPage) ---
  Widget _buildDishCarousel(
    DateTime date, // Pass the current date
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

                    double scale = 1.0 - diff * 0.25; scale = scale.clamp(0.75, 1.0);
                    if (isCenter) { double factor = 1 - (diff / 0.5); scale = scale * (1.0 + (0.15 * factor)); }
                    double opacity = isCenter ? 1.0 : 0.7;

                    // Get quantity for the CURRENT DATE and category
                    int currentQuantity = widget.currentSelections[date]?[categoryName]?[item.name] ?? 0;

                    return Transform.scale(
                      scale: scale,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(milliseconds: 150),
                          child: _buildDishItemCard(
                            date, // Pass date
                            categoryName, // Pass category
                            item,
                            currentQuantity,
                            () { // onTap callback
                              if (currentQuantity == 0) {
                                widget.incrementQuantity(date, categoryName, item.name); // Use callback
                              }
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
      DateTime date, String category, MenuItem menuItem, int quantity, VoidCallback onTap) {
    bool isSelected = quantity > 0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: isSelected ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0) : BorderSide.none,
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
                    menuItem.imagePath, fit: BoxFit.cover, width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
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
                  textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 4.0, left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => widget.decrementQuantity(date, category, menuItem.name), // Use callback
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      Text('$quantity', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () => widget.incrementQuantity(date, category, menuItem.name), // Use callback
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.8), shape: BoxShape.circle),
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
  // --- End Carousel Building Logic ---
}


// ================== Step 3: Side Dish Selection (Added Back) ==================
class _CustomSideDishSelectionStep extends StatelessWidget {
   final List<DateTime> selectedDates;
   // Accept main selections with quantities
   final Map<DateTime, Map<String, Map<String, int>>> mainDishSelections;
   final Map<DateTime, List<SideDishItem>> initialSideDishSelections;
   final Function(DateTime date, List<SideDishItem> sideDishes) onSideDishesChanged;

   const _CustomSideDishSelectionStep({
     required this.selectedDates,
     required this.mainDishSelections,
     required this.initialSideDishSelections,
     required this.onSideDishesChanged,
   });

  @override
  Widget build(BuildContext context) {
    // Filter dates that have any main dish selected (quantity > 0)
    final datesWithMeals = selectedDates.where((date) {
       final categories = mainDishSelections[date];
       return categories != null && categories.values.any((dishes) => dishes.isNotEmpty);
    }).toList();

    if (datesWithMeals.isEmpty) {
       return const Center(child: Text("Please select main dishes in the previous step."));
    }

    return ListView.builder(
       padding: const EdgeInsets.all(16.0),
       itemCount: datesWithMeals.length,
       itemBuilder: (context, index) {
          final date = datesWithMeals[index];
          final categoriesForDate = mainDishSelections[date]!;
          final currentSideDishes = initialSideDishSelections[date] ?? [];

          return Card(
             margin: const EdgeInsets.symmetric(vertical: 8.0),
             child: Padding(
               padding: const EdgeInsets.all(12.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Text(
                      DateFormat('EEEE, MMM d').format(date), // Display full day name
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    // Iterate through categories and their selected dishes for this date
                    ...categoriesForDate.entries.expand((categoryEntry) {
                       String mealCategory = categoryEntry.key;
                       Map<String, int> dishes = categoryEntry.value;

                       // For each dish with quantity > 0, show side dish selection
                       return dishes.keys.map((mealName) {
                          List<SideDishItem> availableSides = allSideDishes; // Use global list

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text("$mealCategory: $mealName - Select Sides:", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                 const SizedBox(height: 5),
                                 Wrap(
                                   spacing: 8.0, runSpacing: 4.0,
                                   children: availableSides.map((sideDish) {
                                     bool isSelected = currentSideDishes.any((s) => s.name == sideDish.name);
                                     return FilterChip(
                                       label: Text(sideDish.name),
                                       selected: isSelected,
                                       onSelected: (selected) {
                                         List<SideDishItem> updatedList = List.from(currentSideDishes);
                                         if (selected) { if (!isSelected) updatedList.add(sideDish); }
                                         else { updatedList.removeWhere((s) => s.name == sideDish.name); }
                                         onSideDishesChanged(date, updatedList); // Callback to update state
                                       },
                                        selectedColor: Colors.lightGreen.withOpacity(0.3),
                                        checkmarkColor: Colors.black,
                                     );
                                   }).toList(),
                                 ),
                              ],
                            ),
                          );
                       }); // End dishes.keys.map
                    }), // End categoriesForDate.entries.expand
                 ],
               ),
             ),
          );
       }
    );
  }
}


// ================== Step 4: Grocery List (Placeholder/Removed) ==================
// The grocery list generation is now handled in _finalizePlan and navigates directly
// to the main GroceryListPage. The _CustomGroceryListStep widget is removed.
