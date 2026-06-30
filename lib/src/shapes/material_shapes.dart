import 'dart:math' as math;
import 'package:flutter/painting.dart';

/// All 35 Material 3 Expressive shape definitions.
///
/// Each shape is defined as a list of normalized points (0..1 range)
/// that can be interpolated for shape morphing.
class MaterialShapes {
  MaterialShapes._(); 

  static List<Offset> get circle => _polygon(32, 0);
  static List<Offset> get square => _roundedRect(0.15);
  static List<Offset> get pill => _pill();
  static List<Offset> get diamond => _polygon(4, -math.pi / 4);
  static List<Offset> get triangle => _polygon(3, -math.pi / 2);
  static List<Offset> get pentagon => _polygon(5, -math.pi / 2);
  static List<Offset> get arch => _arch();
  static List<Offset> get arrow => _arrow();
  static List<Offset> get heart => _heart();
  static List<Offset> get flower => _flower(5);
  static List<Offset> get clover4Leaf => _clover(4);
  static List<Offset> get clover8Leaf => _clover(8);
  static List<Offset> get cookie4Sided => _cookie(4);
  static List<Offset> get cookie6Sided => _cookie(6);
  static List<Offset> get cookie7Sided => _cookie(7);
  static List<Offset> get cookie9Sided => _cookie(9);
  static List<Offset> get cookie12Sided => _cookie(12);
  static List<Offset> get boom => _star(8, 0.4);
  static List<Offset> get softBoom => _star(8, 0.6);
  static List<Offset> get burst => _star(12, 0.35);
  static List<Offset> get softBurst => _star(12, 0.55);
  static List<Offset> get sunny => _star(10, 0.7);
  static List<Offset> get verySunny => _star(16, 0.75);
  static List<Offset> get fan => _fan();
  static List<Offset> get gem => _gem();
  static List<Offset> get ghostish => _ghostish();
  static List<Offset> get bun => _bun();
  static List<Offset> get oval => _oval();
  static List<Offset> get puffy => _puffy(4);
  static List<Offset> get puffyDiamond => _puffyDiamond();
  static List<Offset> get semiCircle => _semiCircle();
  static List<Offset> get slanted => _slanted();
  static List<Offset> get pixelCircle => _pixelCircle();
  static List<Offset> get pixelTriangle => _pixelTriangle();
  static List<Offset> get clamShell => _clamShell();

  /// Get shape by name.
  static List<Offset> byName(String name) {
    switch (name) {
      case 'circle':
        return circle;
      case 'square':
        return square;
      case 'pill':
        return pill;
      case 'diamond':
        return diamond;
      case 'triangle':
        return triangle;
      case 'pentagon':
        return pentagon;
      case 'arch':
        return arch;
      case 'arrow':
        return arrow;
      case 'heart':
        return heart;
      case 'flower':
        return flower;
      case 'clover4Leaf':
        return clover4Leaf;
      case 'clover8Leaf':
        return clover8Leaf;
      case 'cookie4Sided':
        return cookie4Sided;
      case 'cookie6Sided':
        return cookie6Sided;
      case 'cookie7Sided':
        return cookie7Sided;
      case 'cookie9Sided':
        return cookie9Sided;
      case 'cookie12Sided':
        return cookie12Sided;
      case 'boom':
        return boom;
      case 'softBoom':
        return softBoom;
      case 'burst':
        return burst;
      case 'softBurst':
        return softBurst;
      case 'sunny':
        return sunny;
      case 'verySunny':
        return verySunny;
      case 'fan':
        return fan;
      case 'gem':
        return gem;
      case 'ghostish':
        return ghostish;
      case 'bun':
        return bun;
      case 'oval':
        return oval;
      case 'puffy':
        return puffy;
      case 'puffyDiamond':
        return puffyDiamond;
      case 'semiCircle':
        return semiCircle;
      case 'slanted':
        return slanted;
      case 'pixelCircle':
        return pixelCircle;
      case 'pixelTriangle':
        return pixelTriangle;
      case 'clamShell':
        return clamShell;
      default:
        return circle;
    }
  }

