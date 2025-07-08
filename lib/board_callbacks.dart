import 'package:flutter/widgets.dart';

/// Callback function signatures for various board state changes

/// Called when the board scroll position changes
typedef BoardScrollCallback = void Function(double position, double maxExtent);

/// Called when a list becomes visible or hidden
typedef BoardListVisibilityCallback = void Function(int listIndex, bool isVisible);

/// Called when the board starts or stops scrolling
typedef BoardScrollStateCallback = void Function(bool isScrolling);

/// Called when a drag operation starts
typedef BoardDragStartCallback = void Function(int listIndex, int itemIndex);

/// Called when a drag operation ends
typedef BoardDragEndCallback = void Function(int fromListIndex, int fromItemIndex, int toListIndex, int toItemIndex);

/// Called when a drag operation is cancelled
typedef BoardDragCancelCallback = void Function(int listIndex, int itemIndex);

/// Called when an item is moved within the same list
typedef BoardItemReorderCallback = void Function(int listIndex, int fromIndex, int toIndex);

/// Called when an item is moved to a different list
typedef BoardItemMoveCallback = void Function(int fromListIndex, int fromItemIndex, int toListIndex, int toItemIndex);

/// Called when a list is reordered
typedef BoardListReorderCallback = void Function(int fromIndex, int toIndex);

/// Called when a list scroll position changes
typedef BoardListScrollCallback = void Function(int listIndex, double position, double maxExtent);

/// Called when a list starts or stops scrolling
typedef BoardListScrollStateCallback = void Function(int listIndex, bool isScrolling);

/// Called when an item becomes visible or hidden in a list
typedef BoardItemVisibilityCallback = void Function(int listIndex, int itemIndex, bool isVisible);

/// Called when the board layout changes (e.g., orientation, size)
typedef BoardLayoutChangeCallback = void Function(Size boardSize);

/// Called when an error occurs during board operations
typedef BoardErrorCallback = void Function(String error, StackTrace? stackTrace);

/// Called when the board controller is attached or detached
typedef BoardControllerStateCallback = void Function(bool isAttached);

/// Called when animation starts or completes
typedef BoardAnimationCallback = void Function(bool isAnimating);

/// Called when the board enters or exits selection mode
typedef BoardSelectionModeCallback = void Function(bool isSelecting);

/// Called when items are selected or deselected
typedef BoardSelectionCallback = void Function(List<BoardItemSelection> selectedItems);

/// Represents a selected item
class BoardItemSelection {
  final int listIndex;
  final int itemIndex;
  final Widget item;
  
  const BoardItemSelection({
    required this.listIndex,
    required this.itemIndex,
    required this.item,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoardItemSelection &&
        other.listIndex == listIndex &&
        other.itemIndex == itemIndex;
  }
  
  @override
  int get hashCode => listIndex.hashCode ^ itemIndex.hashCode;
  
  @override
  String toString() => 'BoardItemSelection(listIndex: $listIndex, itemIndex: $itemIndex)';
}

/// Container for all board callbacks
class BoardCallbacks {
  final BoardScrollCallback? onScroll;
  final BoardListVisibilityCallback? onListVisibilityChanged;
  final BoardScrollStateCallback? onScrollStateChanged;
  final BoardDragStartCallback? onDragStart;
  final BoardDragEndCallback? onDragEnd;
  final BoardDragCancelCallback? onDragCancel;
  final BoardItemReorderCallback? onItemReorder;
  final BoardItemMoveCallback? onItemMove;
  final BoardListReorderCallback? onListReorder;
  final BoardLayoutChangeCallback? onLayoutChange;
  final BoardErrorCallback? onError;
  final BoardControllerStateCallback? onControllerStateChanged;
  final BoardAnimationCallback? onAnimationStateChanged;
  final BoardSelectionModeCallback? onSelectionModeChanged;
  final BoardSelectionCallback? onSelectionChanged;
  
  const BoardCallbacks({
    this.onScroll,
    this.onListVisibilityChanged,
    this.onScrollStateChanged,
    this.onDragStart,
    this.onDragEnd,
    this.onDragCancel,
    this.onItemReorder,
    this.onItemMove,
    this.onListReorder,
    this.onLayoutChange,
    this.onError,
    this.onControllerStateChanged,
    this.onAnimationStateChanged,
    this.onSelectionModeChanged,
    this.onSelectionChanged,
  });
  
  /// Creates a copy of this callbacks object with some values replaced
  BoardCallbacks copyWith({
    BoardScrollCallback? onScroll,
    BoardListVisibilityCallback? onListVisibilityChanged,
    BoardScrollStateCallback? onScrollStateChanged,
    BoardDragStartCallback? onDragStart,
    BoardDragEndCallback? onDragEnd,
    BoardDragCancelCallback? onDragCancel,
    BoardItemReorderCallback? onItemReorder,
    BoardItemMoveCallback? onItemMove,
    BoardListReorderCallback? onListReorder,
    BoardLayoutChangeCallback? onLayoutChange,
    BoardErrorCallback? onError,
    BoardControllerStateCallback? onControllerStateChanged,
    BoardAnimationCallback? onAnimationStateChanged,
    BoardSelectionModeCallback? onSelectionModeChanged,
    BoardSelectionCallback? onSelectionChanged,
  }) {
    return BoardCallbacks(
      onScroll: onScroll ?? this.onScroll,
      onListVisibilityChanged: onListVisibilityChanged ?? this.onListVisibilityChanged,
      onScrollStateChanged: onScrollStateChanged ?? this.onScrollStateChanged,
      onDragStart: onDragStart ?? this.onDragStart,
      onDragEnd: onDragEnd ?? this.onDragEnd,
      onDragCancel: onDragCancel ?? this.onDragCancel,
      onItemReorder: onItemReorder ?? this.onItemReorder,
      onItemMove: onItemMove ?? this.onItemMove,
      onListReorder: onListReorder ?? this.onListReorder,
      onLayoutChange: onLayoutChange ?? this.onLayoutChange,
      onError: onError ?? this.onError,
      onControllerStateChanged: onControllerStateChanged ?? this.onControllerStateChanged,
      onAnimationStateChanged: onAnimationStateChanged ?? this.onAnimationStateChanged,
      onSelectionModeChanged: onSelectionModeChanged ?? this.onSelectionModeChanged,
      onSelectionChanged: onSelectionChanged ?? this.onSelectionChanged,
    );
  }
}

/// Container for board list callbacks
class BoardListCallbacks {
  final BoardListScrollCallback? onScroll;
  final BoardListScrollStateCallback? onScrollStateChanged;
  final BoardItemVisibilityCallback? onItemVisibilityChanged;
  final BoardErrorCallback? onError;
  
  const BoardListCallbacks({
    this.onScroll,
    this.onScrollStateChanged,
    this.onItemVisibilityChanged,
    this.onError,
  });
  
  /// Creates a copy of this callbacks object with some values replaced
  BoardListCallbacks copyWith({
    BoardListScrollCallback? onScroll,
    BoardListScrollStateCallback? onScrollStateChanged,
    BoardItemVisibilityCallback? onItemVisibilityChanged,
    BoardErrorCallback? onError,
  }) {
    return BoardListCallbacks(
      onScroll: onScroll ?? this.onScroll,
      onScrollStateChanged: onScrollStateChanged ?? this.onScrollStateChanged,
      onItemVisibilityChanged: onItemVisibilityChanged ?? this.onItemVisibilityChanged,
      onError: onError ?? this.onError,
    );
  }
}