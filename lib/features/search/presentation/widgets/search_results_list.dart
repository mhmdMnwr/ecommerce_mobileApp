import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/search_state.dart';
import '../widgets/search_result_card.dart';

class SearchResultsList extends StatelessWidget {
  final SearchLoaded state;
  final String currency;
  final ScrollController scrollCtrl;

  const SearchResultsList({
    super.key,
    required this.state,
    required this.currency,
    required this.scrollCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollCtrl,
      padding: EdgeInsets.all(20.r),
      itemCount: state.products.length + (state.hasMore ? 1 : 0),
      separatorBuilder: (context, index) => SizedBox(height: 14.h),
      itemBuilder: (context, i) {
        if (i >= state.products.length) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          );
        }
        return SearchResultCard(
          product: state.products[i],
          currency: currency,
        );
      },
    );
  }
}
