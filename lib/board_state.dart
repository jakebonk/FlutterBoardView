import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'board_callbacks.dart';

/// Represents the state of a board item during drag operations
class BoardItemState {
  final int listIndex;
  final int itemIndex;
  final Widget widget;
  final Offset position;
  final Size size;
  
  const BoardItemState({
    required this.listIndex,
    required this.itemIndex,
    required this.widget,
    required this.position,
    required this.size,
  });
  
  BoardItemState copyWith({
    int? listIndex,
    int? itemIndex,
    Widget? widget,
    Offset? position,
    Size? size,
  }) {
    return BoardItemState(
      listIndex: listIndex ?? this.listIndex,
      itemIndex: itemIndex ?? this.itemIndex,
      widget: widget ?? this.widget,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

/// Manages the state of drag and drop operations
class BoardDragState extends ChangeNotifier {
  BoardItemState? _draggedItem;
  int? _draggedListIndex;
  int? _draggedItemIndex;
  int? _startListIndex;
  int? _startItemIndex;
  Offset? _currentPosition;
  bool _isDragging = false;
  BoardCallbacks? _callbacks;
  
  /// The currently dragged item
  BoardItemState? get draggedItem => _draggedItem;
  
  /// The index of the list being dragged
  int? get draggedListIndex => _draggedListIndex;
  
  /// The index of the item being dragged
  int? get draggedItemIndex => _draggedItemIndex;
  
  /// The original list index where dragging started
  int? get startListIndex => _startListIndex;
  
  /// The original item index where dragging started
  int? get startItemIndex => _startItemIndex;
  
  /// The current position of the dragged item
  Offset? get currentPosition => _currentPosition;
  
  /// Whether an item is currently being dragged
  bool get isDragging => _isDragging;
  
  /// Sets the callbacks for drag state changes
  void setCallbacks(BoardCallbacks? callbacks) {
    _callbacks = callbacks;
  }
  
  /// Starts a drag operation
  void startDrag({
    required BoardItemState item,
    required int listIndex,
    required int itemIndex,
    required Offset position,
  }) {
    _draggedItem = item;
    _draggedListIndex = listIndex;
    _draggedItemIndex = itemIndex;
    _startListIndex = listIndex;
    _startItemIndex = itemIndex;
    _currentPosition = position;
    _isDragging = true;
    _callbacks?.onDragStart?.call(listIndex, itemIndex);
    notifyListeners();
  }
  
  /// Updates the drag position
  void updateDragPosition(Offset position) {
    if (_isDragging) {
      _currentPosition = position;
      notifyListeners();
    }
  }
  
  /// Moves the dragged item to a new position
  void moveItem({
    required int newListIndex,
    required int newItemIndex,
  }) {
    if (_isDragging) {
      _draggedListIndex = newListIndex;
      _draggedItemIndex = newItemIndex;
      notifyListeners();
    }
  }
  
  /// Ends the drag operation
  void endDrag() {
    if (_isDragging && _startListIndex != null && _startItemIndex != null && _draggedListIndex != null && _draggedItemIndex != null) {
      _callbacks?.onDragEnd?.call(_startListIndex!, _startItemIndex!, _draggedListIndex!, _draggedItemIndex!);
      
      // Also call more specific callbacks
      if (_startListIndex == _draggedListIndex) {
        _callbacks?.onItemReorder?.call(_startListIndex!, _startItemIndex!, _draggedItemIndex!);
      } else {
        _callbacks?.onItemMove?.call(_startListIndex!, _startItemIndex!, _draggedListIndex!, _draggedItemIndex!);
      }
    }
    
    _draggedItem = null;
    _draggedListIndex = null;
    _draggedItemIndex = null;
    _startListIndex = null;
    _startItemIndex = null;
    _currentPosition = null;
    _isDragging = false;
    notifyListeners();
  }
  
  /// Cancels the drag operation and returns to original position
  void cancelDrag() {
    if (_isDragging && _startListIndex != null && _startItemIndex != null) {
      _callbacks?.onDragCancel?.call(_startListIndex!, _startItemIndex!);
      _draggedListIndex = _startListIndex;
      _draggedItemIndex = _startItemIndex;
      endDrag();
    }
  }
}

/// Manages the overall state of the board
class BoardDataState extends ChangeNotifier {
  List<List<Widget>> _lists = [];
  final BoardDragState _dragState = BoardDragState();
  BoardCallbacks? _callbacks;
  
  /// The current lists in the board
  List<List<Widget>> get lists => List.unmodifiable(_lists);
  
  /// The drag state manager
  BoardDragState get dragState => _dragState;
  
  /// Sets the callbacks for state changes
  void setCallbacks(BoardCallbacks? callbacks) {
    _callbacks = callbacks;
    _dragState.setCallbacks(callbacks);
  }
  
  /// Updates the board lists
  void updateLists(List<List<Widget>> newLists) {
    _lists = List.from(newLists.map((list) => List.from(list)));
    notifyListeners();
  }
  
  /// Adds a new list to the board
  void addList(List<Widget> list) {
    _lists.add(List.from(list));
    notifyListeners();
  }
  
  /// Removes a list from the board
  void removeList(int index) {
    if (index >= 0 && index < _lists.length) {
      _lists.removeAt(index);
      notifyListeners();
    }
  }
  
  /// Adds an item to a specific list
  void addItem(int listIndex, Widget item) {
    if (listIndex >= 0 && listIndex < _lists.length) {
      _lists[listIndex].add(item);
      notifyListeners();
    }
  }
  
  /// Removes an item from a specific list
  void removeItem(int listIndex, int itemIndex) {
    if (listIndex >= 0 && listIndex < _lists.length &&
        itemIndex >= 0 && itemIndex < _lists[listIndex].length) {
      _lists[listIndex].removeAt(itemIndex);
      notifyListeners();
    }
  }
  
  /// Moves an item from one position to another
  void moveItem({
    required int fromListIndex,
    required int fromItemIndex,
    required int toListIndex,
    required int toItemIndex,
  }) {
    if (fromListIndex >= 0 && fromListIndex < _lists.length &&
        fromItemIndex >= 0 && fromItemIndex < _lists[fromListIndex].length &&
        toListIndex >= 0 && toListIndex < _lists.length &&
        toItemIndex >= 0 && toItemIndex <= _lists[toListIndex].length) {
      
      final item = _lists[fromListIndex].removeAt(fromItemIndex);
      _lists[toListIndex].insert(toItemIndex, item);
      
      // Notify about the move
      if (fromListIndex == toListIndex) {
        _callbacks?.onItemReorder?.call(fromListIndex, fromItemIndex, toItemIndex);
      } else {
        _callbacks?.onItemMove?.call(fromListIndex, fromItemIndex, toListIndex, toItemIndex);
      }
      
      notifyListeners();
    }
  }
  
  /// Reorders a list
  void moveList({
    required int fromIndex,
    required int toIndex,
  }) {
    if (fromIndex >= 0 && fromIndex < _lists.length &&
        toIndex >= 0 && toIndex <= _lists.length) {
      
      final list = _lists.removeAt(fromIndex);
      _lists.insert(toIndex, list);
      
      // Notify about the list reorder
      _callbacks?.onListReorder?.call(fromIndex, toIndex);
      
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    _dragState.dispose();
    super.dispose();
  }
}