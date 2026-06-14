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
}
