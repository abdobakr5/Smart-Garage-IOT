import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/supabase_helper.dart';
import '../Widgets/customtextfield.dart';
import '../Widgets/SocialButton.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _registerWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await SupabaseHelper.registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      _showSnackBar('Registration successful! Please sign in now.');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }

    } catch (e) {
      String errorMessage = 'Registration failed';

      if (e.toString().contains('Email already registered')) {
        errorMessage = 'This email is already registered. Please try signing in instead.';
      } else if (e.toString().contains('Invalid email')) {
        errorMessage = 'Please enter a valid email address.';
      } else if (e.toString().contains('Password should be at least 6 characters')) {
        errorMessage = 'Password must be at least 6 characters long.';
      } else if (e.toString().contains('Network')) {
        errorMessage = 'Network error. Please check your connection and try again.';
      }

      _showSnackBar(errorMessage, isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Reg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.09),
          ),



          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.3),
                    ),
                  ),

                  const SizedBox(height: 40),
                  // Title
                  Stack(
                    children: [
                      Text(
                        'Register Now',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        'Register Now',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),



                  const SizedBox(height: 40),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customTextField(controller: _firstNameController, hint: "First Name"),
                        const SizedBox(height: 12),
                        customTextField(controller: _lastNameController, hint: "Last Name"),
                        const SizedBox(height: 12),
                        customTextField(
                          controller: _emailController,
                          hint: "email@domain.com",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        customTextField(
                          controller: _passwordController,
                          hint: "Password",
                          obscureText: true,
                        ),

                        const SizedBox(height: 24),

                        // Sign Up Button with minimal width
                        SizedBox(
                          width: 150,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _registerWithEmail,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black, width: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF87CEEB),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // OR Divider
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Color(0xFFE6E6E6))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: Color(0xFFE6E6E6))),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Google Sign In
                        buildSocialButton(
                          text: 'Continue with Google',
                          assetPath: 'assets/images/google.png',
                          onPressed: () {},
                        ),

                        // Apple Sign In
                        buildSocialButton(
                          text: 'Continue with Apple',
                          assetPath: 'assets/images/apple.png',
                          onPressed: () {},
                        ),

                        const SizedBox(height: 24),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
