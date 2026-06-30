import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';
import '../tokens/typography_tokens.dart';
import '../tokens/spacing_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/elevation_tokens.dart';
import '../tokens/motion_tokens.dart';
import '../tokens/opacity_tokens.dart';
import '../tokens/state_tokens.dart';
import '../tokens/shape_tokens.dart';

/// The full set of resolved tokens for an expressive theme.
class ExpressiveThemeData {
  const ExpressiveThemeData({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radius,
    required this.elevation,
    required this.motion,
    required this.opacity,
    required this.state,
    required this.shape,
    required this.materialTheme,
    required this.materialDarkTheme,
  });

  final ExpressiveColorTokens colors;
  final ExpressiveTypographyTokens typography;
  final ExpressiveSpacingTokens spacing;
  final ExpressiveRadiusTokens radius;
  final ExpressiveElevationTokens elevation;
  final ExpressiveMotionTokens motion;
  final ExpressiveOpacityTokens opacity;
  final ExpressiveStateTokens state;
  final ExpressiveShapeTokens shape;
  final ThemeData materialTheme;
  final ThemeData materialDarkTheme;
}
