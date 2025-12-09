import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coincap_list/src/core/constants/app_sizes.dart';
import 'package:coincap_list/src/features/coincap/data/coincap_assets_repository.dart';

class AssetListTileError extends ConsumerWidget {
  const AssetListTileError({
    super.key,
    required this.page,
    required this.pageSize,
    required this.indexInPage,
    required this.isLoading,
    required this.error,
  });

  final int page;
  final int pageSize;
  final int indexInPage;
  final bool isLoading;
  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return indexInPage == 0
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPadding,
              vertical: AppSizes.verticalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    error,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSizes.gapWidth),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref.invalidate(
                            fetchAssetsProvider(
                              queryData: (page: page, pageSize: pageSize),
                            ),
                          );
                          return ref.read(
                            fetchAssetsProvider(
                              queryData: (page: page, pageSize: pageSize),
                            ).future,
                          );
                        },
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
