import 'package:boardview/board_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void OnDropItem(int listIndex, int itemIndex,int oldListIndex,int oldItemIndex BoardItemState state);
typedef void OnTapItem(int listIndex, int itemIndex, BoardItemState state);
typedef void OnStartDragItem(
    int listIndex, int itemIndex, BoardItemState state);
typedef void OnDragItem(int oldListIndex, int oldItemIndex, int newListIndex,
    int newItemIndex, BoardItemState state);

class BoardItem extends StatefulWidget {
  final BoardListState boardList;
  final Widget item;
  final int index;
  final OnDropItem onDropItem;
  final OnTapItem onTapItem;
  final OnStartDragItem onStartDragItem;
  final OnDragItem onDragItem;

  const BoardItem(
      {Key key,
      this.boardList,
      this.item,
      this.index,
      this.onDropItem,
      this.onTapItem,
      this.onStartDragItem,
      this.onDragItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BoardItemState();
  }
}

class BoardItemState extends State<BoardItem> {
  double height;
  double width;

  void onDropItem(int listIndex, int itemIndex) {
    widget.boardList.widget.boardView.listStates[listIndex].setState(() {
      if (widget.onDropItem != null) {
        widget.onDropItem(listIndex, itemIndex,widget.boardList.widget.boardView.startListIndex,widget.boardList.widget.boardView.startItemIndex, this);
      }
      widget.boardList.widget.boardView.draggedItemIndex = null;
      widget.boardList.widget.boardView.draggedListIndex = null;
    });
  }

  void _startDrag(Widget item, BuildContext context) {
    if (widget.boardList.widget.boardView != null) {
      widget.boardList.widget.boardView.setState(() {
        widget.boardList.widget.boardView.draggedItemIndex = widget.index;
        widget.boardList.widget.boardView.height = context.size.height;
        widget.boardList.widget.boardView.draggedListIndex =
            widget.boardList.widget.index;
        widget.boardList.widget.boardView.startListIndex = widget.boardList.widget.index;
        widget.boardList.widget.boardView.startItemIndex = widget.index;
        widget.boardList.widget.boardView.draggedItem = item;
        widget.boardList.setState(() {
          widget.boardList.widget.boardView.onDropItem = onDropItem;
        });
        if (widget.onStartDragItem != null) {
          widget.onStartDragItem(
              widget.boardList.widget.index, widget.index, this);
        }
      });
    }
  }

  void afterFirstLayout(BuildContext context) {
    height = context.size.height;
    width = context.size.width;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
    if (widget.boardList.itemStates.length > widget.index) {
      widget.boardList.itemStates.removeAt(widget.index);
    }
    widget.boardList.itemStates.insert(widget.index, this);
    return GestureDetector(
      onTapDown: (otd) {
        RenderBox object = context.findRenderObject();
        Offset pos = object.localToGlobal(Offset.zero);
        RenderBox box = widget.boardList.context.findRenderObject();
        Offset listPos = box.localToGlobal(Offset.zero);
        widget.boardList.widget.boardView.leftListX = listPos.dx;
        widget.boardList.widget.boardView.topListY = listPos.dy;
        widget.boardList.widget.boardView.topItemY = pos.dy;
        widget.boardList.widget.boardView.bottomItemY =
            pos.dy + object.size.height;
        widget.boardList.widget.boardView.bottomListY =
            listPos.dy + box.size.height;
        widget.boardList.widget.boardView.rightListX =
            listPos.dx + box.size.width;

        widget.boardList.widget.boardView.initialX = pos.dx;
        widget.boardList.widget.boardView.initialY = pos.dy;
      },
      onTapCancel: () {},
      onTap: () {
        if (widget.onTapItem != null) {
          widget.onTapItem(widget.boardList.widget.index, widget.index, this);
        }
      },
      onLongPress: () {
        _startDrag(widget, context);
      },
      child: widget.item,
    );
  }
}
