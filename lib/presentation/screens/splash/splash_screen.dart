import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/animations/fade_animation.dart';
import 'package:restaurant_app/core/animations/slide_animation.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/presentation/providers/auth_providers.dart';
import 'package:restaurant_app/presentation/screens/home/home_screen.dart';
import 'package:restaurant_app/presentation/screens/welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen();
    });
    super.initState();
  }

  void _navigateToNextScreen() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.authStatus == AuthStatus.initial) {
      await authProvider.checkAuthStatus();
    }

    await Future.delayed(Duration(milliseconds: 3000));
    final isLoggedIn = authProvider.authStatus == AuthStatus.authenticated;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>
        isLoggedIn ? HomeScreen() :
         WelcomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeAnimation(
                child: SlideAnimation(
                  direction: SlideDirection.fromTop,
                  child: Center(
                    child: Image.asset(
                      'assets/images/splash.png',
                      height: 240,
                      width: 240,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              FadeAnimation(
                delay: Duration(milliseconds: 300),
                child: SlideAnimation(
                  delay: Duration(milliseconds: 300),
                  child: Text(
                    'Book Your \n Favorites Resto',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                delay: Duration(milliseconds: 400),
                child: SlideAnimation(
                  delay: Duration(milliseconds: 400),
                  child: Text(
                    'One-stop app for effortless dining reservations. Discover top restaurants, view real-time table availability, and secure your spot in seconds—ensuring you never miss out on your favorite dining experiences',
                    style: TextStyle(fontSize: 14, color: AppTheme.darkGrey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
