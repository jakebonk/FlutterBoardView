# BoardView Callbacks Documentation

The BoardView package provides comprehensive callback support to monitor and react to various state changes in the board. This document describes all available callbacks and how to use them.

## Overview

Callbacks are organized into two main categories:
- **BoardCallbacks**: For board-level events (scrolling, dragging, animation, etc.)
- **BoardListCallbacks**: For list-specific events (individual list scrolling, item visibility, etc.)

## BoardCallbacks

### Scroll Callbacks

#### onScroll
```dart
BoardScrollCallback onScroll = (double position, double maxExtent) {
  print('Board scrolled to position: $position of $maxExtent');
};
```
Called whenever the board's scroll position changes.

#### onScrollStateChanged
```dart
BoardScrollStateCallback onScrollStateChanged = (bool isScrolling) {
  print('Board scrolling state changed: $isScrolling');
};
```
Called when the board starts or stops scrolling.

### Animation Callbacks

#### onAnimationStateChanged
```dart
BoardAnimationCallback onAnimationStateChanged = (bool isAnimating) {
  print('Board animation state changed: $isAnimating');
};
```
Called when board animations start or complete.

### Drag and Drop Callbacks

#### onDragStart
```dart
BoardDragStartCallback onDragStart = (int listIndex, int itemIndex) {
  print('Started dragging item $itemIndex from list $listIndex');
};
```
Called when a drag operation begins.

#### onDragEnd
```dart
BoardDragEndCallback onDragEnd = (int fromListIndex, int fromItemIndex, int toListIndex, int toItemIndex) {
  print('Moved item from list $fromListIndex to list $toListIndex');
};
```
Called when a drag operation completes successfully.

#### onDragCancel
```dart
BoardDragCancelCallback onDragCancel = (int listIndex, int itemIndex) {
  print('Cancelled dragging item $itemIndex from list $listIndex');
};
```
Called when a drag operation is cancelled.

### Item and List Management Callbacks

#### onItemReorder
```dart
BoardItemReorderCallback onItemReorder = (int listIndex, int fromIndex, int toIndex) {
  print('Reordered item in list $listIndex from $fromIndex to $toIndex');
};
```
Called when an item is reordered within the same list.

#### onItemMove
```dart
BoardItemMoveCallback onItemMove = (int fromListIndex, int fromItemIndex, int toListIndex, int toItemIndex) {
  print('Moved item from list $fromListIndex to list $toListIndex');
};
```
Called when an item is moved to a different list.

#### onListReorder
```dart
BoardListReorderCallback onListReorder = (int fromIndex, int toIndex) {
  print('Moved list from position $fromIndex to $toIndex');
};
```
Called when a list is reordered.

### Selection Callbacks

#### onSelectionModeChanged
```dart
BoardSelectionModeCallback onSelectionModeChanged = (bool isSelecting) {
  print('Selection mode changed: $isSelecting');
};
```
Called when the board enters or exits selection mode.

#### onSelectionChanged
```dart
BoardSelectionCallback onSelectionChanged = (List<BoardItemSelection> selectedItems) {
  print('Selected items: ${selectedItems.length}');
};
```
Called when items are selected or deselected.

### System Callbacks

#### onError
```dart
BoardErrorCallback onError = (String error, StackTrace? stackTrace) {
  print('Board error: $error');
};
```
Called when an error occurs during board operations.

#### onControllerStateChanged
```dart
BoardControllerStateCallback onControllerStateChanged = (bool isAttached) {
  print('Controller attachment state changed: $isAttached');
};
```
Called when the board controller is attached or detached.

#### onLayoutChange
```dart
BoardLayoutChangeCallback onLayoutChange = (Size boardSize) {
  print('Board layout changed to size: $boardSize');
};
```
Called when the board layout changes.

#### onListVisibilityChanged
```dart
BoardListVisibilityCallback onListVisibilityChanged = (int listIndex, bool isVisible) {
  print('List $listIndex visibility changed: $isVisible');
};
```
Called when a list becomes visible or hidden.

