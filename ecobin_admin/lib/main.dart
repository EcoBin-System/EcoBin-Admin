import 'package:ecobin_admin/user_management/models/UserModel.dart';
import 'package:ecobin_admin/user_management/screens/wrapper.dart';
import 'package:ecobin_admin/user_management/services/auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization for both Web and Mobile platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBJTLL-PI4GFMYOXiIn29ALwOUYg_UFeuc",
        authDomain: "ecobin-16e9d.firebaseapp.com",
        projectId: "ecobin-16e9d",
        storageBucket: "ecobin-16e9d.appspot.com",
        messagingSenderId: "330593333648",
        appId: "1:330593333648:web:9f9db2efbcdee29bb8c315",
        measurementId: "G-CWLWLZEPET",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: UserModel(uid: ""),
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Disable the debug banner
        home: const Wrapper(),
        theme: ThemeData(
          // Using Google Fonts for the text theme
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: '/',
        routes: {
          // Define any other routes here
          // '/login': (context) => LoginPage(),
        },
      ),
    );
  }
}
