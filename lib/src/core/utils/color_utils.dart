import 'dart:ui';

abstract final class ColorUtils {
  static Color fromAssetHash(Object asset) {
    return Color(
      int.parse(
        '24${asset.hashCode.toRadixString(16).padRight(6, '0').substring(0, 6)}',
        radix: 16,
      ),
    );
  }
}
