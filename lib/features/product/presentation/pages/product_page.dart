import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../home/data/models/product_model.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Full-screen product detail page.
class ProductPage extends StatefulWidget {
  final ProductModel product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _boxes = 0;
  int _units = 0;

  ProductModel get product => widget.product;

  String get _brandName {
    if (product.brand != null && product.brand!['title'] != null) {
      return product.brand!['title'] as String;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currency = l10n.currency;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(child: _buildBody(currency, l10n)),
            _buildBottomBar(currency, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18.r,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 20.r,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(String currency, AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with gradient background
          Container(
            width: double.infinity,
            height: 300.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: product.image.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, stack) => _placeholder(),
                      ),
                    )
                  : _placeholder(),
            ),
          ),

          SizedBox(height: 24.h),

          // Product info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand badge
                if (_brandName.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      _brandName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                // Title
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 12.h),

                // Price
                Text(
                  '${product.price.toInt()} $currency',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 16.h),

                // Divider
                Container(
                  height: 1,
                  color: AppColors.fieldBorder.withAlpha(80),
                ),
                SizedBox(height: 16.h),

                // Units info
                if (product.units != null) ...[
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 20.r,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        l10n.boxContainsUnits(product.units!),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(String currency, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          QuantitySelector(
            title: l10n.boxes,
            value: _boxes,
            onIncrement: () => setState(() => _boxes++),
            onDecrement: () {
              if (_boxes > 0) setState(() => _boxes--);
            },
          ),
          SizedBox(width: 16.w),
          QuantitySelector(
            title: l10n.units,
            value: _units,
            onIncrement: () => setState(() => _units++),
            onDecrement: () {
              if (_units > 0) setState(() => _units--);
            },
          ),
          const Spacer(),
          SizedBox(
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                // TODO: add to cart logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                elevation: 0,
              ),
              child: Text(
                l10n.addToCart,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 56.r,
        color: AppColors.textSecondary,
      ),
    );
  }
}
