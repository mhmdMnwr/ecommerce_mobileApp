import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/category_model.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_bar_widgets.dart';
import '../widgets/search_filters_sheet.dart';
import '../widgets/search_results_list.dart';
import '../widgets/search_states.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  final SearchFilters? initialFilters;
  final String? pageTitle;

  const SearchPage({super.key, this.initialFilters, this.pageTitle});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late SearchFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters ?? const SearchFilters(sort: 'title');
    context.read<SearchCubit>().loadCategories();
    _runSearch();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<SearchCubit>().loadMore();
    }
  }

  void _runSearch() {
    context
        .read<SearchCubit>()
        .search(_searchCtrl.text.trim(), filters: _filters);
  }

  void _openFilters(List<CategoryModel> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SearchFiltersSheet(
        currentFilters: _filters,
        categories: categories,
        onApply: (f) {
          setState(() => _filters = f);
          _runSearch();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(l10n),
            _buildActiveFilters(l10n),
            Expanded(child: _buildBody(l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(AppLocalizations l10n) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cats = state is SearchInitial
            ? state.categories
            : state is SearchLoaded
                ? state.categories
                : <CategoryModel>[];
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
          child: Row(children: [
            if (Navigator.canPop(context)) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: SearchTextField(
                controller: _searchCtrl,
                hintText: l10n.search,
                onSubmitted: _runSearch,
              ),
            ),
            SizedBox(width: 10.w),
            FilterButton(
              isActive: _filters.hasActiveFilters,
              onTap: () => _openFilters(cats),
            ),
          ]),
        );
      },
    );
  }

  Widget _buildActiveFilters(AppLocalizations l10n) {
    if (!_filters.hasActiveFilters) return const SizedBox.shrink();
    final chips = <Widget>[];

    if (_filters.categoryName != null) {
      chips.add(ActiveFilterChip(
        label: _filters.categoryName!,
        onRemove: () => setState(() {
          _filters = _filters.copyWith(clearCategory: true);
          _runSearch();
        }),
      ));
    }
    if (_filters.brandTitle != null) {
      chips.add(ActiveFilterChip(
        label: _filters.brandTitle!,
        onRemove: () => setState(() {
          _filters = _filters.copyWith(clearBrand: true);
          _runSearch();
        }),
      ));
    }
    if (_filters.minPrice != null || _filters.maxPrice != null) {
      chips.add(ActiveFilterChip(
        label: _priceLabel(l10n),
        onRemove: () => setState(() {
          _filters = _filters.copyWith(clearPrice: true);
          _runSearch();
        }),
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
    if (_filters.minPrice != null && _filters.maxPrice != null) {
      return '${_filters.minPrice!.toInt()} – ${_filters.maxPrice!.toInt()} $c';
    }
    if (_filters.minPrice != null) return '≥ ${_filters.minPrice!.toInt()} $c';
    return '≤ ${_filters.maxPrice!.toInt()} $c';
  }

  Widget _buildBody(AppLocalizations l10n) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return SearchEmptyState(label: l10n.search);
        }
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is SearchError) {
          return SearchErrorState(
              message: state.message, onRetry: _runSearch);
        }
        if (state is SearchLoaded) {
          return state.products.isEmpty
              ? const SearchNoResults()
              : SearchResultsList(
                  state: state,
                  currency: l10n.currency,
                  scrollCtrl: _scrollCtrl,
                );
        }
        return const SizedBox.shrink();
      },
    );
  }

}
