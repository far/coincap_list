import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:coincap_list/src/core/constants/app_colors.dart';
import 'package:coincap_list/src/core/constants/app_sizes.dart';
import 'package:coincap_list/src/features/coincap/domain/coincap_asset.dart';

class AssetListTile extends StatelessWidget {
  const AssetListTile({super.key, required this.asset, required this.color});

  final Asset asset;
  final Color color;

  static const textStyle = TextStyle(
    height: AppSizes.textHeight,
    letterSpacing: AppSizes.textLetterSpacing,
    fontFamily: 'SFProSemibold',
    fontSize: AppSizes.textFontSize,
    color: AppColors.primaryText,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.horizontalPadding,
        vertical: AppSizes.verticalPadding,
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.avatarSize,
            height: AppSizes.avatarSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSizes.avatarBorderRadius),
            ),
          ),
          const SizedBox(width: AppSizes.gapWidth),
          Expanded(child: Text(asset.symbol, style: textStyle)),
          Text(
            NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(
              double.parse(
                asset.priceUsd.substring(0, asset.priceUsd.indexOf('.') + 3),
              ),
            ),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
