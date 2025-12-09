import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:coincap_list/src/core/constants/app_colors.dart';
import 'package:coincap_list/src/core/constants/app_sizes.dart';

class AssetListTileShimmer extends StatelessWidget {
  const AssetListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPadding,
          vertical: AppSizes.verticalPadding,
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.avatarSize,
              height: AppSizes.avatarSize,
              color: AppColors.shimmerPlaceholder,
            ),
            const SizedBox(width: AppSizes.gapWidth),
            Expanded(
              child: Container(
                width: double.infinity,
                height: AppSizes.shimmerTextHeight,
                color: AppColors.shimmerPlaceholder,
              ),
            ),
            Container(
              width: AppSizes.shimmerTextWidth,
              height: AppSizes.shimmerTextHeight,
              color: AppColors.shimmerPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}
