import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Reusable weight selector card with title, +/- buttons and decimal value input.
class WeightSelector extends StatefulWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  const WeightSelector({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  State<WeightSelector> createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value > 0 ? widget.value.toStringAsFixed(3) : '');
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        if (widget.value == 0) _controller.clear();
      } else {
        if (widget.value > 0) {
          _controller.text = widget.value.toStringAsFixed(3);
        } else {
          _controller.text = '';
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant WeightSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      final textVal = double.tryParse(_controller.text) ?? 0.0;
      if ((textVal - widget.value).abs() > 0.0001) {
        _controller.text = widget.value > 0 ? widget.value.toStringAsFixed(3) : '';
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _increment() => widget.onChanged(widget.value + 0.1);
  void _decrement() {
    if (widget.value >= 0.1) widget.onChanged(widget.value - 0.1);
    else if (widget.value > 0) widget.onChanged(0.0);
  }

  void _showInputDialog(BuildContext context) {
    final TextEditingController dialogController = TextEditingController(
      text: widget.value > 0 ? widget.value.toStringAsFixed(3) : '',
    );
    showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter ${widget.title}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.fieldBorder.withAlpha(100)),
                  ),
                  child: TextField(
                    controller: dialogController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.000',
                      hintStyle: TextStyle(
                        fontSize: 24.sp,
                        color: AppColors.textSecondary.withAlpha(100),
                      ),
                      suffixText: widget.title,
                      suffixStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    onSubmitted: (val) => Navigator.pop(context, val),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, dialogController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((val) {
      if (val != null) {
        double doubleVal = double.tryParse(val) ?? 0.0;
        if (doubleVal > 150.0) {
          doubleVal = 150.0;
        }
        widget.onChanged(doubleVal);
      }
    });
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
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              readOnly: true,
              onTap: () => _showInputDialog(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: widget.value > 0 ? AppColors.primary : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '0.000',
                hintStyle: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.textSecondary.withAlpha(100),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
