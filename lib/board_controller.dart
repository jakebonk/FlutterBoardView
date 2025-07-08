import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'board_callbacks.dart';

/// A modern controller for the BoardView widget that extends ChangeNotifier
/// and provides a clean API for controlling board state and animations.
class BoardController extends ChangeNotifier {
  ScrollController? _scrollController;
  double _itemWidth = 280.0;
  bool _isDisposed = false;
  bool _isAnimating = false;
  bool _isScrolling = false;
  bool _isSelecting = false;
  final List<BoardItemSelection> _selectedItems = [];
  BoardCallbacks? _callbacks;
  
  /// The current scroll position of the board
  double get scrollPosition => _scrollController?.offset ?? 0.0;
  
  /// Whether the controller is attached to a scrollable widget
  bool get isAttached => _scrollController?.hasClients ?? false;
  
  /// The width of each board item/list
  double get itemWidth => _itemWidth;
  
  /// Sets the item width for calculations
  set itemWidth(double width) {
    if (_isDisposed) return;
    _itemWidth = width;
    notifyListeners();
  }
  
  /// Whether the controller is currently animating
  bool get isAnimating => _isAnimating;
  
  /// Whether the board is currently scrolling
  bool get isScrolling => _isScrolling;
  
  /// Whether the board is in selection mode
  bool get isSelecting => _isSelecting;
  
  /// The currently selected items
  List<BoardItemSelection> get selectedItems => List.unmodifiable(_selectedItems);
  
  /// Sets the callbacks for state changes
  void setCallbacks(BoardCallbacks? callbacks) {
    if (_isDisposed) return;
    _callbacks = callbacks;
  }
  
  /// Attaches the scroll controller
  void attachScrollController(ScrollController controller) {
    if (_isDisposed) return;
    _scrollController = controller;
    _callbacks?.onControllerStateChanged?.call(true);
    
    // Listen to scroll changes
    controller.addListener(_onScrollChanged);
  }
  
  /// Handles scroll position changes
  void _onScrollChanged() {
    if (_isDisposed || _scrollController == null) return;
    
    final position = _scrollController!.offset;
    final maxExtent = _scrollController!.position.maxScrollExtent;
    
    // Check if scrolling state changed
    final wasScrolling = _isScrolling;
    _isScrolling = _scrollController!.position.isScrollingNotifier.value;
    
    if (wasScrolling != _isScrolling) {
      _callbacks?.onScrollStateChanged?.call(_isScrolling);
    }
    
    _callbacks?.onScroll?.call(position, maxExtent);
  }
  
  /// Animates to a specific list index
  Future<void> animateToList(int listIndex, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.ease,
  }) async {
    if (!isAttached || _isDisposed) return;
    
    try {
      _setAnimating(true);
      final targetOffset = listIndex * _itemWidth;
      await _scrollController!.animateTo(
        targetOffset,
        duration: duration,
        curve: curve,
      );
    } catch (e, stackTrace) {
      _callbacks?.onError?.call('Failed to animate to list $listIndex: $e', stackTrace);
    } finally {
      _setAnimating(false);
    }
  }
  
  /// Scrolls to a specific list index instantly
  void jumpToList(int listIndex) {
    if (!isAttached || _isDisposed) return;
    
    final targetOffset = listIndex * _itemWidth;
    _scrollController!.jumpTo(targetOffset);
  }
  
  /// Scrolls to a specific pixel offset
  Future<void> animateToOffset(double offset, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.ease,
  }) async {
    if (!isAttached || _isDisposed) return;
    
    try {
      _setAnimating(true);
      await _scrollController!.animateTo(
        offset,
        duration: duration,
        curve: curve,
      );
    } catch (e, stackTrace) {
      _callbacks?.onError?.call('Failed to animate to offset $offset: $e', stackTrace);
    } finally {
      _setAnimating(false);
    }
  }
  
  /// Gets the current visible list index based on scroll position
  int get currentListIndex {
    if (!isAttached || _isDisposed) return 0;
    return (scrollPosition / _itemWidth).round();
  }
  
  /// Gets the maximum scroll extent
  double get maxScrollExtent => _scrollController?.position.maxScrollExtent ?? 0.0;
  
  /// Gets the minimum scroll extent
  double get minScrollExtent => _scrollController?.position.minScrollExtent ?? 0.0;
  
  /// Sets the animation state
  void _setAnimating(bool animating) {
    if (_isDisposed || _isAnimating == animating) return;
    _isAnimating = animating;
    _callbacks?.onAnimationStateChanged?.call(_isAnimating);
  }
  
  /// Enables or disables selection mode
  void setSelectionMode(bool selecting) {
    if (_isDisposed || _isSelecting == selecting) return;
    _isSelecting = selecting;
    
    if (!selecting) {
      _selectedItems.clear();
    }
    
    _callbacks?.onSelectionModeChanged?.call(_isSelecting);
    _callbacks?.onSelectionChanged?.call(selectedItems);
  }
  
  /// Selects or deselects an item
  void toggleItemSelection(int listIndex, int itemIndex, Widget item) {
    if (_isDisposed || !_isSelecting) return;
    
    final selection = BoardItemSelection(
      listIndex: listIndex,
      itemIndex: itemIndex,
      item: item,
    );
    
    final existingIndex = _selectedItems.indexWhere((s) => s.listIndex == listIndex && s.itemIndex == itemIndex);
    
    if (existingIndex >= 0) {
      _selectedItems.removeAt(existingIndex);
    } else {
      _selectedItems.add(selection);
    }
    
    _callbacks?.onSelectionChanged?.call(selectedItems);
  }
  
  /// Clears all selected items
  void clearSelection() {
    if (_isDisposed || _selectedItems.isEmpty) return;
    _selectedItems.clear();
    _callbacks?.onSelectionChanged?.call(selectedItems);
  }
  
  /// Notifies about drag start
  void notifyDragStart(int listIndex, int itemIndex) {
    if (_isDisposed) return;
    _callbacks?.onDragStart?.call(listIndex, itemIndex);
  }
  
  /// Notifies about drag end
  void notifyDragEnd(int fromListIndex, int fromItemIndex, int toListIndex, int toItemIndex) {
    if (_isDisposed) return;
    _callbacks?.onDragEnd?.call(fromListIndex, fromItemIndex, toListIndex, toItemIndex);
    
    // Also call more specific callbacks
    if (fromListIndex == toListIndex) {
      _callbacks?.onItemReorder?.call(fromListIndex, fromItemIndex, toItemIndex);
    } else {
      _callbacks?.onItemMove?.call(fromListIndex, fromItemIndex, toListIndex, toItemIndex);
    }
  }
  
  /// Notifies about drag cancel
  void notifyDragCancel(int listIndex, int itemIndex) {
    if (_isDisposed) return;
    _callbacks?.onDragCancel?.call(listIndex, itemIndex);
  }
  
  /// Notifies about list reorder
  void notifyListReorder(int fromIndex, int toIndex) {
    if (_isDisposed) return;
    _callbacks?.onListReorder?.call(fromIndex, toIndex);
  }
  
  /// Notifies about layout change
  void notifyLayoutChange(Size boardSize) {
    if (_isDisposed) return;
    _callbacks?.onLayoutChange?.call(boardSize);
  }
  
  @override
  void dispose() {
    if (!_isDisposed) {
      _scrollController?.removeListener(_onScrollChanged);
      _scrollController = null;
      _selectedItems.clear();
      _callbacks?.onControllerStateChanged?.call(false);
      _callbacks = null;
      _isDisposed = true;
      super.dispose();
    }
  }
}

