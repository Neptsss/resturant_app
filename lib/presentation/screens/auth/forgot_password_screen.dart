import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/animations/fade_animation.dart';
import 'package:restaurant_app/core/animations/slide_animation.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/presentation/providers/auth_providers.dart';
import 'package:restaurant_app/presentation/screens/home/home_screen.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';
import 'package:restaurant_app/presentation/widgets/custom_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.forgotPassword(_emailController.text);
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
              child: ap.isSuccessSendForgotPasword
                  ? buildSuccessView()
                  : buildFormView(ap),
            ),
          );
        },
      ),
    );
  }

  Widget buildSuccessView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            FadeAnimation(
              child: SlideAnimation(
                direction: SlideDirection.fromTop,
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 130,
                    color: AppTheme.success,
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),
            FadeAnimation(
              child: SlideAnimation(
                child: Text(
                  "Success",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 8),
            FadeAnimation(
              delay: Duration(milliseconds: 200),
              child: SlideAnimation(
                delay: Duration(milliseconds: 200),
                child: Text(
                  "Please check yout email for create  \na new password",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 25),
            FadeAnimation(
              delay: Duration(milliseconds: 700),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Can't get email?",
                    style: TextStyle(color: AppTheme.darkGrey, fontSize: 16, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: 'Resubmit',
                        style: TextStyle(
                          color: AppTheme.primayColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                             Provider.of<AuthProvider>(context, listen: false).resetForgotPassword();
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
    );
  }

  Form buildFormView(AuthProvider ap) {
    return Form(
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
                  "Forget Password",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 8),
            FadeAnimation(
              delay: Duration(milliseconds: 200),
              child: SlideAnimation(
                delay: Duration(milliseconds: 200),
                child: Text(
                  "Enter your registered email below ",
                  style: TextStyle(fontSize: 12),
                ),
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

            if (ap.forgotPasswordStatus == FormStatus.error)
              SizedBox(height: 20),
            if (ap.forgotPasswordStatus == FormStatus.error)
              FadeAnimation(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppTheme.error),
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
                alignment: Alignment.center,
                child: CustomButton(
                  text: 'Submit',
                  onPressed: _resetPassword,
                  isLoading: ap.forgotPasswordStatus == FormStatus.submitting,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
