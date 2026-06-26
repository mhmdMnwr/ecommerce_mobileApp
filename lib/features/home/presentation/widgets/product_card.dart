import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/product_model.dart';

/// Single product card used in the horizontal products row.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String currency;

  const ProductCard({
    super.key,
    required this.product,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.product, extra: product),
      child: Container(
        width: 160.w,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with subtle background
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: product.image.isNotEmpty
                          ? Image.network(
                              product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.image_not_supported_outlined,
                                size: 36.r,
                                color: AppColors.textSecondary,
                              ),
                            )
                          : Icon(
                              Icons.image_not_supported_outlined,
                              size: 36.r,
                              color: AppColors.textSecondary,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Title
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8.h),

            // Price + add button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '${product.price.toStringAsFixed(2)} $currency',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withAlpha(80),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 16.r,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
