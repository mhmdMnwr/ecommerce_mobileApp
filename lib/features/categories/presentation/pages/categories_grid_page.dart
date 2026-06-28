import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/routing/app_router.dart';
import '../cubit/categories_cubit.dart';
import '../../../home/data/models/category_model.dart';
import '../../data/models/brand_model.dart';
import '../../../../core/utils/auth_message_translator.dart';

class CategoriesGridPage extends StatefulWidget {
  final String type; // 'category' or 'brand'

  const CategoriesGridPage({super.key, required this.type});

  @override
  State<CategoriesGridPage> createState() => _CategoriesGridPageState();
}

class _CategoriesGridPageState extends State<CategoriesGridPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18.r,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.type == 'category' ? l10n.categories : l10n.brands,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const Center(
              child: AppLoadingIndicator(),
            );
          } else if (state is CategoriesError) {
            return Center(
              child: Text(
                translateAuthMessage(context, state.message),
                style: TextStyle(color: AppColors.error),
              ),
            );
          } else if (state is CategoriesLoaded) {
            final itemsCount = widget.type == 'category'
                ? state.categories.length
                : state.brands.length;

            return GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.85,
              ),
              itemCount: itemsCount,
              itemBuilder: (context, index) {
                if (widget.type == 'category') {
                  return _buildCategoryCard(context, state.categories[index]);
                } else {
                  return _buildBrandCard(context, state.brands[index]);
                }
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    return _buildCard(
      context: context,
      title: category.title,
      image: category.image,
      onTap: () {
        context.push(
          '${AppRoutes.categories}/products?type=category&id=${category.id}&name=${category.title}',
        );
      },
    );
  }

  Widget _buildBrandCard(BuildContext context, BrandModel brand) {
    return _buildCard(
      context: context,
      title: brand.title,
      image: brand.image,
      onTap: () {
        context.push(
          '${AppRoutes.categories}/products?type=brand&id=${brand.id}&name=${brand.title}',
        );
      },
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    String? image,
    required VoidCallback onTap,
  }) {
    final hasImage = image != null && image.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: hasImage
                ? Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              _centeredText(title),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  )
                : _centeredText(title),
          ),
        ),
      ),
    );
  }

  Widget _centeredText(String title) {
    return Center(
      child: Text(
        title,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
