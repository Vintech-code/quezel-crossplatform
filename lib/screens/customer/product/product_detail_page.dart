import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/cart_service.dart';
import '../../../models/product.dart';
import '../cart/cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int qty = 1;

  void addToCart() {
    CartService.instance.addToCart(widget.product, quantity: qty);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
          child: Column(
            children: [
              _detailTopBar(context),
              const SizedBox(height: 22),
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
                  Container(
                    height: 58,
                    width: 58,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: AppColors.coffeeBrown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "From: ${widget.product.price}",
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItem(icon: Icons.star_rounded, text: "4.9"),
                  _InfoItem(icon: Icons.timer_outlined, text: "10-15 min"),
                  _InfoItem(
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
              const Spacer(),
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (qty > 1) {
                        setState(() => qty--);
                      }
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
                    onTap: () {
                      setState(() => qty++);
                    },
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coffeeBrown,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTopBar(BuildContext context) {
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
        const _CircleIcon(icon: Icons.share_outlined),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.coffeeBrown),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 13,
            fontWeight: FontWeight.w600,
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
  final VoidCallback? onTap;

  const _CircleIcon({
    required this.icon,
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
        child: Icon(icon),
      ),
    );
  }
}