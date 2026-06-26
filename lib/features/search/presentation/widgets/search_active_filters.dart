import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../cubit/search_state.dart';
import 'search_bar_widgets.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

class SearchActiveFilters extends StatelessWidget {
  final SearchFilters filters;
  final ValueChanged<SearchFilters> onFiltersChanged;
  final AppLocalizations l10n;

  const SearchActiveFilters({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    if (!filters.hasActiveFilters) return const SizedBox.shrink();
    final chips = <Widget>[];

    if (filters.categoryName != null) {
      chips.add(ActiveFilterChip(
        label: filters.categoryName!,
        onRemove: () => onFiltersChanged(filters.copyWith(clearCategory: true)),
      ));
    }
    if (filters.brandTitle != null) {
      chips.add(ActiveFilterChip(
        label: filters.brandTitle!,
        onRemove: () => onFiltersChanged(filters.copyWith(clearBrand: true)),
      ));
    }
    if (filters.minPrice != null || filters.maxPrice != null) {
      chips.add(ActiveFilterChip(
        label: _priceLabel(l10n),
        onRemove: () => onFiltersChanged(filters.copyWith(clearPrice: true)),
      ));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        height: 36.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (ctx, i) => SizedBox(width: 8.w),
          itemBuilder: (ctx, i) => chips[i],
        ),
      ),
    );
  }

  String _priceLabel(AppLocalizations l10n) {
    final c = l10n.currency;
    if (filters.minPrice != null && filters.maxPrice != null) {
      return '${filters.minPrice!.toStringAsFixed(2)} – ${filters.maxPrice!.toStringAsFixed(2)} $c';
    }
    if (filters.minPrice != null) return '≥ ${filters.minPrice!.toStringAsFixed(2)} $c';
    return '≤ ${filters.maxPrice!.toStringAsFixed(2)} $c';
  }
}
