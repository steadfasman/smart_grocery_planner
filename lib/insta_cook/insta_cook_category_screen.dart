import 'package:flutter/material.dart';
import 'insta_cook_menu_screen.dart';
import 'insta_cook_custom_plan_flow.dart';


class InstaCookCategoryScreen extends StatelessWidget {
  const InstaCookCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insta Cook - Choose Meal'),
          automaticallyImplyLeading: false, // Remove default leading icon (hamburger/back arrow)
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.transparent,
              ],
            ),
          ),
          child: GridView.count(
            padding: const EdgeInsets.all(20.0),
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            children: [
              _buildCategoryCard(
                context,
                'Breakfast',
                '🍳',
                Theme.of(context).colorScheme.secondary,
              ),
              _buildCategoryCard(
                context,
                'Lunch',
                '🍲',
                Theme.of(context).colorScheme.primary,
              ),
              _buildCategoryCard(
                context,
                'Dinner',
                '🍛',
                Colors.red.shade700,
              ),
              _buildCategoryCard(
                context,
                'Snacks',
                '🍪',
                Colors.brown.shade500,
              ),
              _buildPlanCard(
                context,
                'Custom Plan',
                '🗓️',
                Theme.of(context).colorScheme.primary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InstaCookCustomPlanFlow()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, String emoji, Color color) {
    return _buildBaseCard(
      context: context,
      title: title,
      emoji: emoji,
      color: color,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InstaCookMenuScreen(category: title),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(BuildContext context, String title, String emoji,
      Color color, VoidCallback onTap) {
    return _buildBaseCard(
      context: context,
      title: title,
      emoji: emoji,
      color: color,
      onTap: onTap,
    );
  }

  Widget _buildBaseCard({
    required BuildContext context,
    required String title,
    required String emoji,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(1.0),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                emoji,
                style: const TextStyle(fontSize: 50.0),
              ),
              const SizedBox(height: 15.0),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black38,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
