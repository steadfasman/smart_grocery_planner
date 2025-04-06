import 'package:supabase_flutter/supabase_flutter.dart';

class MenuItem {
  final String name;
  final String imagePath;
  final List<String> suggestedSideDishes; // Added side dishes

  MenuItem({
    required this.name,
    required this.imagePath,
    this.suggestedSideDishes = const [], // Default to empty list
  });


   final SupabaseClient supabase = Supabase.instance.client;





   Future<List<Map<String, dynamic>>> fetchMenuItems() async {
    final response = await supabase.from('menu_items').select('*');

    if (response.isEmpty) {
      return [];
    }

    return List<Map<String,dynamic>>.from(response);
  }









}





























// --- Sample Data with Side Dishes ---

List<MenuItem> breakfastItems = [
  MenuItem(
    name: 'Dosa',
    imagePath: 'assets/images/dosa.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Sambar', 'Coconut Chutney', 'Tomato Chutney', 'Potato Masala'],
  ),
  MenuItem(
    name: 'Idli',
    imagePath: 'assets/images/idli.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Sambar', 'Coconut Chutney', 'Podi'],
  ),
  MenuItem(name: 'Poha', imagePath: 'assets/images/poha.jpg'), // Added assets/ prefix
  MenuItem(name: 'Upma', imagePath: 'assets/images/upma.jpg', suggestedSideDishes: ['Coconut Chutney']), // Added assets/ prefix
  MenuItem(
    name: 'Chapathi',
    imagePath: 'assets/images/chapathi.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Vegetable Kurma', 'Dal Fry', 'Paneer Butter Masala'],
  ),
];

List<MenuItem> lunchItems = [
  MenuItem(
    name: 'Rice',
    imagePath: 'assets/images/rice.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Dal', 'Sambar', 'Rasam', 'Curd', 'Vegetable Stir Fry'],
   ),
  MenuItem(name: 'Dal', imagePath: 'assets/images/dal.jpg'), // Added assets/ prefix
  MenuItem(
    name: 'Roti',
    imagePath: 'assets/images/roti.jpg', // Added assets/ prefix
     suggestedSideDishes: ['Vegetable Curry', 'Dal Makhani', 'Paneer Tikka Masala'],
  ),
  MenuItem(name: 'Sabzi', imagePath: 'assets/images/sabzi.jpg'), // Added assets/ prefix
  MenuItem(name: 'Salad', imagePath: 'assets/images/salad.jpg'), // Added assets/ prefix
];

List<MenuItem> dinnerItems = [
  MenuItem(
    name: 'Biryani',
    imagePath: 'assets/images/biryani.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Raita', 'Salan'],
  ),
  MenuItem(
    name: 'Chicken Curry',
    imagePath: 'assets/images/chicken_curry.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Rice', 'Roti', 'Naan'],
   ),
  MenuItem(
    name: 'Palak Paneer',
    imagePath: 'assets/images/palak_paneer.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Roti', 'Naan', 'Jeera Rice'],
  ),
  MenuItem(
    name: 'Rajma',
    imagePath: 'assets/images/rajma.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Rice', 'Roti'],
  ),
  MenuItem(
    name: 'Chole Bhature',
    imagePath: 'assets/images/chole_bhature.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Onion Salad', 'Pickle'],
  ),
];

List<MenuItem> snackItems = [
  MenuItem(
    name: 'Samosa',
    imagePath: 'assets/images/samosa.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Mint Chutney', 'Tamarind Chutney'],
  ),
  MenuItem(
    name: 'Pakora',
    imagePath: 'assets/images/pakora.jpg', // Added assets/ prefix
    suggestedSideDishes: ['Mint Chutney', 'Ketchup'],
   ),
  MenuItem(name: 'Chivda', imagePath: 'assets/images/chivda.jpg'), // Added assets/ prefix
  MenuItem(name: 'Bhujia', imagePath: 'assets/images/bhujia.jpg'), // Added assets/ prefix
  MenuItem(name: 'Namkeen', imagePath: 'assets/images/namkeen.jpg'), // Added assets/ prefix
];

// --- Ingredient Mapping (Example - Needs to be comprehensive) ---
Map<String, List<String>> ingredients = {
  'Dosa': ['Rice Flour', 'Urad Dal', 'Fenugreek Seeds', 'Salt', 'Oil'],
  'Sambar': ['Toor Dal', 'Tamarind', 'Sambar Powder', 'Vegetables (Drumstick, Onion, Tomato, etc.)', 'Mustard Seeds', 'Curry Leaves'],
  'Coconut Chutney': ['Coconut', 'Green Chilies', 'Ginger', 'Mustard Seeds', 'Curry Leaves'],
  'Idli': ['Idli Rice', 'Urad Dal', 'Fenugreek Seeds', 'Salt'],
  'Rice': ['Basmati Rice', 'Water'],
  'Dal': ['Toor Dal/Moong Dal', 'Onion', 'Tomato', 'Ginger', 'Garlic', 'Spices'],
  'Biryani': ['Basmati Rice', 'Chicken/Vegetables', 'Yogurt', 'Onion', 'Tomato', 'Ginger-Garlic Paste', 'Biryani Masala', 'Mint', 'Coriander'],
  'Raita': ['Yogurt', 'Onion/Cucumber/Tomato', 'Cumin Powder', 'Salt'],
  // Add ingredients for all dishes and side dishes
};

