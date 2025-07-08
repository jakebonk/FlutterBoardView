import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'board_controller.dart';

// Export the modern controller for easy access
export 'board_controller.dart';

/// Legacy BoardViewController for backward compatibility
/// Consider using the new BoardController instead
@Deprecated('Use BoardController instead')
class BoardViewController {
  final BoardController _controller = BoardController();
  
  BoardViewController();

  /// Gets the underlying modern controller
  BoardController get controller => _controller;

  /// Animates to a specific list index
  /// 
  /// [index] - The index of the list to animate to
  /// [duration] - Animation duration (defaults to 400ms)
  /// [curve] - Animation curve (defaults to Curves.ease)
  Future<void> animateTo(int index, {
    Duration? duration,
    Curve? curve,
  }) async {
    await _controller.animateToList(
      index,
      duration: duration ?? const Duration(milliseconds: 400),
      curve: curve ?? Curves.ease,
    );
  }
  
  /// Disposes the controller
  void dispose() {
    _controller.dispose();
  }
}