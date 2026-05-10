import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class FlyingCartBubble extends StatelessWidget {
  final Animation<double> animation;
  final Offset start;
  final Offset end;
  final String label;

  const FlyingCartBubble({
    super.key,
    required this.animation,
    required this.start,
    required this.end,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final position = Offset.lerp(start, end, animation.value)!;
        final scale = 1.0 - (animation.value * 0.35);

        return Positioned(
          left: position.dx,
          top: position.dy,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: 1 - (animation.value * 0.25),
              child: Container(
                height: 28,
                width: 28,
                decoration: const BoxDecoration(
                  color: AppColors.coffeeBrown,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}