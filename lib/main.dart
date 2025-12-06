// main.dart

import 'package:crafts/bloc/profile/profile_bloc.dart';
import 'package:crafts/screens/welcome_back_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProfileBloc()
                ..add(LoadProfile()), // initial load (will be updated on login)
        ),
        // Add more blocs here later if needed
      ],
      child: MaterialApp(
        title: 'Crafts',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        home: const WelcomeBackScreen(),
      ),
    );
  }
}
