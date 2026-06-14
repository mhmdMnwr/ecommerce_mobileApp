import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/category_model.dart';

/// Single category card used in the horizontal categories row.
class CategoryCard extends StatefulWidget {
  final CategoryModel category;

  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _imageFailed = false;

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.category.image.isNotEmpty && !_imageFailed;

    return Container(
      width: 85.w,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {}, // TODO: filter by category
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            child: hasImage
                ? Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: Image.network(
                            widget.category.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) setState(() => _imageFailed = true);
                              });
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.category.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  )
                : _CenteredLabel(text: widget.category.title),
          ),
        ),
      ),
    );
  }
}

/// Fallback: category name centred in the card.
class _CenteredLabel extends StatelessWidget {
  final String text;
  const _CenteredLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
