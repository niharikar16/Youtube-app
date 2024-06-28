import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_auth/screens/dashboard.dart';
import 'package:Youtube_supabase/screens/authentication/sign_in_screen.dart';
import 'package:Youtube_supabase/screens/authentication/sign_up_screen.dart';
import 'package:Youtube_supabase/screens/Youtube/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://rqsmdktmqzibisqokfqe.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJxc21ka3RtcXppYmlzcW9rZnFlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkzMTg4MDksImV4cCI6MjAzNDg5NDgwOX0.pDNRoagN12Vug_FDGho7-alMKat7L4EuE8I7VaquvxI',
      authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (_) => const SignInScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/homescreen': (_) => HomeScreen(),
      },
    );
  }
}