  /// All shape names.
  static const List<String> allNames = [
    'circle',
    'square',
    'pill',
    'diamond',
    'triangle',
    'pentagon',
    'arch',
    'arrow',
    'heart',
    'flower',
    'clover4Leaf',
    'clover8Leaf',
    'cookie4Sided',
    'cookie6Sided',
    'cookie7Sided',
    'cookie9Sided',
    'cookie12Sided',
    'boom',
    'softBoom',
    'burst',
    'softBurst',
    'sunny',
    'verySunny',
    'fan',
    'gem',
    'ghostish',
    'bun',
    'oval',
    'puffy',
    'puffyDiamond',
    'semiCircle',
    'slanted',
    'pixelCircle',
    'pixelTriangle',
    'clamShell',
  ];

  // --- Shape generators ---

  static List<Offset> _polygon(int sides, double startAngle) {
    const count = 32;
    final points = <Offset>[];
    for (int i = 0; i < count; i++) {
      final t = i / count;
      final segF = t * sides;
      final seg = segF.floor();
      final localT = segF - seg;
      final a1 = startAngle + (seg / sides) * 2 * math.pi;
      final a2 = startAngle + ((seg + 1) / sides) * 2 * math.pi;
      final x = 0.5 + 0.45 * math.cos(a1 + (a2 - a1) * localT);
      final y = 0.5 + 0.45 * math.sin(a1 + (a2 - a1) * localT);
      points.add(Offset(x, y));
    }
    return points;
  }

