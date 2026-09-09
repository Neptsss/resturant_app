import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/animations/fade_animation.dart';
import 'package:restaurant_app/core/animations/slide_animation.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/presentation/providers/auth_providers.dart';
import 'package:restaurant_app/presentation/screens/home/home_screen.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';
import 'package:restaurant_app/presentation/widgets/custom_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obsecurePassword = !_obsecurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obsecureConfirmPassword = !_obsecureConfirmPassword;
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
   await authProvider.register(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );

      if (authProvider.registerStatus == FormStatus.succes) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Consumer<AuthProvider>(
        builder: (context, ap, _) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeAnimation(
                        child: SlideAnimation(
                          child: Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      FadeAnimation(
                        delay: Duration(milliseconds: 200),
                        child: SlideAnimation(
                          delay: Duration(milliseconds: 200),
                          child: Text(
                            "Before enjoying services\nPlease register first",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeAnimation(
                        delay: Duration(milliseconds: 400),
                        child: CustomForm(
                          controller: _nameController,
                          hintText: "Full Name",
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeAnimation(
                        delay: Duration(milliseconds: 500),
                        child: CustomForm(
                          controller: _emailController,
                          hintText: "Email",
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeAnimation(
                        delay: Duration(milliseconds: 500),
                        child: CustomForm(
                          controller: _passwordController,
                          maxLines: 1,
                          hintText: "Password",
                          obsecureText: _obsecurePassword,
                          prefixIcon: Icons.lock_outlined,
                          suffixIcon: IconButton(
                            onPressed: _togglePasswordVisibility,
                            icon: Icon(
                              _obsecurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppTheme.grey,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeAnimation(
                        delay: Duration(milliseconds: 500),
                        child: CustomForm(
                          controller: _confirmPasswordController,
                          maxLines: 1,
                          hintText: "Confirm Password",
                          obsecureText: _obsecureConfirmPassword,
                          prefixIcon: Icons.lock_outlined,
                          suffixIcon: IconButton(
                            onPressed: _toggleConfirmPasswordVisibility,
                            icon: Icon(
                              _obsecureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppTheme.grey,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }

                            if (value != _passwordController.text) {
                              return "Password do not match";
                            }
                            return null;
                          },
                        ),
                      ),
                      if (ap.registerStatus == FormStatus.error) SizedBox(height: 20),
                      if (ap.registerStatus == FormStatus.error)
                        FadeAnimation(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withValues(alpha: 0.1),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppTheme.error,
                                ),
                                Expanded(
                                  child: Text(
                                    ap.errorMessage ?? 'N/A Error occured',
                                    style: TextStyle(color: AppTheme.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(height: 20),
                      FadeAnimation(
                        delay: Duration(milliseconds: 800),
                        child: Align(
                          alignment : Alignment.center,
                          child: CustomButton(
                            width: double.infinity,
                            text: 'Registration',
                            onPressed: _register,
                            isLoading: ap.registerStatus == FormStatus.submitting,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
