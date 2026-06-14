import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

import 'core/di/injection_container.dart';
import 'core/locale/locale_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies (GetIt + SharedPreferences)
  await initDependencies();

  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>(),
          child: ListenableBuilder(
            listenable: Listenable.merge([
              sl<ThemeCubit>(),
              sl<LocaleCubit>(),
            ]),
            builder: (context, _) {
              return MaterialApp.router(
                title: 'E-Commerce App',
                debugShowCheckedModeBanner: false,

                // ── Theme ──────────────────────────────
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: sl<ThemeCubit>().themeMode,

                // ── Locale ─────────────────────────────
                locale: sl<LocaleCubit>().locale,

                // ── Localization ───────────────────────
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,

                // ── Routing ────────────────────────────
                routerConfig: appRouter,
              );
            },
          ),
        );
      },
    );
  }
}
