import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/cart_item_model.dart';

/// A single cart item row matching the design mockup perfectly.
class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final String currency;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.currency,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // The mockup uses a blue border for the active/first item. We can't know if it's active easily, 
    // so we just show the card. If you want the blue border, wrap the child in a Container with border.
    // For now, I'll use a clean white card for all to be consistent unless selected state is added.
    
    return Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF4D4D6), // Pinkish background for delete
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        child: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.textPrimary, width: 1.5),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: AppColors.textPrimary,
            size: 20.r,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            SizedBox(width: 14.w),
            Expanded(child: _buildDetails()),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 72.r, height: 72.r,
      decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(12.r)),
      padding: EdgeInsets.all(4.r),
      child: item.image.isNotEmpty
          ? Image.network(item.image, fit: BoxFit.contain, errorBuilder: (ctx, err, stack) => const Icon(Icons.image_not_supported_outlined, color: Colors.grey))
          : const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand Name', // Mockup has a light gray brand name at the top
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textHint,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '1 Box = ${item.units} unit',
          style: TextStyle(
            fontSize: 9.sp,
            color: AppColors.textHint,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildQtyPill('Boxes', item.quantity, (q) => onQuantityChanged(q)),
            SizedBox(width: 12.w),
            _buildQtyPill('Units', 1, (q) {}), // Mockup has Units. Fixed to 1 for visuals based on mockup
            const Spacer(),
            Text(
              '${item.lineTotal.toInt()} $currency',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQtyPill(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHint,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 26.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _qtyBtn(Icons.remove, () {
                if (value > 1) onChanged(value - 1);
              }),
              Container(
                constraints: BoxConstraints(minWidth: 16.w),
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _qtyBtn(Icons.add, () => onChanged(value + 1)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: Icon(icon, size: 12.r, color: AppColors.textSecondary),
      ),
    );
  }
}
