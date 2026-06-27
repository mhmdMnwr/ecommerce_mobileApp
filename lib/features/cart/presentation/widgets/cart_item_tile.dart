import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/icons_helper.dart';
import '../../data/models/cart_item_model.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// A single cart item row matching the design mockup perfectly.
class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final String currency;
  final void Function(int? boxes, int? units) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.currency,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  Future<void> _handleDelete(BuildContext context, AppLocalizations? l10n) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          l10n?.removeItem ?? 'Remove Item',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
        content: Text(
          l10n?.removeItemConfirm ?? 'Are you sure you want to remove this item from your cart?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n?.cancel ?? 'Cancel',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n?.removeItem ?? 'Remove',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 14.sp)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      onRemove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Slidable(
        key: ValueKey(item.productId),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.28, // Increase ratio to account for the margin
          children: [
            CustomSlidableAction(
              onPressed: (ctx) => _handleDelete(context, l10n),
              backgroundColor: Colors.transparent, // Let Scaffold background show through the gap
              foregroundColor: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              child: Container(
                margin: EdgeInsets.only(left: 12.w), // Space between card and button
                decoration: BoxDecoration(
                  color: const Color(0xFFF4D4D6), // Pinkish background for delete
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Image.asset(
                    IconsHelper.delete,
                    width: 32.r,
                    height: 32.r,
                    errorBuilder: (ctx, err, stack) => Icon(Icons.delete_outline_rounded, color: AppColors.textPrimary, size: 24.r),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(12.r),
          clipBehavior: Clip.antiAlias,
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
              SizedBox(width: 10.w),
              Expanded(child: _buildDetails()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 56.r, height: 56.r,
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
          '1 Box = ${item.unitsPerBox} unit',
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
            _CartQtyPill(label: 'Boxes', value: item.boxes, onChanged: (q) => onQuantityChanged(q, null)),
            SizedBox(width: 8.w),
            _CartQtyPill(label: 'Units', value: item.units, onChanged: (q) => onQuantityChanged(null, q)),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                '${item.lineTotal.toStringAsFixed(2)} $currency',
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CartQtyPill extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _CartQtyPill({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_CartQtyPill> createState() => _CartQtyPillState();
}

class _CartQtyPillState extends State<_CartQtyPill> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Clear the field when focused so the user can type fresh
        _controller.clear();
      } else {
        // Sync the controller text to the current widget value when losing focus
        _controller.text = widget.value.toString();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _CartQtyPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only sync from parent when not actively editing (avoids cursor jumps)
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      if (int.tryParse(_controller.text) != widget.value) {
        _controller.text = widget.value.toString();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
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
                if (widget.value > 0) widget.onChanged(widget.value - 1);
              }),
              Container(
                width: 24.w,
                alignment: Alignment.center,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) {
                    final intVal = int.tryParse(val) ?? 0;
                    widget.onChanged(intVal);
                  },
                  onSubmitted: (val) {
                    final intVal = int.tryParse(val) ?? 0;
                    widget.onChanged(intVal);
                  },
                ),
              ),
              _qtyBtn(Icons.add, () => widget.onChanged(widget.value + 1)),
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
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Icon(icon, size: 12.r, color: AppColors.textSecondary),
      ),
    );
  }
}
