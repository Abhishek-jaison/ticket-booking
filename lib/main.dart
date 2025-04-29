import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticket/providers/event_provider.dart';
import 'package:event_ticket/screens/main_screen.dart';
import 'package:event_ticket/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        title: 'Event Ticket',
        theme: AppTheme.darkTheme,
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
