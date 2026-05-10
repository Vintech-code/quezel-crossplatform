import 'package:flutter/material.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../cart/cart_page.dart';
import 'widgets/animated_cart_badge.dart';
import 'widgets/flying_cart_bubble.dart';
import 'widgets/ingredient_expandable_list.dart';
import 'widgets/product_info_item.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  final cart = CartService.instance;

  final GlobalKey cartKey = GlobalKey();
  final GlobalKey buttonKey = GlobalKey();

  int qty = 1;
  bool showBubble = false;

  Offset bubbleStart = Offset.zero;
  Offset bubbleEnd = Offset.zero;

  late final AnimationController bubbleController;
  late final AnimationController cartBounceController;
  late final Animation<double> bubbleAnimation;
  late final Animation<double> cartScaleAnimation;

  @override
  void initState() {
    super.initState();

    cart.addListener(_refresh);

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

    cartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: cartBounceController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    cart.removeListener(_refresh);
    bubbleController.dispose();
    cartBounceController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void addToCart() {
    _prepareBubblePosition();

    final addedQuantity = qty;

    cart.addToCart(widget.product, quantity: addedQuantity);

    setState(() {
      showBubble = true;
      qty = 1;
    });

    bubbleController.forward(from: 0).then((_) {
      if (!mounted) return;

      setState(() => showBubble = false);
      cartBounceController.forward(from: 0);
    });

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
            "${widget.product.name} added to cart",
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
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
              child: Column(
                children: [
                  _topBar(),
                  const SizedBox(height: 22),
                  Expanded(child: _productContent()),
                  _bottomAction(),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 305,
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.creamWhite,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Image.asset(
              widget.product.image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Row(
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
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.price,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: AppColors.coffeeBrown,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.kcal,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.mutedForeground,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProductInfoItem(icon: Icons.star_rounded, text: "4.9"),
              ProductInfoItem(icon: Icons.timer_outlined, text: "10-15 min"),
              ProductInfoItem(
                icon: Icons.local_fire_department_outlined,
                text: "Cool Treat",
              ),
            ],
          ),
          const SizedBox(height: 26),
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
          const Text(
            "A refreshing Quezel’s favorite made with creamy shaved ice, sweet toppings, leche flan, and rich flavors made to cool you down.",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              height: 1.6,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 20),
          IngredientExpandableList(
            ingredients: widget.product.ingredients,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _bottomAction() {
    return Row(
      children: [
        _QtyButton(
          icon: Icons.remove,
          onTap: () {
            if (qty > 1) setState(() => qty--);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            qty.toString().padLeft(2, "0"),
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _QtyButton(
          icon: Icons.add,
          filled: true,
          onTap: () => setState(() => qty++),
        ),
        const SizedBox(width: 20),
        Expanded(
          key: buttonKey,
          child: ElevatedButton(
            onPressed: addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.softGold,
              foregroundColor: AppColors.creamWhite,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text(
              "Add to Cart",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: filled ? AppColors.darkEspresso : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.darkEspresso.withOpacity(0.15),
          ),
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : AppColors.darkEspresso,
        ),
      ),
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
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}