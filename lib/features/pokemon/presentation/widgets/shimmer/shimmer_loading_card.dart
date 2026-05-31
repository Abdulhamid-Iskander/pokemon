import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'shimmer_container.dart';

class ShimmerLoadingCard extends StatelessWidget {
  const ShimmerLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(12),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ShimmerContainer(width: 80, height: 80, borderRadius: 40),
          ),
          SizedBox(height: 12),
          ShimmerContainer(width: 60, height: 10),
          SizedBox(height: 6),
          ShimmerContainer(width: 100, height: 14),
          SizedBox(height: 8),
          Row(
            children: [
              ShimmerContainer(width: 45, height: 16, borderRadius: 4),
              SizedBox(width: 6),
              ShimmerContainer(width: 45, height: 16, borderRadius: 4),
            ],
          ),
          SizedBox(height: 8),
          ShimmerContainer(width: 70, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}
