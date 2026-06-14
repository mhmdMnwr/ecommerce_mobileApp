import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_information_page.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import 'app_shell.dart';

/// Application route paths — centralised to avoid magic strings.
abstract class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String categories = '/categories';
  static const String profile = '/profile';
  static const String profileInfo = '/profile/info';
}

/// Placeholder page for tabs that are not yet implemented.
class _ComingSoonPage extends StatelessWidget {
  final String title;
  const _ComingSoonPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Coming soon',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

// ── Navigation key for the shell ──────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Creates and configures the [GoRouter] instance.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.login,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    // ── Auth routes (no bottom nav) ─────────────
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),

    // ── Main app shell with bottom nav ──────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        // Tab 0 — Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => BlocProvider(
                create: (_) => sl<HomeCubit>(),
                child: const HomePage(),
              ),
            ),
          ],
        ),

        // Tab 1 — Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => BlocProvider(
                create: (_) => sl<SearchCubit>(),
                child: const SearchPage(),
              ),
            ),
          ],
        ),

        // Tab 2 — Cart
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) =>
                  const _ComingSoonPage(title: 'Cart'),
            ),
          ],
        ),

        // Tab 3 — Categories
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.categories,
              builder: (context, state) =>
                  const _ComingSoonPage(title: 'Categories'),
            ),
          ],
        ),

        // Tab 4 — Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'info',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) =>
                      const ProfileInformationPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
