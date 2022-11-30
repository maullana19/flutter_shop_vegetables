import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:opem/provider/user_provider.dart';
import 'package:opem/screens/buy_screen.dart';
import 'package:opem/screens/login_screen.dart';
import 'package:opem/screens/register_screen.dart';
import 'package:opem/supabase/components/auhstate.dart';
import 'package:opem/supabase/components/authrequiredstate.dart';
import 'package:opem/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configLoading();

  await Supabase.initialize(
    url: Supaurl,
    anonKey: AnonKey,
    authCallbackUrlHostname: 'login-callback', // optional
    debug: true, // optional
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (_)=> LocationProvider(),),
        // ChangeNotifierProvider(
        //   create: (_)=> StoreProvider(),),
        // ChangeNotifierProvider(
        //   create: (_)=> CartProvider(),),
        // ChangeNotifierProvider(
        //   create: (_)=> CouponProvider(),),
        // ChangeNotifierProvider(
        //   create: (_)=> OrderProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
        builder: EasyLoading.init(),
      ),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VigenMart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Supabase.instance.client.auth.currentUser != null
          ? BuyScreen()
          : LoginScreen(),
    );
  }
}
