import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Extract a dominant/seed color from an image.
///
/// Pure Dart implementation — no platform dependencies.
/// Useful for theming from album art, product photos, wallpapers, etc.
class ColorFromImage {
  ColorFromImage._();

  /// Extract the dominant color from an [ImageProvider].
  ///
  /// Samples pixels and finds the most vibrant/saturated dominant color.
  /// Returns a seed color suitable for `ExpressiveTheme.fromSeed()`.
  static Future<Color> extract(
    ImageProvider provider, {
    Size size = const Size(64, 64),
  }) async {
    final completer = Completer<Color>();
    final stream = provider.resolve(ImageConfiguration.empty);

    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        stream.removeListener(listener);
        _extractFromImage(info.image, size).then(completer.complete);
      },
      onError: (error, stackTrace) {
        stream.removeListener(listener);
        completer.completeError(error, stackTrace);
      },
    );
    stream.addListener(listener);
    return completer.future;
  }

  static Future<Color> _extractFromImage(
    ui.Image image,
    Size targetSize,
  ) async {
    // Resize to small size for faster sampling
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = Rect.fromLTWH(0, 0, targetSize.width, targetSize.height);
    canvas.drawImageRect(image, src, dst, Paint());
    final picture = recorder.endRecording();
    final resized = await picture.toImage(
      targetSize.width.toInt(),
      targetSize.height.toInt(),
    );

    final byteData = await resized.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (byteData == null) return Colors.blue;

    final pixels = byteData.buffer.asUint8List();
    return _findDominantColor(pixels);
  }

  /// Find the most saturated, reasonably bright color from pixel data.
  static Color _findDominantColor(List<int> pixels) {
    // Simple approach: bucket colors by hue, pick the most saturated bucket
    final hueBuckets = List<_ColorBucket>.generate(12, (_) => _ColorBucket());

    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      final a = pixels[i + 3];
      if (a < 128) continue; // skip transparent

      final color = Color.fromARGB(255, r, g, b);
      final hsl = HSLColor.fromColor(color);

      // Skip very dark, very light, or very desaturated pixels
      if (hsl.lightness < 0.1 || hsl.lightness > 0.9) continue;
      if (hsl.saturation < 0.15) continue;

      final bucketIndex = (hsl.hue / 30).floor().clamp(0, 11);
      hueBuckets[bucketIndex].add(hsl);
    }

    // Find bucket with highest combined saturation × count
    _ColorBucket? best;
    double bestScore = 0;
    for (final bucket in hueBuckets) {
      if (bucket.count == 0) continue;
      final score = bucket.avgSaturation * bucket.count;
      if (score > bestScore) {
        bestScore = score;
        best = bucket;
      }
    }

    if (best == null || best.count == 0) return Colors.blue;
    return best.averageColor;
  }
}

class _ColorBucket {
  double _hueSum = 0;
  double _satSum = 0;
  double _lightSum = 0;
  int count = 0;

  void add(HSLColor hsl) {
    _hueSum += hsl.hue;
    _satSum += hsl.saturation;
    _lightSum += hsl.lightness;
    count++;
  }

  double get avgSaturation => count > 0 ? _satSum / count : 0;

  Color get averageColor {
    if (count == 0) return Colors.blue;
    return HSLColor.fromAHSL(
      1.0,
      _hueSum / count,
      (_satSum / count).clamp(0.4, 0.8),
      (_lightSum / count).clamp(0.4, 0.6),
    ).toColor();
  }
}
