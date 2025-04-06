import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Assuming MenuItem is defined here or import InstaCookItem if separate
import '../grocery_list_page.dart'; // Import GroceryListPage
// import '../recipe_page.dart'; // No longer needed
// Import InstaCookCategoryScreen

// Using the InstaCookItem definition from insta_cook_flow.dart for consistency
// If it's defined elsewhere, adjust the import.
class InstaCookItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;

  const InstaCookItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });
}

// --- Sample Data (Should ideally be fetched or passed) ---
const List<InstaCookItem> _allItems = [
  // Breakfast
  InstaCookItem(
      id: 'b1',
      name: 'Instant Poha Mix',
      description: 'Quick flattened rice breakfast',
      imageUrl: 'assets/images/insta_poha.png',
      price: 45.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b2',
      name: 'Ready-to-Eat Upma',
      description: 'Semolina porridge, just add hot water',
      imageUrl: 'assets/images/insta_upma.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b3',
      name: 'Oats - Masala Magic',
      description: 'Savory oats ready in 3 minutes',
      imageUrl: 'assets/images/insta_oats.png',
      price: 60.00,
      category: 'Breakfast'),
  // Lunch
  InstaCookItem(
      id: 'l1',
      name: 'Cup Noodles - Masala',
      description: 'Classic instant noodles',
      imageUrl: 'assets/images/insta_noodles.png',
      price: 30.00,
      category: 'Lunch'),

  InstaCookItem(
      id: 'l3',
      name: 'Instant Lemon Rice',
      description: 'Tangy rice, ready quickly',
      imageUrl: 'assets/images/insta_lemon_rice.png',
      price: 75.00,
      category: 'Lunch'),
  // Dinner
  InstaCookItem(
      id: 'd1',
      name: 'Ready-to-Eat Dal Makhani',
      description: 'Creamy black lentils',
      imageUrl: 'assets/images/insta_dal_makhani.png',
      price: 90.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd2',
      name: 'Instant Paneer Butter Masala',
      description: 'Rich paneer curry',
      imageUrl: 'assets/images/insta_paneer.png',
      price: 110.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd3',
      name: 'Heat & Eat Chicken Curry',
      description: 'Homestyle chicken curry',
      imageUrl: 'assets/images/insta_chicken.png',
      price: 120.00,
      category: 'Dinner'),
  // Snacks
  InstaCookItem(
      id: 's1',
      name: 'Instant Popcorn - Butter',
      description: 'Microwave popcorn',
      imageUrl: 'assets/images/insta_popcorn.png',
      price: 25.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's2',
      name: 'Ready-to-Eat Samosa (Frozen)',
      description: 'Heat and serve crispy samosas',
      imageUrl: 'assets/images/insta_samosa.png',
      price: 70.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's3',
      name: 'Cup Soup - Tomato',
      description: 'Warm tomato soup in minutes',
      imageUrl: 'assets/images/insta_soup.png',
      price: 20.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 'b11',
      name: 'Idli',
      description:
          'Includes: Sambar, Coconut Chutney, Tomato Chutney, Podi, Ghee, Curd, Vada Curry, Mint Chutney, Onion Chutney, Rasam',
      imageUrl: 'assets/images/idli.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b12',
      name: 'Dosa',
      description:
          'Includes: Coconut Chutney, Tomato Chutney, Sambar, Podi, Ghee, Curd, Onion Chutney, Mint Chutney',
      imageUrl: 'assets/images/dosa.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b13',
      name: 'Pongal',
      description:
          'Includes: Sambar, Coconut Chutney, Tomato Chutney, Brinjal Curry, Rasam',
      imageUrl: 'assets/images/pongal.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b14',
      name: 'Vada',
      description: 'Includes: Sambar, Coconut Chutney, Tomato Chutney, Rasam',
      imageUrl: 'assets/images/vada.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b15',
      name: 'Upma',
      description: 'Includes: Coconut Chutney, Pickle, Sugar, Sambar',
      imageUrl: 'assets/images/upma.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b6',
      name: 'Poori',
      description: 'Includes: Potato Masala, Channa Masala, Kurma, Pickle',
      imageUrl: 'assets/images/poori.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b7',
      name: 'Parotta',
      description: 'Includes: Salna, Chicken Curry, Egg Curry',
      imageUrl: 'assets/images/parotta.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b8',
      name: 'Idiyappam',
      description: 'Includes: Coconut Milk, Vegetable Kurma, Egg Curry',
      imageUrl: 'assets/images/idiyappam.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b9',
      name: 'Appam',
      description: 'Includes: Coconut Milk, Vegetable Kurma, Egg Curry',
      imageUrl: 'assets/images/appam.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'b10',
      name: 'Banana Paniyaram',
      description: 'Includes: Jaggery Syrup, Coconut Chutney, Sambar',
      imageUrl: 'assets/images/banana_paniyaram.png',
      price: 50.00,
      category: 'Breakfast'),
  InstaCookItem(
      id: 'l19',
      name: 'Sambar Rice',
      description: 'Includes: Papad, Pickle, Curd, Poriyal',
      imageUrl: 'assets/images/sambar_rice.png',
      price: 70.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l12',
      name: 'Rasam Rice',
      description: 'Includes: Papad, Pickle, Curd, Kootu',
      imageUrl: 'assets/images/rasam_rice.png',
      price: 65.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l13',
      name: 'Curd Rice',
      description: 'Includes: Pickle, Fried Chili, Mor Milagai',
      imageUrl: 'assets/images/curd_rice.png',
      price: 60.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l14',
      name: 'Lemon Rice',
      description: 'Includes: Pickle, Papad, Coconut Chutney',
      imageUrl: 'assets/images/lemon_rice.png',
      price: 65.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l15',
      name: 'Tamarind Rice (Puliyodarai)',
      description: 'Includes: Papad, Curd, Fryums',
      imageUrl: 'assets/images/tamarind_rice.png',
      price: 65.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l6',
      name: 'Tomato Rice',
      description: 'Includes: Onion Raita, Pickle, Papad',
      imageUrl: 'assets/images/tomato_rice.png',
      price: 70.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l7',
      name: 'Vegetable Biryani',
      description: 'Includes: Onion Raita, Brinjal Curry, Appalam',
      imageUrl: 'assets/images/vegetable_biryani.png',
      price: 90.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l8',
      name: 'Jeera Rice',
      description: 'Includes: Paneer Butter Masala, Dal Fry, Pickle',
      imageUrl: 'assets/images/jeera_rice.png',
      price: 85.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l9',
      name: 'Coconut Rice',
      description: 'Includes: Fried Potato, Papad, Curd',
      imageUrl: 'assets/images/coconut_rice.png',
      price: 75.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l10',
      name: 'Mint Rice (Pudina Rice)',
      description: 'Includes: Onion Raita, Pickle, Papad',
      imageUrl: 'assets/images/mint_rice.png',
      price: 75.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 'l11',
      name: 'Vegetable Kurma',
      description: 'Includes: Parotta, Chapati, Idiyappam',
      imageUrl: 'assets/images/vegetable_kurma.png',
      price: 80.00,
      category: 'Lunch'),
  InstaCookItem(
      id: 's11',
      name: 'Samosa',
      description: 'Crispy pastry filled with spicy potato masala',
      imageUrl: 'assets/images/samosa.png',
      price: 25.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's12',
      name: 'Vegetable Cutlet',
      description: 'Mixed veggie patties shallow fried',
      imageUrl: 'assets/images/veg_cutlet.png',
      price: 30.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's13',
      name: 'Masala Vada',
      description: 'Crispy chana dal fritter, served hot',
      imageUrl: 'assets/images/masala_vada.png',
      price: 20.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's14',
      name: 'Medu Vada',
      description: 'Soft inside, crispy outside urad dal fritters',
      imageUrl: 'assets/images/medu_vada.png',
      price: 25.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's15',
      name: 'Pakoda',
      description: 'Crunchy onion pakodas for tea time',
      imageUrl: 'assets/images/pakoda.png',
      price: 25.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's6',
      name: 'Paneer Roll',
      description: 'Spiced paneer wrapped in a soft roti',
      imageUrl: 'assets/images/paneer_roll.png',
      price: 45.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's7',
      name: 'Corn Chaat',
      description: 'Boiled sweet corn tossed with masala',
      imageUrl: 'assets/images/corn_chaat.png',
      price: 35.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's8',
      name: 'Bhel Puri',
      description: 'Mumbai-style puffed rice street snack',
      imageUrl: 'assets/images/bhel_puri.png',
      price: 30.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's9',
      name: 'Dhokla',
      description: 'Steamed gram flour cake, light & spongy',
      imageUrl: 'assets/images/dhokla.png',
      price: 40.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 's10',
      name: 'Mysore Bonda',
      description: 'Soft deep-fried snack served with chutney',
      imageUrl: 'assets/images/mysore_bonda.png',
      price: 30.00,
      category: 'Snacks'),
  InstaCookItem(
      id: 'd11',
      name: 'Chapati with Kurma',
      description: 'Soft chapatis served with veg kurma',
      imageUrl: 'assets/images/chapati_kurma.png',
      price: 60.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd12',
      name: 'Parotta with Salna',
      description: 'Layered flatbread with spicy gravy',
      imageUrl: 'assets/images/parotta_salna.png',
      price: 65.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd13',
      name: 'Idli with Sambar',
      description: 'Soft idlis served with hot sambar',
      imageUrl: 'assets/images/idli_sambar.png',
      price: 50.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd14',
      name: 'Dosa with Chutney',
      description: 'Crispy dosa with coconut & tomato chutneys',
      imageUrl: 'assets/images/dosa_chutney.png',
      price: 55.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd15',
      name: 'Lemon Rice with Papad',
      description: 'Tangy lemon rice with crispy sides',
      imageUrl: 'assets/images/lemon_rice_dinner.png',
      price: 55.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd16',
      name: 'Curd Rice with Pickle',
      description: 'Cooling curd rice, perfect end to the day',
      imageUrl: 'assets/images/curd_rice_dinner.png',
      price: 50.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd7',
      name: 'Tomato Bath',
      description: 'Spiced tomato rice dish with chutney',
      imageUrl: 'assets/images/tomato_bath.png',
      price: 60.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd8',
      name: 'Upma with Coconut Chutney',
      description: 'Classic semolina dish for light dinner',
      imageUrl: 'assets/images/upma_dinner.png',
      price: 50.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd9',
      name: 'Ragi Dosa with Mint Chutney',
      description: 'Healthy ragi dosa with flavorful chutney',
      imageUrl: 'assets/images/ragi_dosa.png',
      price: 55.00,
      category: 'Dinner'),
  InstaCookItem(
      id: 'd10',
      name: 'Chapati with Paneer Butter Masala',
      description: 'Chapatis served with rich paneer curry',
      imageUrl: 'assets/images/chapati_paneer.png',
      price: 75.00,
      category: 'Dinner'),
];
// --- End Sample Data ---

