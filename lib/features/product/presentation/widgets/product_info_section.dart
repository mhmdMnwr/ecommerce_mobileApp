import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/weight_selector.dart';
import '../../../home/data/models/product_model.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Product info section: badges, title, price, details, and quantity.
class ProductInfoSection extends StatelessWidget {
  final ProductModel product;
  final String currency;
  final AppLocalizations l10n;
  final int boxes;
  final int units;
  final double weight;
  final ValueChanged<int> onBoxChanged;
  final ValueChanged<int> onUnitChanged;
  final ValueChanged<double> onWeightChanged;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.currency,
    required this.l10n,
    required this.boxes,
    required this.units,
    required this.weight,
    required this.onBoxChanged,
    required this.onUnitChanged,
    required this.onWeightChanged,
  });

  String get _brandName {
    if (product.brand != null && product.brand!['title'] != null) {
      return product.brand!['title'] as String;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      transform: Matrix4.translationValues(0, -24.h, 0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBadges(),
            if (_brandName.isNotEmpty ||
                (product.state?.isNotEmpty ?? false))
              SizedBox(height: 14.h),
            _buildTitle(),
            SizedBox(height: 16.h),
            _buildPrice(),
            SizedBox(height: 24.h),
            _buildDetails(),
            SizedBox(height: 20.h),
            _buildQuantity(),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges() {
    final badges = <Widget>[];
    if (_brandName.isNotEmpty) badges.add(_badge(_brandName, AppColors.primary, AppColors.primary.withAlpha(15)));
    if (product.state != null && product.state!.isNotEmpty) badges.add(_badge(product.state!, AppColors.success, AppColors.success.withAlpha(15)));
    if (badges.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8.w, runSpacing: 6.h, children: badges);
  }

  Widget _badge(String text, Color color, Color bg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: color.withAlpha(40), width: 1)),
      child: Text(text, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.2)),
    );
  }

  Widget _buildTitle() {
    return Text(
      product.title,
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.4,
      ),
    );
  }

  Widget _buildPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(product.price.toStringAsFixed(2), style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: -1)),
        SizedBox(width: 6.w),
        Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Text(product.isWeighted ? '$currency/${l10n.kg}' : currency, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.primary.withAlpha(180))),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    if (product.units == null || product.isWeighted) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.fieldBorder.withAlpha(80), width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 18.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 14.w),
          Text(
            l10n.boxContainsUnits(product.units!),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.addToCart,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 14.h),
        if (product.isWeighted)
          WeightSelector(
            title: l10n.kg, // Wait, does l10n have 'kg' or something similar? I will add it to localization.
            value: weight,
            onChanged: onWeightChanged,
          )
        else
          Row(
            children: [
              Expanded(
                child: QuantitySelector(
                  title: l10n.boxes,
                  value: boxes,
                  onChanged: onBoxChanged,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: QuantitySelector(
                  title: l10n.units,
                  value: units,
                  onChanged: onUnitChanged,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
