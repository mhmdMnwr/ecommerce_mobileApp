import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Reusable quantity selector card with title, +/- buttons and value input.
class QuantitySelector extends StatefulWidget {
  final String title;
  final int value;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
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
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
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

  void _increment() => widget.onChanged(widget.value + 1);
  void _decrement() {
    if (widget.value > 0) widget.onChanged(widget.value - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: widget.value > 0
              ? AppColors.primary.withAlpha(60)
              : AppColors.fieldBorder.withAlpha(100),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roundButton(
                Icons.remove,
                _decrement,
                enabled: widget.value > 0,
              ),
              Container(
                width: 60.w,
                alignment: Alignment.center,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: widget.value > 0 ? AppColors.primary : AppColors.textPrimary,
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
              _roundButton(
                Icons.add,
                _increment,
                isAdd: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton(
    IconData icon,
    VoidCallback onTap, {
    bool isAdd = false,
    bool enabled = true,
  }) {
    final color = isAdd
        ? AppColors.primary
        : (enabled ? AppColors.textSecondary : AppColors.fieldBorder);
    final bg = isAdd
        ? AppColors.primary.withAlpha(15)
        : (enabled ? AppColors.surface : Colors.transparent);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withAlpha(isAdd ? 60 : 40),
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: 16.r, color: color),
      ),
    );
  }
}
