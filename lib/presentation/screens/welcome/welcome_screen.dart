import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/animations/fade_animation.dart';
import 'package:restaurant_app/core/animations/slide_animation.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/presentation/screens/auth/login_screen.dart';
import 'package:restaurant_app/presentation/screens/auth/register_screen.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeAnimation(
                child: SlideAnimation(
                  direction: SlideDirection.fromTop,
                  child: Center(
                    child: Image.asset(
                      'assets/images/welcome.png',
                      height: 240,
                      width: 240,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),
              FadeAnimation(
                delay: Duration(milliseconds: 300),

                child: SlideAnimation(
                  delay: Duration(milliseconds: 300),

                  child: Text(
                    'Welcome',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 16),
              FadeAnimation(
                delay: Duration(milliseconds: 400),
                child: SlideAnimation(
                  delay: Duration(milliseconds: 400),
                  child: Text(
                    'Before enjoying services \n Please register first',
                    style: TextStyle(fontSize: 16, color: AppTheme.darkGrey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height:40),
              SizedBox(
                width: double.infinity,
                child: FadeAnimation(
                  delay: Duration(milliseconds: 500),

                  child: CustomButton(
                            width: double.infinity,

                    backgroundColor: AppTheme.primayLight,
                    text: 'Create Account',
                    textColor: AppTheme.primayColor,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FadeAnimation(
                  delay: Duration(milliseconds: 600),

                  child: CustomButton(
                            width: double.infinity,

                    backgroundColor: AppTheme.primayColor,
                    text: 'Login',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );

                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                delay: Duration(milliseconds: 700),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'By logging in or registering, you have agreed to',
                      style: TextStyle(color: AppTheme.darkGrey, fontSize: 12),
                      children: [
                        TextSpan(
                          text: ' the Terms and Conditions',
                          style: TextStyle(
                            color: AppTheme.primayColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("the Terms and Conditions di click");
                            },
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            color: AppTheme.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppTheme.primayColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Privacy Policy di click");
                            },
                        ),
                      ],
                    ),
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
