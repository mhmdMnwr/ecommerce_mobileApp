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
import '../../features/profile/presentation/pages/contact_us_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/home/data/models/product_model.dart';
import '../../features/search/presentation/cubit/search_state.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/categories/presentation/pages/categories_grid_page.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/cart/presentation/pages/orders_history_page.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/feedback/presentation/cubit/feedback_cubit.dart';
import '../../features/feedback/presentation/pages/feedback_page.dart';
import 'app_shell.dart';

/// Application route paths — centralised to avoid magic strings.
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String categories = '/categories';
  static const String profile = '/profile';
  static const String profileInfo = '/profile/info';
  static const String product = '/product';
  static const String ordersHistory = '/orders-history';
  static const String notifications = '/notifications';
  static const String feedback = '/feedback';
  static const String contactUs = '/contact-us';
}


// ── Navigation key for the shell ──────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Creates and configures the [GoRouter] instance.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    // ── Splash screen ──────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const LoginPage(),
    ),
    // ── Auth routes (no bottom nav) ─────────────
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.product,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return ProductPage(product: product);
      },
    ),
    // ── Orders History (full-screen, outside shell) ──
    GoRoute(
      path: AppRoutes.ordersHistory,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => BlocProvider.value(
        value: sl<CartCubit>(),
        child: const OrdersHistoryPage(),
      ),
    ),
    // ── Notifications (full-screen, outside shell) ──
    GoRoute(
      path: AppRoutes.notifications,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => BlocProvider.value(
        value: sl<NotificationCubit>(),
        child: const NotificationsPage(),
      ),
    ),
    // ── Feedback (full-screen, outside shell) ──
    GoRoute(
      path: AppRoutes.feedback,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<FeedbackCubit>(),
        child: const FeedbackPage(),
      ),
    ),

    // ── Contact Us (full-screen, outside shell) ──
    GoRoute(
      path: AppRoutes.contactUs,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ContactUsPage(),
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
              builder: (context, state) => BlocProvider.value(
                value: sl<CartCubit>(),
                child: const CartPage(),
              ),
            ),
          ],
        ),

        // Tab 3 — Categories
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.categories,
              builder: (context, state) => const CategoriesPage(),
              routes: [
                GoRoute(
                  path: 'grid',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (_) => sl<CategoriesCubit>(),
                    child: CategoriesGridPage(
                      type: state.uri.queryParameters['type'] ?? 'category',
                    ),
                  ),
                ),
                GoRoute(
                  path: 'products',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final type = state.uri.queryParameters['type'] ?? 'category';
                    final id = state.uri.queryParameters['id'] ?? '';
                    final name = state.uri.queryParameters['name'] ?? '';
                    
                    final filters = type == 'category' 
                        ? SearchFilters(categoryId: id, categoryName: name, sort: 'title')
                        : SearchFilters(brandTitle: name, sort: 'title');

                    return BlocProvider(
                      create: (_) => sl<SearchCubit>(),
                      child: SearchPage(initialFilters: filters),
                    );
                  },
                ),
              ],
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