/// A specialized controller for individual board lists
class BoardListController extends ChangeNotifier {
  ScrollController? _scrollController;
  bool _isDisposed = false;
  bool _isScrolling = false;
  int _listIndex = 0;
  BoardListCallbacks? _callbacks;
  
  /// Whether the controller is attached to a scrollable widget
  bool get isAttached => _scrollController?.hasClients ?? false;
  
  /// The current scroll position
  double get scrollPosition => _scrollController?.offset ?? 0.0;
  
  /// Whether this list is currently scrolling
  bool get isScrolling => _isScrolling;
  
  /// The index of this list in the board
  int get listIndex => _listIndex;
  
  /// Sets the list index
  void setListIndex(int index) {
    if (_isDisposed) return;
    _listIndex = index;
  }
  
  /// Sets the callbacks for state changes
  void setCallbacks(BoardListCallbacks? callbacks) {
    if (_isDisposed) return;
    _callbacks = callbacks;
  }
  
  /// Attaches the scroll controller
  void attachScrollController(ScrollController controller) {
    if (_isDisposed) return;
    _scrollController = controller;
    
    // Listen to scroll changes
    controller.addListener(_onScrollChanged);
  }
  
  /// Handles scroll position changes
  void _onScrollChanged() {
    if (_isDisposed || _scrollController == null) return;
    
    final position = _scrollController!.offset;
    final maxExtent = _scrollController!.position.maxScrollExtent;
    
    // Check if scrolling state changed
    final wasScrolling = _isScrolling;
    _isScrolling = _scrollController!.position.isScrollingNotifier.value;
    
    if (wasScrolling != _isScrolling) {
      _callbacks?.onScrollStateChanged?.call(_listIndex, _isScrolling);
    }
    
    _callbacks?.onScroll?.call(_listIndex, position, maxExtent);
  }
  
  /// Animates to a specific item index within the list
  Future<void> animateToItem(int itemIndex, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
  }) async {
    if (!isAttached || _isDisposed) return;
    
    try {
      // This is a simplified version - in a real implementation,
      // you'd calculate the actual item offset based on item heights
      await _scrollController!.animateTo(
        itemIndex * 60.0, // Assuming average item height of 60
        duration: duration,
        curve: curve,
      );
    } catch (e, stackTrace) {
      _callbacks?.onError?.call('Failed to animate to item $itemIndex in list $_listIndex: $e', stackTrace);
    }
  }
  
  /// Scrolls to the top of the list
  Future<void> scrollToTop({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
  }) async {
    if (!isAttached || _isDisposed) return;
    
    try {
      await _scrollController!.animateTo(
        0.0,
        duration: duration,
        curve: curve,
      );
    } catch (e, stackTrace) {
      _callbacks?.onError?.call('Failed to scroll to top of list $_listIndex: $e', stackTrace);
    }
  }
  
  /// Scrolls to the bottom of the list
  Future<void> scrollToBottom({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
  }) async {
    if (!isAttached || _isDisposed) return;
    
    try {
      await _scrollController!.animateTo(
        _scrollController!.position.maxScrollExtent,
        duration: duration,
        curve: curve,
      );
    } catch (e, stackTrace) {
      _callbacks?.onError?.call('Failed to scroll to bottom of list $_listIndex: $e', stackTrace);
    }
  }
  
  /// Notifies about item visibility change
  void notifyItemVisibilityChanged(int itemIndex, bool isVisible) {
    if (_isDisposed) return;
    _callbacks?.onItemVisibilityChanged?.call(_listIndex, itemIndex, isVisible);
  }
  
  @override
  void dispose() {
    if (!_isDisposed) {
      _scrollController?.removeListener(_onScrollChanged);
      _scrollController = null;
      _callbacks = null;
      _isDisposed = true;
      super.dispose();
    }
  }
}