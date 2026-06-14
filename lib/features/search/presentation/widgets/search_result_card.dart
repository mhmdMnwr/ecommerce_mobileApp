import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/product_model.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// A horizontal product card for search result lists.
class SearchResultCard extends StatelessWidget {
  final ProductModel product;
  final String currency;

  const SearchResultCard({
    super.key,
    required this.product,
    required this.currency,
  });

  String get _brandName {
    if (product.brand != null && product.brand!['title'] != null) {
      return product.brand!['title'] as String;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.product, extra: product),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildImage(),
            SizedBox(width: 14.w),
            Expanded(child: _buildInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 90.w,
      height: 90.w,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: product.image.isNotEmpty
              ? Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => _placeholder(),
                )
              : _placeholder(),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Brand
        if (_brandName.isNotEmpty)
          Text(
            _brandName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        SizedBox(height: 2.h),

        // Title
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
        ),
        SizedBox(height: 4.h),

        // Units info
        if (product.units != null)
          Builder(builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Text(
              l10n.boxContainsUnits(product.units!),
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textHint,
              ),
            );
          }),
        SizedBox(height: 8.h),

        // Price row with add button
        Row(
          children: [
            Expanded(
              child: Text(
                '${product.price.toInt()} $currency',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.add,
                size: 18.r,
                color: AppColors.background,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 28.r,
        color: AppColors.textSecondary,
      ),
    );
  }
}
