import 'package:flutter/material.dart';
import 'shimmer_loading_card.dart';

class ShimmerLoadingGrid extends StatelessWidget {
  final int count;
  const ShimmerLoadingGrid({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => const ShimmerLoadingCard(),
        childCount: count,
      ),
    );
  }
}
