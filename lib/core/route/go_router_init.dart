
import 'package:doctors_appointment_app/core/route/routes.dart';
import 'package:doctors_appointment_app/features/auth/login/presentation/screens/login_screen.dart';
import 'package:doctors_appointment_app/features/auth/registration/presentation/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/error/error_screen.dart';
import '../../features/splash/presentation/screeen/splash_screen.dart';
import '../logs/logger.dart';

GoRouter routerinit = GoRouter(
  routes: <RouteBase>[
    ///  =================================================================
    ///  ********************** Splash Route *****************************
    /// ==================================================================
    GoRoute(
      name: AppRoutes.SPLASH_ROUTE_NAME,
      path: AppRoutes.SPLASH_ROUTE_PATH,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),

    ///  =================================================================
    ///  ********************** Auth Route *****************************
    /// ==================================================================
    GoRoute(
      name: AppRoutes.LOGIN_ROUTE_NAME,
      path: AppRoutes.LOGIN_ROUTE_PATH,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      name: AppRoutes.REGISTRATION_ROUTE_NAME,
      path: AppRoutes.REGISTRATION_ROUTE_PATH,
      builder: (BuildContext context, GoRouterState state) {
        return const RegistrationScreen();
      },
    ),
  ],

  errorPageBuilder: (context, state) {
    return const MaterialPage(child: ErrorScreen());
  },
  redirect: (context, state) {
    logger.info('redirect: ${state.uri}');
    return null;
  },
);