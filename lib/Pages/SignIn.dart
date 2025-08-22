import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/supabase_helper_private.dart';
import 'RegisterPage.dart';
import 'GarageHomePage.dart';
import '../Widgets/customtextfield.dart';
import '../Widgets/SocialButton.dart';
import 'UserLoader.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  /// SnackBar Helper
  void _showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Email & Password SignIn Logic
  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Please enter email & password", error: true);
      return;
    }

    try {
      setState(() => _isLoading = true);

      final response = await SupabaseHelper.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        _showSnack("Login Successful ✅");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserLoaderPage()),
        );
      } else {
        _showSnack("Invalid email or password!", error: true);
      }
    } catch (e) {
      _showSnack("Error: ${e.toString()}", error: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Image
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Dark Overlay
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.5),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  // App Title
                  Text(
                    "PENTAPARK",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Subtitle
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Create new account",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFA7C5EF),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  Text(
                    "or",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    "Log in with your email",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFA7C5EF),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  customTextField(
                    controller: _emailController,
                    hint: "email@domain.com",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  customTextField(
                    controller: _passwordController,
                    hint: "Enter your password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Continue Button
                  SizedBox(
                    width: 400,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signInWithEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF000000),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Log In",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFA7C5EF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // OR Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Color(0xFFE6E6E6), thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "OR",
                          style: GoogleFonts.poppins(
                            color: Color(0xFFA7C5EF),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Color(0xFFE6E6E6), thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