  static List<Offset> _roundedRect(double r) {
    const count = 32;
    final points = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final cos = math.cos(angle);
      final sin = math.sin(angle);
      final maxDist = 1.0 / math.max(cos.abs(), sin.abs());
      final dist = math.min(0.45, 0.45 * maxDist);
      final rawX = 0.5 + dist * cos;
      final rawY = 0.5 + dist * sin;
      // Smooth corners
      final cx = rawX.clamp(0.05 + r, 0.95 - r);
      final cy = rawY.clamp(0.05 + r, 0.95 - r);
      final dx = rawX - cx;
      final dy = rawY - cy;
      final cornerDist = math.sqrt(dx * dx + dy * dy);
      if (cornerDist > r) {
        points.add(Offset(cx + dx / cornerDist * r, cy + dy / cornerDist * r));
      } else {
        points.add(Offset(rawX, rawY));
      }
    }
    return points;
  }

  static List<Offset> _star(int points, double innerRatio) {
    const count = 32;
    final result = <Offset>[];
    final totalPoints = points * 2;
    for (int i = 0; i < count; i++) {
      final t = i / count;
      final segF = t * totalPoints;
      final seg = segF.floor();
      final localT = segF - seg;
      final isOuter = seg % 2 == 0;
      final r1 = isOuter ? 0.45 : 0.45 * innerRatio;
      final r2 = isOuter ? 0.45 * innerRatio : 0.45;
      final a1 = (seg / totalPoints) * 2 * math.pi - math.pi / 2;
      final a2 = ((seg + 1) / totalPoints) * 2 * math.pi - math.pi / 2;
      final r = r1 + (r2 - r1) * localT;
      final a = a1 + (a2 - a1) * localT;
      result.add(Offset(0.5 + r * math.cos(a), 0.5 + r * math.sin(a)));
    }
    return result;
  }

  static List<Offset> _clover(int leaves) {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final r = 0.25 + 0.2 * math.cos(angle * leaves).abs();
      result.add(Offset(0.5 + r * math.cos(angle), 0.5 + r * math.sin(angle)));
    }
    return result;
  }

  static List<Offset> _cookie(int sides) {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final r = 0.38 + 0.07 * math.cos(angle * sides);
      result.add(Offset(0.5 + r * math.cos(angle), 0.5 + r * math.sin(angle)));
    }
    return result;
  }

  static List<Offset> _flower(int petals) {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final r = 0.3 + 0.15 * math.cos(angle * petals);
      result.add(Offset(0.5 + r * math.cos(angle), 0.5 + r * math.sin(angle)));
    }
    return result;
  }

  static List<Offset> _heart() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final t = (i / count) * 2 * math.pi;
      final x = 0.5 + 0.22 * (16 * math.pow(math.sin(t), 3)) / 16;
      final y =
          0.5 -
          0.22 *
              (13 * math.cos(t) -
                  5 * math.cos(2 * t) -
                  2 * math.cos(3 * t) -
                  math.cos(4 * t)) /
              16;
      result.add(Offset(x, y));
    }
    return result;
  }

  static List<Offset> _pill() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final cos = math.cos(angle);
      final sin = math.sin(angle);
      const rx = 0.45;
      const ry = 0.25;
      final r =
          (rx * ry) / math.sqrt(ry * ry * cos * cos + rx * rx * sin * sin);
      result.add(Offset(0.5 + r * cos, 0.5 + r * sin));
    }
    return result;
  }

  static List<Offset> _arch() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final t = i / count;
      if (t < 0.5) {
        // Top semicircle
        final angle = math.pi + t * 2 * math.pi;
        result.add(
          Offset(0.5 + 0.35 * math.cos(angle), 0.35 + 0.35 * math.sin(angle)),
        );
      } else {
        // Bottom rectangle sides
        final lt = (t - 0.5) * 2;
        if (lt < 0.5) {
          result.add(Offset(0.85, 0.35 + lt * 1.1 * 0.55));
        } else {
          result.add(Offset(0.15, 0.35 + (1.0 - lt) * 1.1 * 0.55));
        }
      }
    }
    return result;
  }

  static List<Offset> _arrow() {
    const count = 32;
    final verts = <Offset>[
      const Offset(0.5, 0.1),
      const Offset(0.85, 0.4),
      const Offset(0.65, 0.4),
      const Offset(0.65, 0.9),
      const Offset(0.35, 0.9),
      const Offset(0.35, 0.4),
      const Offset(0.15, 0.4),
    ];
    return _interpolatePolygon(verts, count);
  }

  static List<Offset> _fan() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final t = i / count;
      final angle = -math.pi * 0.75 + t * math.pi * 1.5;
      const r = 0.4;
      if (t < 0.75) {
        result.add(
          Offset(0.5 + r * math.cos(angle), 0.55 + r * math.sin(angle)),
        );
      } else {
        // Converge to center bottom
        final lt = (t - 0.75) / 0.25;
        final startX = 0.5 + r * math.cos(math.pi * 0.75);
        final endX = 0.5 + r * math.cos(-math.pi * 0.75);
        result.add(Offset(startX + (endX - startX) * lt, 0.85 - lt * 0.3));
      }
    }
    return result;
  }

  static List<Offset> _gem() {
    const count = 32;
    final verts = <Offset>[
      const Offset(0.5, 0.1),
      const Offset(0.8, 0.35),
      const Offset(0.7, 0.35),
      const Offset(0.5, 0.9),
      const Offset(0.3, 0.35),
      const Offset(0.2, 0.35),
    ];
    return _interpolatePolygon(verts, count);
  }

  static List<Offset> _ghostish() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final t = i / count;
      if (t < 0.5) {
        final angle = math.pi + t * 2 * math.pi;
        result.add(
          Offset(0.5 + 0.3 * math.cos(angle), 0.4 + 0.3 * math.sin(angle)),
        );
      } else {
        final lt = (t - 0.5) * 2;
        final x = 0.8 - lt * 0.6;
        final wiggle = 0.05 * math.sin(lt * 3 * math.pi);
        result.add(Offset(x, 0.7 + wiggle + lt * 0.15));
      }
    }
    return result;
  }

  static List<Offset> _bun() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      const rx = 0.4;
      const ry = 0.32;
      result.add(
        Offset(0.5 + rx * math.cos(angle), 0.5 + ry * math.sin(angle)),
      );
    }
    return result;
  }

  static List<Offset> _oval() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      result.add(
        Offset(0.5 + 0.25 * math.cos(angle), 0.5 + 0.42 * math.sin(angle)),
      );
    }
    return result;
  }

  static List<Offset> _puffy(int lobes) {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final r = 0.35 + 0.1 * math.sin(angle * lobes).abs();
      result.add(Offset(0.5 + r * math.cos(angle), 0.5 + r * math.sin(angle)));
    }
    return result;
  }

  static List<Offset> _puffyDiamond() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi - math.pi / 4;
      final r = 0.35 + 0.1 * math.cos(angle * 4).abs();
      result.add(Offset(0.5 + r * math.cos(angle), 0.5 + r * math.sin(angle)));
    }
    return result;
  }

  static List<Offset> _semiCircle() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final t = i / count;
      if (t < 0.5) {
        final angle = math.pi + t * 2 * math.pi;
        result.add(
          Offset(0.5 + 0.4 * math.cos(angle), 0.5 + 0.4 * math.sin(angle)),
        );
      } else {
        final lt = (t - 0.5) * 2;
        result.add(Offset(0.9 - lt * 0.8, 0.5));
      }
    }
    return result;
  }

  static List<Offset> _slanted() {
    const count = 32;
    final verts = <Offset>[
      const Offset(0.25, 0.1),
      const Offset(0.85, 0.15),
      const Offset(0.75, 0.9),
      const Offset(0.15, 0.85),
    ];
    return _interpolatePolygon(verts, count);
  }

  static List<Offset> _pixelCircle() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      var x = 0.5 + 0.4 * math.cos(angle);
      var y = 0.5 + 0.4 * math.sin(angle);
      // Snap to pixel grid
      x = (x * 8).round() / 8;
      y = (y * 8).round() / 8;
      result.add(Offset(x, y));
    }
    return result;
  }

  static List<Offset> _pixelTriangle() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final t = i / count;
      final angle = -math.pi / 2 + t * 2 * math.pi;
      var x = 0.5 + 0.4 * math.cos(angle);
      var y = 0.5 + 0.35 * math.sin(angle);
      // Quantize
      x = (x * 6).round() / 6;
      y = (y * 6).round() / 6;
      result.add(Offset(x, y));
    }
    return result;
  }

  static List<Offset> _clamShell() {
    const count = 32;
    final result = <Offset>[];
    for (int i = 0; i < count; i++) {
      final t = i / count;
      if (t < 0.6) {
        // Top shell curve
        final angle = math.pi + (t / 0.6) * math.pi;
        final r = 0.4 + 0.05 * math.sin(t / 0.6 * math.pi * 4);
        result.add(
          Offset(0.5 + r * math.cos(angle), 0.45 + r * 0.8 * math.sin(angle)),
        );
      } else {
        // Bottom flat with slight curve
        final lt = (t - 0.6) / 0.4;
        result.add(
          Offset(0.9 - lt * 0.8, 0.75 + 0.05 * math.sin(lt * math.pi)),
        );
      }
    }
    return result;
  }

  /// Interpolate between polygon vertices to get `count` points.
  static List<Offset> _interpolatePolygon(List<Offset> verts, int count) {
    final result = <Offset>[];
    final n = verts.length;
    for (int i = 0; i < count; i++) {
      final t = i / count;
      final segF = t * n;
      final seg = segF.floor() % n;
      final localT = segF - segF.floor();
      final p1 = verts[seg];
      final p2 = verts[(seg + 1) % n];
      result.add(
        Offset(
          p1.dx + (p2.dx - p1.dx) * localT,
          p1.dy + (p2.dy - p1.dy) * localT,
        ),
      );
    }
    return result;
  }
}