class InstaCookMenuScreen extends StatefulWidget {
  final String category; // Initial category to show

  const InstaCookMenuScreen({super.key, required this.category});

  @override
  State<InstaCookMenuScreen> createState() => _InstaCookMenuScreenState();
}

class _InstaCookMenuScreenState extends State<InstaCookMenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  InstaCookItem? _selectedItem;
  final List<String> _mealCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks'
  ];

  @override
  void initState() {
    super.initState();
    int initialIndex = _mealCategories.indexOf(widget.category);
    if (initialIndex == -1) {
      initialIndex = 0; // Default to first tab if category not found
    }
    _tabController = TabController(
        length: _mealCategories.length,
        vsync: this,
        initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateSelection(InstaCookItem? item) {
    setState(() {
      _selectedItem = item;
    });
  }

  void _navigateToNextStep() {
    if (_selectedItem != null) {
      // Navigate to the next step (e.g., side dish selection or grocery list/order)
      // For now, let's navigate directly to the Grocery List page for this item
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroceryListPage(
            selectedItems: {_selectedItem!.category: _selectedItem!.name},
            showEditButton: false, // No edit button in this flow
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a meal first.')),
      );
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title removed as per UI screenshot
        // title: Text('InstaCook - ${widget.category}'), // Original title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          // Allow scrolling if many categories
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: _mealCategories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: Column(
        // Wrap TabBarView and Button in a Column
        children: [
          Expanded(
            // Make TabBarView take available space
            child: TabBarView(
              controller: _tabController,
              children: _mealCategories.map((category) {
                final itemsForCategory = _allItems
                    .where((item) => item.category == category)
                    .toList();
                return itemsForCategory.isEmpty
                    ? Center(child: Text('No items found for $category.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(15.0),
                        itemCount: itemsForCategory.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 15.0,
                          childAspectRatio: 0.75, // Adjust as needed
                        ),
                        itemBuilder: (context, index) {
                          final item = itemsForCategory[index];
                          final bool isSelected = _selectedItem?.id == item.id;
                          return _buildInstaCookItemCard(
                              context, item, isSelected, _updateSelection);
                        },
                      );
              }).toList(),
            ),
          ),
          // Next Button at the bottom

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // onPressed: _selectedItem != null ? _navigateToNextStep : null, // Enable only if an item is selected
              // onPressed: () async {
              //   if (_selectedItem == null) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //           content: Text('Please select a meal first.')),
              //     );
              //     return;
              //   }
              //
              //   try {
              //     final result = await getCookingAssistantResponse(
              //       dishName: _selectedItem!.name,
              //       sideDishName: 'brinjal gravy',
              //       dishServings: 1,
              //       sideDishServings: 1,
              //       userNotes: 'Make it less spicy.',
              //     );
              //
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => GroceryListPage(
              //           selectedItems: {
              //             _selectedItem!.category: _selectedItem!.name
              //           },
              //           showEditButton: false,
              //           apiResponse: result, // <-- Passing the API response
              //         ),
              //       ),
              //     );
              //   } catch (e) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('Error: $e')),
              //     );
              //   }
              // },

              onPressed: () async {
                if (_selectedItem == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a meal first.')),
                  );
                  return;
                }

                setState(() => isLoading = true);

                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroceryListPage(
                        selectedItems: {
                          _selectedItem!.category: _selectedItem!.name
                        },
                        showEditButton: false,
                        fetchApi: true,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                } finally {
                  setState(() => isLoading = false);
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth:
                          3.0, // You can increase this for a "bolder" look
                    )
                  : Text(
                      'Next',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable card widget updated to match the screenshot
  Widget _buildInstaCookItemCard(BuildContext context, InstaCookItem item,
      bool isSelected, Function(InstaCookItem?) onTap) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.grey[100],
      // Light grey background for the card
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
          // Border color changes on selection
          width: isSelected ? 2.5 : 1.0,
        ),
        borderRadius:
            BorderRadius.circular(8.0), // Slightly less rounded corners
      ),
      elevation: isSelected ? 4.0 : 1.0,
      // Add slight elevation change on selection
      child: InkWell(
        onTap: () => onTap(item),
        child: Padding(
          // Add padding around the content
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Space out content
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align text to the start
            children: [
              // Placeholder for image area (or actual image if available)
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    // Placeholder icon as in screenshot
                    color: Colors.grey[400],
                    size: 40,
                  ),
                ),
              ),
              // Text content at the bottom
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Space between icon/image and text
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