## BoardListCallbacks

### onScroll
```dart
BoardListScrollCallback onScroll = (int listIndex, double position, double maxExtent) {
  print('List $listIndex scrolled to position: $position of $maxExtent');
};
```
Called when a list's scroll position changes.

### onScrollStateChanged
```dart
BoardListScrollStateCallback onScrollStateChanged = (int listIndex, bool isScrolling) {
  print('List $listIndex scrolling state changed: $isScrolling');
};
```
Called when a list starts or stops scrolling.

### onItemVisibilityChanged
```dart
BoardItemVisibilityCallback onItemVisibilityChanged = (int listIndex, int itemIndex, bool isVisible) {
  print('Item $itemIndex in list $listIndex visibility changed: $isVisible');
};
```
Called when an item becomes visible or hidden in a list.

### onError
```dart
BoardErrorCallback onError = (String error, StackTrace? stackTrace) {
  print('List error: $error');
};
```
Called when an error occurs during list operations.

## Usage Example

```dart
class MyBoardView extends StatefulWidget {
  @override
  _MyBoardViewState createState() => _MyBoardViewState();
}

class _MyBoardViewState extends State<MyBoardView> {
  final BoardController boardController = BoardController();
  
  @override
  void initState() {
    super.initState();
    _setupCallbacks();
  }
  
  void _setupCallbacks() {
    boardController.setCallbacks(BoardCallbacks(
      onScroll: (position, maxExtent) {
        // Handle scroll events
      },
      onDragStart: (listIndex, itemIndex) {
        // Handle drag start
      },
      onDragEnd: (fromListIndex, fromItemIndex, toListIndex, toItemIndex) {
        // Handle drag end
        _updateDataModel(fromListIndex, fromItemIndex, toListIndex, toItemIndex);
      },
      onError: (error, stackTrace) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      },
    ));
  }
  
  void _updateDataModel(int fromListIndex, int fromItemIndex, int toListIndex, int toItemIndex) {
    // Update your data model here
    final item = myData[fromListIndex].items.removeAt(fromItemIndex);
    myData[toListIndex].items.insert(toItemIndex, item);
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return BoardView(
      lists: myLists,
      boardController: boardController,
      // ... other properties
    );
  }
}
```

## Best Practices

1. **Set up callbacks early**: Initialize callbacks in `initState()` or immediately after creating the controller.

2. **Handle errors gracefully**: Always implement the `onError` callback to handle unexpected issues.

3. **Update data models**: Use drag callbacks to update your underlying data structure.

4. **Provide user feedback**: Use callbacks to show loading states, progress indicators, or success messages.

5. **Optimize performance**: Avoid heavy operations in frequently called callbacks like `onScroll`.

6. **Clean up resources**: If you store references to callback data, make sure to clean them up when the widget is disposed.

## Callback Flow

### Drag and Drop Flow
1. `onDragStart` - User starts dragging
2. `onScroll` - May be called during drag if scrolling occurs
3. `onDragEnd` - User completes the drag
4. `onItemReorder` OR `onItemMove` - More specific callback based on the operation
5. Update your data model

### Animation Flow
1. `onAnimationStateChanged(true)` - Animation starts
2. `onScroll` - Called during animation
3. `onAnimationStateChanged(false)` - Animation completes

### Selection Flow
1. `onSelectionModeChanged(true)` - Enter selection mode
2. `onSelectionChanged` - Called when items are selected/deselected
3. `onSelectionModeChanged(false)` - Exit selection mode

## Migration from Legacy Controller

If you're using the legacy `BoardViewController`, you can easily migrate:

```dart
// Old way
final BoardViewController oldController = BoardViewController();

// New way
final BoardController newController = BoardController();
newController.setCallbacks(BoardCallbacks(
  // Your callbacks here
));
```

The new controller provides all the same functionality plus the callback system for better state management and user experience.