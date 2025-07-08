import 'dart:async';
import 'package:flutter/widgets.dart';

/// Utility functions for board operations
class BoardUtils {
  /// Calculates the position of an item within a list
  static Offset? calculateItemPosition(
    BuildContext? context,
    int itemIndex,
    List<double> itemHeights,
  ) {
    if (context == null) return null;
    
    try {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      
      double yOffset = 0;
      for (int i = 0; i < itemIndex && i < itemHeights.length; i++) {
        yOffset += itemHeights[i];
      }
      
      return Offset(position.dx, position.dy + yOffset);
    } catch (e) {
      debugPrint('Error calculating item position: $e');
      return null;
    }
  }
  
  /// Calculates the size of a widget
  static Size? calculateWidgetSize(BuildContext? context) {
    if (context == null) return null;
    
    try {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      return renderBox.size;
    } catch (e) {
      debugPrint('Error calculating widget size: $e');
      return null;
    }
  }
  
  /// Checks if a point is within a rectangle
  static bool isPointInRect(Offset point, Offset rectPosition, Size rectSize) {
    return point.dx >= rectPosition.dx &&
           point.dx <= rectPosition.dx + rectSize.width &&
           point.dy >= rectPosition.dy &&
           point.dy <= rectPosition.dy + rectSize.height;
  }
  
  /// Finds the closest item index to a given position
  static int findClosestItemIndex(
    Offset position,
    List<Offset> itemPositions,
    List<Size> itemSizes,
  ) {
    if (itemPositions.isEmpty) return 0;
    
    double minDistance = double.infinity;
    int closestIndex = 0;
    
    for (int i = 0; i < itemPositions.length; i++) {
      final itemCenter = Offset(
        itemPositions[i].dx + itemSizes[i].width / 2,
        itemPositions[i].dy + itemSizes[i].height / 2,
      );
      
      final distance = (position - itemCenter).distance;
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }
    
    return closestIndex;
  }
  
  /// Safely executes a function with error handling
  static T? safeExecute<T>(T Function() function, {String? debugMessage}) {
    try {
      return function();
    } catch (e) {
      if (debugMessage != null) {
        debugPrint('$debugMessage: $e');
      }
      return null;
    }
  }
  
  /// Debounces a function call
  static void debounce(
    VoidCallback function,
    Duration delay, {
    required String key,
  }) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, function);
  }
  
  static final Map<String, Timer> _debounceTimers = {};
  
  /// Clears all debounce timers
  static void clearDebounceTimers() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
  }
}