import 'package:flutter/material.dart';
import 'intro_slides_page.dart';
import 'app_drawer.dart';
import 'auth_service.dart'; // Import AuthService


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // bool _rememberMe = false; // Removed Remember Me for simplicity
  String? _errorMessage;

  // Simple flag to toggle between Login and Sign Up view
  bool _isLoginView = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      // --- Placeholder Logic ---
      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String password = _passwordController.text; // Password not used in this simple simulation

      if (_isLoginView) {
        // Simulate Login (using email/password - basic check)
        // TODO: Replace with actual authentication against stored credentials
        if (email.isNotEmpty && password.isNotEmpty) {
           print('Simulating successful login for: $email');
           // In a real app, fetch user details based on email/password
           // For simulation, we'll use the entered details if Name/Phone are also filled,
           // otherwise use placeholder data.
           String loggedInName = name.isNotEmpty ? name : "Demo User";
           String loggedInPhone = phone.isNotEmpty ? phone : "0000000000";

           AuthService.login(loggedInName, email, loggedInPhone);
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => const IntroSlidesPage()), // Navigate to Intro Slides Page
           );
        } else {
           setState(() { _errorMessage = 'Invalid login credentials (simulation).'; });
        }
      } else {
        // Simulate Sign Up / Create Account
        print('Simulating account creation for: $name, $email, $phone');
        AuthService.login(name, email, phone); // Directly log in after sign up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroSlidesPage()), // Navigate to Intro Slides Page
        );
      }
    }
  }


  void _toggleView() {
    setState(() {
      _isLoginView = !_isLoginView;
      _errorMessage = null; // Clear errors when switching views
      _formKey.currentState?.reset(); // Reset validation state
      // Optionally clear text fields
      // _nameController.clear();
      // _emailController.clear();
      // _phoneController.clear();
      // _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginView ? 'Login' : 'Sign Up'), // Dynamic title
        automaticallyImplyLeading: false, // Remove default leading icon (back arrow/hamburger)
        // Theme handles background color
      ),
      drawer: const AppDrawer(), // Drawer remains, but AppBar won't show hamburger automatically
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _isLoginView ? 'Welcome Back!' : 'Create Account',
                  textAlign: TextAlign.center,
                  // Use theme text styles directly
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        // color: AppColors.textPrimary, // Color comes from theme
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginView ? 'Login to continue' : 'Fill in the details to sign up',
                  textAlign: TextAlign.center,
                  // Use theme text style directly
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),

                // Name Field (only for Sign Up)
                if (!_isLoginView) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(context, 'Name', Icons.person_outline), // Pass context
                    validator: (value) {
                      if (!_isLoginView && (value == null || value.isEmpty)) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(context, 'Email', Icons.email_outlined), // Pass context
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                       return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone Field (only for Sign Up view in this simple setup)
                // In a real app, you might allow login with phone too.
                 if (!_isLoginView) ...[
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(context, 'Phone Number', Icons.phone_outlined), // Pass context
                      validator: (value) {
                        if (!_isLoginView) {
                           if (value == null || value.isEmpty) {
                             return 'Please enter your phone number';
                           }
                           if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                             return 'Please enter a valid 10-digit phone number';
                           }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                 ],

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(context, 'Password', Icons.lock_outline), // Pass context
                   validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                       return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // Removed Remember Me / Forgot Password for simplicity

                // Error Message Display
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      _errorMessage!,
                      // Use theme color for error
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Login/Sign Up Button - Uses ElevatedButtonTheme from main.dart
                ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    _isLoginView ? 'Login' : 'Create Account',
                  ),
                ),
                const SizedBox(height: 20),

                // Switch between Login / Sign Up Option - Uses TextButtonTheme from main.dart
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLoginView ? "Don't have an account?" : "Already have an account?",
                      style: Theme.of(context).textTheme.bodyMedium, // Use theme style
                    ),
                    TextButton(
                      onPressed: _toggleView,
                      child: Text(
                        _isLoginView ? 'Sign Up' : 'Login',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for input decoration - applies label/hint/icon to theme's base
  InputDecoration _inputDecoration(BuildContext context, String label, IconData icon) {
    // Get the base decoration from the theme
    final themeInputDecoration = Theme.of(context).inputDecorationTheme;
    // Apply specific label, hint, and icon
    return InputDecoration(
      // Inherit properties from themeInputDecoration implicitly
      labelText: label,
      hintText: 'Enter your $label',
      prefixIcon: Icon(icon), // Theme handles the color via prefixIconColor
      // Borders, fill color, padding etc. are inherited from the theme
      border: themeInputDecoration.border,
      enabledBorder: themeInputDecoration.enabledBorder,
      focusedBorder: themeInputDecoration.focusedBorder,
      filled: themeInputDecoration.filled,
      fillColor: themeInputDecoration.fillColor,
      contentPadding: themeInputDecoration.contentPadding,
      labelStyle: themeInputDecoration.labelStyle,
      hintStyle: themeInputDecoration.hintStyle,
    );
  }
}
