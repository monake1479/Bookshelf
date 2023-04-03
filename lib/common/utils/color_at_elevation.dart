import 'package:flutter/material.dart';

extension ColorAtElevation on Color {
  Color withSurfaceTint(
    BuildContext context,
    double elevation,
  ) {
    return ElevationOverlay.applySurfaceTint(
        this, Theme.of(context).colorScheme.surfaceTint, elevation);
  }
}
