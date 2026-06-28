import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/utils/auth_message_translator.dart';
import '../../../search/presentation/cubit/search_cubit.dart';
import '../../../search/presentation/cubit/search_state.dart';
import '../../../search/presentation/pages/search_page.dart';
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

  void _viewMoreNew() {
    // Navigate to SearchPage sorted by newest (sort=-createdAt), limit 50
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<SearchCubit>(),
          child: SearchPage(
            initialFilters: const SearchFilters(sort: '-createdAt'),
            pageTitle: null, // will use l10n.newestProducts
          ),
        ),
      ),
    );
  }

  void _viewMorePopular() {
    // Navigate to SearchPage sorted by best-selling (sort=-sold), limit 50
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<SearchCubit>(),
          child: SearchPage(
            initialFilters: const SearchFilters(sort: '-sold'),
            pageTitle: null, // will use l10n.bestSelling
          ),
        ),
      ),
    );
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
              child: AppLoadingIndicator(),
            );
          }

          if (state is HomeError) {
            return _buildError(context, translateAuthMessage(context, state.message), l10n);
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
                          onViewMore: _viewMoreNew,
                        ),
                        SizedBox(height: 12.h),
                        ProductsRow(
                          products: state.newProducts,
                          currency: l10n.currency,
                        ),
                        SizedBox(height: 36.h),
                        SectionHeader(
                          title: l10n.popular,
                          onViewMore: _viewMorePopular,
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

  Widget _buildError(BuildContext context, String message, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 40.r, color: AppColors.error),
            ),
            SizedBox(height: 20.h),
            Text(
              translateAuthMessage(context, message),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 24.h),
            TextButton.icon(
              onPressed: () => context.read<HomeCubit>().loadHomeData(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
