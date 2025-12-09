import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coincap_list/src/core/env/env.dart';
import 'package:coincap_list/src/core/utils/dio_provider.dart';
import 'package:coincap_list/src/features/coincap/domain/coincap_assets_response.dart';

part 'coincap_assets_repository.g.dart';

typedef AssetsQueryData = ({int page, int pageSize});

class AssetsRepository {
  const AssetsRepository({required this.client, required this.apiKey});
  final Dio client;
  final String apiKey;

  Future<CoinCapResponse> getAssets({
    required int page,
    required int pageSize,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'rest.coincap.io',
      path: 'v3/assets',
      queryParameters: {
        'limit': pageSize.toString(),
        'offset': ((page - 1) * pageSize).toString(),
      },
    );

    log(
      'Fetching assets: page=$page, pageSize=$pageSize',
      name: 'AssetsRepository',
    );

    try {
      final response = await client.getUri(
        uri,
        options: Options(headers: {"Authorization": "Bearer $apiKey"}),
        cancelToken: cancelToken,
      );

      final data = CoinCapResponse.fromJson(response.data);
      log(
        'Response: status=${response.statusCode}, count=${data.data.length}',
        name: 'AssetsRepository',
      );

      return data;
    } catch (e, stack) {
      log(
        'Error fetching assets: $e',
        name: 'AssetsRepository',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}

@riverpod
AssetsRepository assetsRepository(Ref ref) =>
    AssetsRepository(client: ref.watch(dioProvider), apiKey: Env.coincapApiKey);

@riverpod
Future<CoinCapResponse> fetchAssets(
  Ref ref, {
  required AssetsQueryData queryData,
}) async {
  final assetsRepo = ref.watch(assetsRepositoryProvider);
  final cancelToken = CancelToken();
  final link = ref.keepAlive();
  Timer? timer;

  log(
    'keepAlive: page=${queryData.page}',
    name: 'fetchAssetsProvider',
  );

  ref.onDispose(() {
    cancelToken.cancel();
    timer?.cancel();
    log(
      'Disposed: page=${queryData.page}',
      name: 'fetchAssetsProvider',
    );
  });

  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 30), () {
      link.close();
      log(
        'Cache expired: page=${queryData.page}',
        name: 'fetchAssetsProvider',
      );
    });
  });

  ref.onResume(() {
    timer?.cancel();
    log(
      'Resumed: page=${queryData.page}',
      name: 'fetchAssetsProvider',
    );
  });

  return assetsRepo.getAssets(
    page: queryData.page,
    pageSize: queryData.pageSize,
    cancelToken: cancelToken,
  );
}
