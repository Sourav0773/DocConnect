import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/route/go_router_init.dart'; // Import your router file where routerinit is defined

class DoctorAppointmentApp extends StatelessWidget {
  const DoctorAppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Doctors Appointment App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: routerinit,
    );
  }
}