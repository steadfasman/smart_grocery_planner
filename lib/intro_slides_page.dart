import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trailproj/main_navigation_page.dart'; // Import the new main navigation page

// Re-added the class definition
class IntroSlidesPage extends StatefulWidget {
  const IntroSlidesPage({super.key});

  @override
  State<IntroSlidesPage> createState() => _IntroSlidesPageState();
}

class _IntroSlidesPageState extends State<IntroSlidesPage> {
  final PageController _pageController = PageController();
  final int _numPages = 3;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        // Use addPostFrameCallback to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _currentPage = _pageController.page!.round();
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack( // Use Stack to position back button
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: const [
                      // Assuming image paths based on common practice and previous errors
                      IntroSlide(
                        imagePath: "assets/images/intro_slide_3.png", // Local, Customized Meal Planning
                        title: "Local, Customized Meal Planning",
                        text:
                            "Create your own customized meal plan from our selection of healthy meal options.",
                      ),
                      IntroSlide(
                        imagePath: "assets/images/intro_slide_2.png", // Delicious and Nutritious
                        title: "Delicious and Nutritious Fresh Meals",
                        text:
                            "Enjoy healthy and delicious meals delivered to your doorstep, prepared with fresh, high-quality ingredients.",
                      ),
                      IntroSlide(
                        imagePath: "assets/images/intro_slide_1.png", // Gourmet Quality
                        title: "Gourmet Quality, Hassle-Free",
                        text:
                            "Savor chef-inspired meals without the hassle of cooking or cleaning up, with our gourmet meal delivery service.",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0, left: 30.0, right: 30.0, top: 20.0), // Adjusted padding
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _numPages,
                        effect: WormEffect( // Changed effect
                          activeDotColor: Colors.grey.shade800, // Darker active dot
                          dotColor: Colors.grey.shade300, // Lighter inactive dot
                          dotHeight: 8, // Smaller dots
                          dotWidth: 8,
                          spacing: 12, // Increased spacing
                        ),
                      ),
                      const SizedBox(height: 40), // Increased spacing
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA6D879), // Specific light green
                          foregroundColor: Colors.black, // Text color
                          minimumSize: const Size(double.infinity, 55), // Full width, slightly taller
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // More rounded corners
                          ),
                          elevation: 2, // Subtle shadow
                        ),
                        onPressed: () {
                          // Navigate to MainNavigationPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainNavigationPage()),
                          );
                        },
                        child: Text(
                          'Continue',
                          // Using Poppins as it's often used in modern UI, adjust if needed
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Positioned Back Button
            Positioned(
              top: 15,
              left: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.8), // Light grey background
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54, size: 20), // Styled icon
                  onPressed: () {
                    if (_currentPage > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Optional: Handle back press on the first slide (e.g., exit app or do nothing)
                      // Navigator.maybePop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroSlide extends StatelessWidget {
  final String imagePath; // Changed to imagePath
  final String title;
  final String text;

  const IntroSlide({
    super.key,
    required this.imagePath, // Changed parameter
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0), // Adjusted horizontal padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60), // Add space at the top to avoid overlap with back button
          Image.asset(
            imagePath, // Use imagePath
            height: 280, // Adjust height based on image aspect ratio
            errorBuilder: (context, error, stackTrace) {
              // Simple placeholder on error
              return Container(
                height: 280,
                color: Colors.grey.shade300,
                child: const Center(child: Text('Image not found')),
              );
            },
          ),
          const SizedBox(height: 50), // Increased spacing
          Text(
            title,
            textAlign: TextAlign.center,
            // Using Poppins, adjust font if needed
            style: GoogleFonts.poppins(
              fontSize: 28, // Larger title
              fontWeight: FontWeight.w600, // Slightly less bold
              color: Colors.grey.shade800, // Dark grey
            ),
          ),
          const SizedBox(height: 25), // Increased spacing
          Text(
            text,
            textAlign: TextAlign.center,
            // Using Poppins, adjust font if needed
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600, // Medium grey
              height: 1.6, // Increased line spacing
            ),
          ),
          // Removed Spacer to allow content to center based on available space
        ],
      ),
    );
  }
}
