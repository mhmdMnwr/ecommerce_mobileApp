import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locale/locale_cubit.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';
import '../theme/theme_cubit.dart';
import '../utils/constants.dart';
import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/data_sources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/search/data/data_sources/search_remote_data_source.dart';
import '../../features/search/data/repositories/search_repository.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/categories/data/datasources/categories_remote_data_source.dart';
import '../../features/categories/data/repositories/categories_repository.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/cart/data/data_sources/order_remote_data_source.dart';
import '../../features/cart/data/repositories/order_repository.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/notifications/data/data_sources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../../features/feedback/data/data_sources/feedback_remote_data_source.dart';
import '../../features/feedback/data/repositories/feedback_repository.dart';
import '../../features/feedback/presentation/cubit/feedback_cubit.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initializes all dependencies in the service locator.
/// Must be called before [runApp].
Future<void> initDependencies() async {
  // ──────────────────────────────────────────────
  // External
  // ──────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ──────────────────────────────────────────────
  // Core — Storage, Theme & Locale
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit());

  // ──────────────────────────────────────────────
  // Core — Networking
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: AppConstants.baseUrl,
      tokenStorage: sl<TokenStorage>(),
    ),
  );

  // ──────────────────────────────────────────────
  // Feature — Auth
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<ApiClient>().dio),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      remote: sl<AuthRemoteDataSource>(),
      tokenStorage: sl<TokenStorage>(),
    ),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(sl<AuthRepository>()),
  );

  // ──────────────────────────────────────────────
  // Feature — Home
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl<ApiClient>().dio),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepository(sl<HomeRemoteDataSource>()),
  );

  sl.registerFactory<HomeCubit>(
    () => HomeCubit(sl<HomeRepository>()),
  );

  // ──────────────────────────────────────────────
  // Feature — Search
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSource(sl<ApiClient>().dio),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepository(sl<SearchRemoteDataSource>()),
  );

  sl.registerFactory<SearchCubit>(
    () => SearchCubit(sl<SearchRepository>(), sl<HomeRepository>()),
  );

  // ──────────────────────────────────────────────
  // Feature — Categories
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSource(sl<ApiClient>().dio),
  );

  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepository(sl<CategoriesRemoteDataSource>()),
  );

  sl.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(sl<CategoriesRepository>()),
  );

  // ──────────────────────────────────────────────
  // Feature — Cart / Orders
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(sl<ApiClient>().dio),
  );

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepository(sl<OrderRemoteDataSource>()),
  );

  // Singleton so cart state persists across tab switches
  sl.registerLazySingleton<CartCubit>(
    () => CartCubit(sl<OrderRepository>()),
  );

  // ──────────────────────────────────────────────
  // Feature — Notifications
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSource(sl<ApiClient>().dio),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(sl<NotificationRemoteDataSource>()),
  );

  // Singleton so badge count persists across tab switches
  sl.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(sl<NotificationRepository>()),
  );

  // ──────────────────────────────────────────────
  // Feature — Feedback
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<FeedbackRemoteDataSource>(
    () => FeedbackRemoteDataSource(sl<ApiClient>().dio),
  );

  sl.registerLazySingleton<FeedbackRepository>(
    () => FeedbackRepository(sl<FeedbackRemoteDataSource>()),
  );

  sl.registerFactory<FeedbackCubit>(
    () => FeedbackCubit(sl<FeedbackRepository>()),
  );
}
