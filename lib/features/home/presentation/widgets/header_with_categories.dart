import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/icons_helper.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../data/models/category_model.dart';
import 'category_card.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// The category row height (card height).
const double kCategoryRowH = 100;

/// Blue curved header with the categories row centred on its bottom edge.
class HeaderWithCategories extends StatelessWidget {
  final List<CategoryModel> categories;

  const HeaderWithCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topPad = MediaQuery.of(context).padding.top;
    final halfRow = (kCategoryRowH / 2).h;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Blue curved background ──────────────────
        Container(
          margin: EdgeInsets.only(bottom: categories.isNotEmpty ? halfRow : 0),
          width: double.infinity,
          padding: EdgeInsets.only(
            top: topPad + 16.h,
            left: 24.w,
            right: 24.w,
            bottom: halfRow + 16.h, // reserve space for the top half of cards
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.r),
              bottomRight: Radius.circular(28.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.storeName,
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final user = state is AuthAuthenticated ? state.user : null;
                  return Row(
                    children: [
                      Container(
                        width: 50.r,
                        height: 50.r,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            IconsHelper.user,
                            width: 26.r,
                            height: 26.r,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.welcomeBack,
                            style: TextStyle(
                              color: AppColors.background.withAlpha(200),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            user?.username ?? l10n.guest,
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        // ── Categories row — bisected by the bottom edge of the blue header ──
        if (categories.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // sit exactly in the bottom margin area
            child: SizedBox(
              height: kCategoryRowH.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemBuilder: (context, index) =>
                    CategoryCard(category: categories[index]),
              ),
            ),
          ),
      ],
    );
  }
}
