import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../home/data/models/category_model.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_bar_widgets.dart';
import '../widgets/search_filters_sheet.dart';
import '../widgets/search_results_list.dart';
import '../widgets/search_states.dart';
import '../widgets/search_active_filters.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/utils/auth_message_translator.dart';

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
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<SearchCubit>().loadMore();
    }
  }

  void _runSearch() {
    context.read<SearchCubit>().search(_searchCtrl.text.trim(), filters: _filters);
  }

  void _openFilters(List<CategoryModel> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
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
            SearchActiveFilters(
              filters: _filters,
              l10n: l10n,
              onFiltersChanged: (f) {
                setState(() => _filters = f);
                _runSearch();
              },
            ),
            Expanded(child: _buildBody(l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(AppLocalizations l10n) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cats = state is SearchInitial ? state.categories : (state is SearchLoaded ? state.categories : <CategoryModel>[]);
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
          child: Row(children: [
            if (Navigator.canPop(context)) ...[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18.r,
                  color: AppColors.textPrimary,
                ),
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

  Widget _buildBody(AppLocalizations l10n) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) return SearchEmptyState(label: l10n.search);
        if (state is SearchLoading) return const Center(child: AppLoadingIndicator());
        if (state is SearchError) return SearchErrorState(message: translateAuthMessage(context, state.message), onRetry: _runSearch);
        if (state is SearchLoaded) {
          return state.products.isEmpty
              ? const SearchNoResults()
              : SearchResultsList(state: state, currency: l10n.currency, scrollCtrl: _scrollCtrl);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
