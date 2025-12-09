import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coincap_list/src/core/utils/color_utils.dart';
import 'package:coincap_list/src/features/coincap/data/coincap_assets_repository.dart';
import 'package:coincap_list/src/features/coincap/presentation/coincap_assets/widgets/coincap_asset_list_tile.dart';
import 'package:coincap_list/src/features/coincap/presentation/coincap_assets/widgets/coincap_asset_list_tile_error.dart';
import 'package:coincap_list/src/features/coincap/presentation/coincap_assets/widgets/coincap_asset_list_tile_shimmer.dart';

class AssetsSearchScreen extends ConsumerWidget {
  const AssetsSearchScreen({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AssetsSearchScreen());
  }

  static const pageSize = 15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(fetchAssetsProvider);
                try {
                  await ref.read(
                    fetchAssetsProvider(
                      queryData: (page: 1, pageSize: pageSize),
                    ).future,
                  );
                } catch (_) {}
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final page = index ~/ pageSize + 1;
                  final indexInPage = index % pageSize;
                  final responseAsync = ref.watch(
                    fetchAssetsProvider(
                      queryData: (page: page, pageSize: pageSize),
                    ),
                  );

                  return responseAsync.when(
                    error: (err, stack) => AssetListTileError(
                      page: page,
                      pageSize: pageSize,
                      indexInPage: indexInPage,
                      error: err.toString(),
                      isLoading: responseAsync.isLoading,
                    ),
                    loading: () => const AssetListTileShimmer(),
                    data: (response) {
                      if (indexInPage >= response.data.length) {
                        return null;
                      }
                      final asset = response.data[indexInPage];

                      return AssetListTile(
                        asset: asset,
                        color: ColorUtils.fromAssetHash(asset),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
