import 'package:flutter/material.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/services/product_catalog_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../widgets/adaptive_image.dart';
import '../cart/cart_page.dart';
import 'controllers/product_customization_controller.dart';
import 'widgets/animated_cart_badge.dart';
import 'widgets/flying_cart_bubble.dart';
import 'widgets/product_addons_sheet.dart';
import 'widgets/product_info_item.dart';
import 'widgets/product_price_section.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/selected_addons_preview.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  final cart = CartService.instance;
  final productCatalog = ProductCatalogService.instance;

  final GlobalKey cartKey = GlobalKey();
  final GlobalKey buttonKey = GlobalKey();

  bool showBubble = false;
  Offset bubbleStart = Offset.zero;
  Offset bubbleEnd = Offset.zero;

  late final ProductCustomizationController controller;
  late final AnimationController bubbleController;
  late final AnimationController cartBounceController;
  late final Animation<double> bubbleAnimation;
  late final Animation<double> cartScaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = ProductCustomizationController(widget.product);
    cart.addListener(_refresh);
    productCatalog.addListener(_refresh);

    bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    );

    cartBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    bubbleAnimation = CurvedAnimation(
      parent: bubbleController,
      curve: Curves.easeInOutCubic,
    );

    cartScaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: cartBounceController, curve: Curves.easeOut),
        );
  }

  @override
  void dispose() {
    cart.removeListener(_refresh);
    productCatalog.removeListener(_refresh);
    controller.dispose();
    bubbleController.dispose();
    cartBounceController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _showAddOnsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ProductAddOnsSheet(controller: controller);
      },
    );
  }

  void addToCart() {
    if (!productCatalog.canOrder(widget.product)) {
      _showProductMessage("${widget.product.name} is currently unavailable.");
      return;
    }

    _prepareBubblePosition();

    final added = cart.addToCart(
      controller.cartProduct,
      quantity: controller.quantity,
    );
    if (!added) {
      _showProductMessage("${widget.product.name} is currently unavailable.");
      return;
    }

    setState(() => showBubble = true);
    controller.resetAfterCart();

    bubbleController.forward(from: 0).then((_) {
      if (!mounted) return;

      setState(() => showBubble = false);
      cartBounceController.forward(from: 0);
    });

    _showProductMessage("${widget.product.name} added to cart");
  }

  void _showProductMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.darkEspresso,
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 88),
          duration: const Duration(milliseconds: 1400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
  }

  void _prepareBubblePosition() {
    final buttonContext = buttonKey.currentContext;
    final cartContext = cartKey.currentContext;

    if (buttonContext == null || cartContext == null) return;

    final buttonBox = buttonContext.findRenderObject() as RenderBox;
    final cartBox = cartContext.findRenderObject() as RenderBox;

    final buttonPosition = buttonBox.localToGlobal(Offset.zero);
    final cartPosition = cartBox.localToGlobal(Offset.zero);

    bubbleStart = Offset(
      buttonPosition.dx + buttonBox.size.width / 2 - 14,
      buttonPosition.dy + buttonBox.size.height / 2 - 14,
    );

    bubbleEnd = Offset(
      cartPosition.dx + cartBox.size.width / 2 - 14,
      cartPosition.dy + cartBox.size.height / 2 - 14,
    );
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(22, isWide ? 20 : 8, 22, 24),
              child: Column(
                children: [
                  if (isWide) _topBar() else _mobileCloseButton(),
                  SizedBox(height: isWide ? 36 : 8),
                  Expanded(child: _productContent()),
                  if (!isWide) _mobileBottomAction(),
                ],
              ),
            ),
          ),
          if (showBubble)
            FlyingCartBubble(
              animation: bubbleAnimation,
              start: bubbleStart,
              end: bubbleEnd,
              label: "+1",
            ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        _CircleIcon(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Details",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        AnimatedCartBadge(
          key: cartKey,
          count: cart.itemCount,
          scaleAnimation: cartScaleAnimation,
          onTap: openCart,
        ),
      ],
    );
  }

  Widget _productContent() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isWide = MediaQuery.sizeOf(context).width >= 900;
        if (isWide) {
          return _webProductContent();
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 360,
                width: double.infinity,
                child: AdaptiveImage(
                  path: widget.product.image,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontFamily: AppFonts.righteous,
                        fontSize: 28,
                        height: 1.12,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    controller.formattedTotalPrice,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkEspresso,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                widget.product.description ??
                    "A Quezel favorite made fresh with satisfying flavors for your cravings.",
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 16,
                  height: 1.65,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 28),
              _mobileAddOnsCard(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _mobileCloseButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close_rounded, size: 34),
      ),
    );
  }

  Widget _mobileAddOnsCard() {
    final addOns = widget.product.addOns;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                color: AppColors.darkEspresso,
              ),
              children: [
                TextSpan(
                  text: "Choice A ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: "(Optional)",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            addOns.isEmpty ? "No add-ons available" : "Select add-ons",
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 15,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 18),
          ...addOns.map((addOn) {
            final selected = controller.isAddOnSelected(addOn);
            return InkWell(
              onTap: () => controller.toggleAddOn(addOn),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.coffeeBrown
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: selected
                              ? AppColors.coffeeBrown
                              : const Color(0xFFC9C9C9),
                          width: 2.4,
                        ),
                      ),
                      child: selected
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 22,
                            )
                          : null,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        addOn.name,
                        style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 18,
                          color: AppColors.darkEspresso,
                        ),
                      ),
                    ),
                    Text(
                      "+ ${addOn.price}",
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _webProductContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1380),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  color: AppColors.parchment,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AdaptiveImage(
                  path: widget.product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(48, 40, 48, 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _productTitleRow(),
                      const SizedBox(height: 12),
                      if (widget.product.savings != null) _savingsBadge(),
                      const SizedBox(height: 16),
                      ProductPriceSection(
                        price: controller.formattedTotalPrice,
                        hasAddOns: widget.product.addOns.isNotEmpty,
                        selectedAddOnsCount: controller.selectedAddOns.length,
                        onAddOnsTap: _showAddOnsSheet,
                      ),
                      const SizedBox(height: 26),
                      _infoRow(),
                      const SizedBox(height: 34),
                      _description(),
                      const SizedBox(height: 24),
                      SelectedAddOnsPreview(
                        selectedAddOns: controller.selectedAddOns,
                      ),
                      if (controller.selectedAddOns.isNotEmpty)
                        const SizedBox(height: 20),
                      const SizedBox(height: 34),
                      _bottomAction(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.product.name,
            style: const TextStyle(
              fontFamily: AppFonts.righteous,
              fontSize: 30,
              height: 1.1,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
        const _CircleIcon(
          icon: Icons.favorite,
          iconColor: AppColors.coffeeBrown,
        ),
      ],
    );
  }

  Widget _infoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ProductInfoItem(icon: Icons.star_rounded, text: "4.9"),
        const ProductInfoItem(icon: Icons.timer_outlined, text: "10-15 min"),
        ProductInfoItem(
          icon: widget.product.isCombo
              ? Icons.fastfood_outlined
              : Icons.local_fire_department_outlined,
          text: widget.product.isCombo ? "Combo Meal" : "Fresh Treat",
        ),
      ],
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Description",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.description ??
              "A refreshing Quezel’s favorite made with creamy shaved ice, sweet toppings, and rich flavors made to satisfy your cravings.",
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            height: 1.6,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _savingsBadge() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.softGold.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.softGold.withValues(alpha: 0.55)),
        ),
        child: Text(
          widget.product.savings!,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.coffeeBrown,
          ),
        ),
      ),
    );
  }

  Widget _bottomAction() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final available = productCatalog.canOrder(widget.product);
        return Row(
          children: [
            QuantitySelector(
              quantity: controller.quantity,
              onDecrease: available ? controller.decreaseQuantity : null,
              onIncrease: available ? controller.increaseQuantity : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              key: buttonKey,
              child: ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: available
                      ? AppColors.coffeeBrown
                      : AppColors.mutedForeground,
                  foregroundColor: AppColors.creamWhite,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  "Add ${controller.formattedTotalPrice}",
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _mobileBottomAction() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final available = productCatalog.canOrder(widget.product);
        return Row(
          children: [
            Container(
              height: 64,
              width: 128,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.darkEspresso, width: 1.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: available ? controller.decreaseQuantity : null,
                    icon: const Icon(Icons.remove_rounded),
                  ),
                  Text(
                    controller.quantity.toString(),
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  IconButton(
                    onPressed: available ? controller.increaseQuantity : null,
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              key: buttonKey,
              child: ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: available
                      ? AppColors.coffeeBrown
                      : AppColors.mutedForeground,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      controller.formattedTotalPrice,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _CircleIcon({
    required this.icon,
    this.iconColor = AppColors.darkEspresso,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 52,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
