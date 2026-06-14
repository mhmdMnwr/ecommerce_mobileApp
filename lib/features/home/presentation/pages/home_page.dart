import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_message_translator.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/header_with_categories.dart';
import '../widgets/products_row.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Home screen — header, categories, new & popular products.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HomeError) {
            return _buildError(context, state.message);
          }

          if (state is HomeLoaded) {
            return Column(
              children: [
                // ── Fixed header ──────────────────────
                HeaderWithCategories(categories: state.categories),

                // ── Scrollable content ────────────────
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () =>
                        context.read<HomeCubit>().loadHomeData(),
                    child: ListView(
                      padding: EdgeInsets.only(top: 32.h),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SectionHeader(
                          title: l10n.newProducts,
                          onViewMore: () {},
                        ),
                        SizedBox(height: 12.h),
                        ProductsRow(
                          products: state.newProducts,
                          currency: l10n.currency,
                        ),
                        SizedBox(height: 36.h),
                        SectionHeader(
                          title: l10n.popular,
                          onViewMore: () {},
                        ),
                        SizedBox(height: 12.h),
                        ProductsRow(
                          products: state.popularProducts,
                          currency: l10n.currency,
                        ),
                        SizedBox(height: 48.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              translateAuthMessage(context, message),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 20.h),
            TextButton.icon(
              onPressed: () => context.read<HomeCubit>().loadHomeData(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
