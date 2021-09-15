import 'package:boardview/board_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnDropItem = void Function(int? listIndex, int? itemIndex,
    int? oldListIndex, int? oldItemIndex, BoardItemState state);
typedef OnTapItem = void Function(
    int? listIndex, int? itemIndex, BoardItemState state);
typedef OnStartDragItem = void Function(
    int? listIndex, int? itemIndex, BoardItemState state);
typedef OnDragItem = void Function(int oldListIndex, int oldItemIndex,
    int newListIndex, int newItemIndex, BoardItemState state);

class BoardItem extends StatefulWidget {
  final BoardListState? boardList;
  final Widget? item;
  final int? index;
  final OnDropItem? onDropItem;
  final OnTapItem? onTapItem;
  final OnStartDragItem? onStartDragItem;
  final OnDragItem? onDragItem;
  final bool draggable;

  const BoardItem(
      {Key? key,
      this.boardList,
      this.item,
      this.index,
      this.onDropItem,
      this.onTapItem,
      this.onStartDragItem,
      this.draggable = true,
      this.onDragItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BoardItemState();
  }
}

class BoardItemState extends State<BoardItem>
    with AutomaticKeepAliveClientMixin {
  late double height;
  double? width;

  @override
  bool get wantKeepAlive => true;

  void _onDropItem(int? listIndex, int? itemIndex) {
    if (widget.onDropItem != null) {
      widget.onDropItem!(
          listIndex,
          itemIndex,
          widget.boardList!.widget.boardView!.startListIndex,
          widget.boardList!.widget.boardView!.startItemIndex,
          this);
    }
    widget.boardList!.widget.boardView!.draggedItemIndex = null;
    widget.boardList!.widget.boardView!.draggedListIndex = null;
    if (widget.boardList!.widget.boardView!.listStates[listIndex!].mounted) {
      widget.boardList!.widget.boardView!.listStates[listIndex].setState(() {});
    }
  }

  bool get canStartDragging =>
      widget.boardList!.widget.boardView!.widget.isNotSelecting &&
      widget.draggable;

  void _startDrag(Widget item, BuildContext context) {
    if (canStartDragging) {
      RenderBox object = context.findRenderObject() as RenderBox;
      Offset pos = object.localToGlobal(Offset.zero);
      RenderBox box = widget.boardList!.context.findRenderObject() as RenderBox;
      Offset listPos = box.localToGlobal(Offset.zero);
      widget.boardList!.widget.boardView!.leftListX = listPos.dx;
      widget.boardList!.widget.boardView!.topListY = listPos.dy;
      widget.boardList!.widget.boardView!.topItemY = pos.dy;
      widget.boardList!.widget.boardView!.bottomItemY =
          pos.dy + object.size.height;
      widget.boardList!.widget.boardView!.bottomListY =
          listPos.dy + box.size.height;
      widget.boardList!.widget.boardView!.rightListX =
          listPos.dx + box.size.width;

      widget.boardList!.widget.boardView!.initialX = pos.dx;
      widget.boardList!.widget.boardView!.initialY = pos.dy;

      if (widget.boardList!.widget.boardView != null) {
        widget.boardList!.widget.boardView!.onDropItem = _onDropItem;
        if (widget.boardList!.mounted) {
          widget.boardList!.setState(() {});
        }
        widget.boardList!.widget.boardView!.draggedItemIndex = widget.index;
        widget.boardList!.widget.boardView!.height = context.size!.height;
        widget.boardList!.widget.boardView!.draggedListIndex =
            widget.boardList!.widget.index;
        widget.boardList!.widget.boardView!.startListIndex =
            widget.boardList!.widget.index;
        widget.boardList!.widget.boardView!.startItemIndex = widget.index;
        widget.boardList!.widget.boardView!.draggedItem = item;
        if (widget.onStartDragItem != null) {
          widget.onStartDragItem!(
              widget.boardList!.widget.index, widget.index, this);
        }
        widget.boardList!.widget.boardView!.run();
        if (widget.boardList!.widget.boardView!.mounted) {
          widget.boardList!.widget.boardView!.setState(() {});
        }
      }
    }
  }

  void afterFirstLayout(BuildContext context) {
    if (context.size != null) {
      height = context.size!.height;
      width = context.size!.width;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => afterFirstLayout(context));
    if (widget.boardList!.itemStates.length > widget.index!) {
      widget.boardList!.itemStates.removeAt(widget.index!);
    }
    widget.boardList!.itemStates.insert(widget.index!, this);
    return GestureDetector(
      onTap: () {
        if (widget.onTapItem != null) {
          widget.onTapItem!(widget.boardList!.widget.index, widget.index, this);
        }
      },
      onHorizontalDragStart: (DragStartDetails _) =>
          _startDrag(widget, context),
      onVerticalDragStart: (DragStartDetails _) => _startDrag(widget, context),
      child: widget.item,
    );
  }
}
