import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/floating_circle_button.dart';
import '../../../home/data/models/product_model.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

import '../widgets/product_image_section.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_bottom_bar.dart';

/// Full-screen product detail page with premium UI.
class ProductPage extends StatefulWidget {
  final ProductModel product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  int _boxes = 0;
  int _units = 0;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  ProductModel get product => widget.product;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _handleAddToCart(AppLocalizations l10n) {
    final effectiveQty = _boxes > 0 ? _boxes : 1;
    sl<CartCubit>().addToCart(
      CartItemModel(
        productId: product.id,
        title: product.title,
        image: product.image,
        price: product.price,
        units: product.units ?? 1,
        quantity: effectiveQty,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.addedToCart),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    setState(() {
      _boxes = 0;
      _units = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currency = l10n.currency;
    final hasItems = _boxes > 0 || _units > 0;
    final total = (_boxes * product.price.toDouble()) +
        (_units *
            (product.units != null
                ? product.price.toDouble() / product.units!
                : product.price.toDouble()));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                    child: ProductImageSection(product: product)),
                SliverToBoxAdapter(
                  child: ProductInfoSection(
                    product: product,
                    currency: currency,
                    l10n: l10n,
                    boxes: _boxes,
                    units: _units,
                    onBoxInc: () => setState(() => _boxes++),
                    onBoxDec: () {
                      if (_boxes > 0) setState(() => _boxes--);
                    },
                    onUnitInc: () => setState(() => _units++),
                    onUnitDec: () {
                      if (_units > 0) setState(() => _units--);
                    },
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 16.w,
              child: FloatingCircleButton(
                icon: Icons.arrow_back_ios_new,
                onTap: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              right: 16.w,
              child: FloatingCircleButton(
                icon: Icons.shopping_bag_outlined,
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoutes.cart);
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ProductBottomBar(
                total: total,
                hasItems: hasItems,
                currency: currency,
                l10n: l10n,
                onAddToCart: hasItems ? () => _handleAddToCart(l10n) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
