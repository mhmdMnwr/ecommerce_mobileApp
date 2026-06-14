import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/category_model.dart';
import '../cubit/search_state.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Bottom sheet that lets the user pick category, price range.
class SearchFiltersSheet extends StatefulWidget {
  final SearchFilters currentFilters;
  final List<CategoryModel> categories;
  final ValueChanged<SearchFilters> onApply;

  const SearchFiltersSheet({
    super.key,
    required this.currentFilters,
    required this.categories,
    required this.onApply,
  });

  @override
  State<SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<SearchFiltersSheet> {
  late String? _categoryId;
  late String? _categoryName;
  late TextEditingController _minCtrl;
  late TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.currentFilters.categoryId;
    _categoryName = widget.currentFilters.categoryName;
    _minCtrl = TextEditingController(
      text: widget.currentFilters.minPrice?.toStringAsFixed(0) ?? '',
    );
    _maxCtrl = TextEditingController(
      text: widget.currentFilters.maxPrice?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    final minP =
        _minCtrl.text.isNotEmpty ? double.tryParse(_minCtrl.text) : null;
    final maxP =
        _maxCtrl.text.isNotEmpty ? double.tryParse(_maxCtrl.text) : null;
    widget.onApply(SearchFilters(
      categoryId: _categoryId,
      categoryName: _categoryName,
      minPrice: minP,
      maxPrice: maxP,
    ));
    Navigator.pop(context);
  }

  void _clear() {
    widget.onApply(const SearchFilters());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handle(),
          SizedBox(height: 20.h),
          _titleRow(l10n),
          SizedBox(height: 20.h),
          if (widget.categories.isNotEmpty) ...[
            _label(l10n.categories),
            SizedBox(height: 8.h),
            _categoryChips(),
            SizedBox(height: 20.h),
          ],
          _label('${l10n.currency} — Price Range'),
          SizedBox(height: 8.h),
          _priceRow(),
          SizedBox(height: 24.h),
          _applyButton(),
        ],
      ),
    );
  }

  Widget _handle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.fieldBorder,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _titleRow(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l10n.search,
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        GestureDetector(
          onTap: _clear,
          child: Text('Reset',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error)),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary));
  }

  Widget _categoryChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: widget.categories.map((cat) {
        final sel = _categoryId == cat.id;
        return ChoiceChip(
          label: Text(cat.title),
          selected: sel,
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          labelStyle: TextStyle(
            color: sel ? AppColors.background : AppColors.textPrimary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          onSelected: (v) => setState(() {
            _categoryId = v ? cat.id : null;
            _categoryName = v ? cat.title : null;
          }),
        );
      }).toList(),
    );
  }

  Widget _priceRow() {
    return Row(
      children: [
        Expanded(child: _priceField(_minCtrl, 'Min')),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text('—',
              style:
                  TextStyle(fontSize: 18.sp, color: AppColors.textSecondary)),
        ),
        Expanded(child: _priceField(_maxCtrl, 'Max')),
      ],
    );
  }

  Widget _priceField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _applyButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: _apply,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle:
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        child: const Text('Apply'),
      ),
    );
  }
}