// --- Side Dish Data (Placeholder) ---
class SideDishItem {
  final String name;
  final String imagePath; // Optional image path
  final List<String> ingredients;

  const SideDishItem({
    required this.name,
    this.imagePath = 'assets/images/placeholder.png', // Added assets/ prefix to default
    required this.ingredients,
  });
}

// Sample Side Dish List (Add more as needed)
List<SideDishItem> allSideDishes = const [
  SideDishItem(name: 'Sambar', ingredients: ['Toor Dal', 'Tamarind', 'Sambar Powder', 'Vegetables', 'Mustard Seeds', 'Curry Leaves']),
  SideDishItem(name: 'Coconut Chutney', ingredients: ['Coconut', 'Green Chilies', 'Ginger', 'Mustard Seeds', 'Curry Leaves']),
  SideDishItem(name: 'Tomato Chutney', ingredients: ['Tomato', 'Onion', 'Red Chilies', 'Mustard Seeds']),
  SideDishItem(name: 'Potato Masala', ingredients: ['Potato', 'Onion', 'Mustard Seeds', 'Turmeric']),
  SideDishItem(name: 'Podi', ingredients: ['Lentils', 'Red Chilies', 'Sesame Seeds', 'Asafoetida']),
  SideDishItem(name: 'Vegetable Kurma', ingredients: ['Mixed Vegetables', 'Coconut Milk', 'Spices']),
  SideDishItem(name: 'Dal Fry', ingredients: ['Toor Dal', 'Onion', 'Tomato', 'Spices']),
  SideDishItem(name: 'Paneer Butter Masala', ingredients: ['Paneer', 'Tomato Puree', 'Cream', 'Butter', 'Spices']),
  SideDishItem(name: 'Rasam', ingredients: ['Tamarind', 'Tomato', 'Rasam Powder', 'Mustard Seeds']),
  SideDishItem(name: 'Curd', ingredients: ['Yogurt']),
  SideDishItem(name: 'Vegetable Stir Fry', ingredients: ['Mixed Vegetables', 'Soy Sauce', 'Oil']),
  SideDishItem(name: 'Dal Makhani', ingredients: ['Black Lentils', 'Kidney Beans', 'Cream', 'Butter', 'Spices']),
  SideDishItem(name: 'Paneer Tikka Masala', ingredients: ['Paneer', 'Yogurt', 'Tikka Masala Spice', 'Onion', 'Tomato']),
  SideDishItem(name: 'Raita', ingredients: ['Yogurt', 'Onion/Cucumber/Tomato', 'Cumin Powder', 'Salt']),
  SideDishItem(name: 'Salan', ingredients: ['Peanuts', 'Sesame Seeds', 'Coconut', 'Tamarind', 'Spices']),
  SideDishItem(name: 'Naan', ingredients: ['All-Purpose Flour', 'Yogurt', 'Yeast', 'Sugar', 'Salt']),
  SideDishItem(name: 'Jeera Rice', ingredients: ['Basmati Rice', 'Cumin Seeds', 'Ghee']),
  SideDishItem(name: 'Onion Salad', ingredients: ['Onion', 'Lemon Juice', 'Coriander']),
  SideDishItem(name: 'Pickle', ingredients: ['Mango/Lemon/Mixed Vegetables', 'Oil', 'Spices']),
  SideDishItem(name: 'Mint Chutney', ingredients: ['Mint Leaves', 'Coriander Leaves', 'Green Chilies', 'Lemon Juice']),
  SideDishItem(name: 'Tamarind Chutney', ingredients: ['Tamarind', 'Jaggery', 'Spices']),
  SideDishItem(name: 'Ketchup', ingredients: ['Tomato Concentrate', 'Vinegar', 'Sugar', 'Salt']),
  // Generic Sides
  SideDishItem(name: 'Garden Salad', ingredients: ['Lettuce', 'Tomato', 'Cucumber', 'Vinaigrette']),
  SideDishItem(name: 'Steamed Broccoli', ingredients: ['Broccoli', 'Olive Oil', 'Salt']),
  SideDishItem(name: 'Garlic Bread', ingredients: ['Baguette', 'Garlic', 'Butter', 'Parsley']),
  SideDishItem(name: 'Quinoa', ingredients: ['Quinoa', 'Water', 'Salt']),
];
