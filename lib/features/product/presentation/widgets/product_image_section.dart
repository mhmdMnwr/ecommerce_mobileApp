import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/product_model.dart';

/// Hero image section at the top of the product detail page.
class ProductImageSection extends StatelessWidget {
  final ProductModel product;

  const ProductImageSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 380.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.surface, AppColors.surface, AppColors.background],
          stops: const [0.0, 0.85, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(40.w, 50.h, 40.w, 20.h),
          child: Hero(
            tag: 'product_${product.id}',
            child: product.image.isNotEmpty
                ? Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => _placeholder(),
                  )
                : _placeholder(),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 56.r,
            color: AppColors.fieldBorder,
          ),
          SizedBox(height: 8.h),
          Text(
            'No image',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
