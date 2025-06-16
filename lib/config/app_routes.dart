import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/presentation/pages/home/home_screen.dart';
import 'package:eaqarati_app/features/presentation/pages/property/add_edit_property_screen.dart';
import 'package:eaqarati_app/features/presentation/pages/property/properties_screen.dart';
import 'package:eaqarati_app/features/presentation/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/properties',
        builder: (context, state) => const PropertiesScreen(),
        routes: [
          GoRoute(
            path: 'form',
            name: 'propertyForm',
            builder: (context, state) {
              final PropertyEntity? property = state.extra as PropertyEntity?;
              return AddEditPropertyScreen(property: property);
            },
          ),
        ],
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(child: Text('Error: ${state.error}')),
        ),
  );
}
