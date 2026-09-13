import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/firebase_options.dart';
import 'package:restaurant_app/presentation/providers/auth_providers.dart';
import 'package:restaurant_app/presentation/providers/booking_provider.dart';
import 'package:restaurant_app/presentation/providers/restaurant_provider.dart';
import 'package:restaurant_app/presentation/screens/splash/splash_screen.dart';
import 'core/di/service_locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.serviceLocator<AuthProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.serviceLocator<RestaurantProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.serviceLocator<BookingProvider>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: AppTheme.primayColor),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

