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
import 'features/auth/presentation/cubit/auth_state.dart';
import 'core/widgets/install_pwa_overlay.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Evaluate the constrained size
        final constrainedWidth = constraints.maxWidth > 375 ? 375.0 : constraints.maxWidth;
        final constrainedSize = Size(constrainedWidth, constraints.maxHeight);
        
        final view = View.maybeOf(context);
        final baseData = view != null ? MediaQueryData.fromView(view) : const MediaQueryData();
        final constrainedData = baseData.copyWith(
          size: constrainedSize,
          textScaler: const TextScaler.linear(1.0), // Lock text scale for consistent layout
        );

        // Manually configure ScreenUtil bypassing the bugged ScreenUtilInit
        ScreenUtil.configure(
          data: constrainedData,
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
        );

        return Container(
          color: const Color(0xFFF0F2F5), // Background for empty space on desktop
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 375, // Match designSize width
            ),
            child: ClipRect(
              child: BlocProvider<AuthCubit>(
                create: (_) => sl<AuthCubit>(),
                child: ListenableBuilder(
                  listenable: Listenable.merge([
                    sl<ThemeCubit>(),
                    sl<LocaleCubit>(),
                  ]),
                  builder: (context, _) {
                    return MaterialApp.router(
                      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
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

                      // ── Global App Builder ─────────────────
                      builder: (context, child) {
                        return MediaQuery(
                          data: constrainedData,
                          child: BlocListener<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthUnauthenticated) {
                                appRouter.go(AppRoutes.login);
                              }
                            },
                            child: InstallPwaOverlay(child: child!),
                          ),
                        );
                      },

                      // ── Routing ────────────────────────────
                      routerConfig: appRouter,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
