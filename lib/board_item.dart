import 'package:boardview/board_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void OnDropItem(int list_index, int item_index, BoardItemState state);
typedef void OnTapItem(int list_index, int item_index, BoardItemState state);
typedef void OnStartDragItem(
    int list_index, int item_index, BoardItemState state);
typedef void OnDragItem(int old_list_index, int old_item_index,
    int new_list_index, int new_item_index, BoardItemState state);

class BoardItem extends StatefulWidget {
  final BoardListState boardList;
  final Widget item;
  final int index;
  final OnDropItem onDropItem;
  final OnTapItem onTapItem;
  final OnStartDragItem onStartDragItem;
  final OnDragItem onDragItem;
  final String test;

  const BoardItem(
      {Key key,
      this.boardList,
      this.item,
      this.index,
      this.onDropItem,
      this.onTapItem,
      this.onStartDragItem,
      this.test,
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

  void on_drop_item(int list_index, int item_index) {
    widget.boardList.widget.boardView.list_states[list_index].setState(() {
      if (widget.onDropItem != null) {
        widget.onDropItem(list_index, item_index, this);
      }
      widget.boardList.widget.boardView.dragged_item_index = null;
      widget.boardList.widget.boardView.dragged_list_index = null;
    });
  }

  void _StartDrag(Widget item, BuildContext context) {
    if (widget.boardList.widget.boardView != null) {
      widget.boardList.widget.boardView.setState(() {
        widget.boardList.widget.boardView.dragged_item_index = widget.index;
        widget.boardList.widget.boardView.height = context.size.height;
        widget.boardList.widget.boardView.dragged_list_index =
            widget.boardList.widget.index;
        widget.boardList.widget.boardView.dragged_item = item;
        widget.boardList.setState(() {
          widget.boardList.widget.boardView.on_drop_item = on_drop_item;
        });
        if (widget.onStartDragItem != null) {
          widget.onStartDragItem(
              widget.boardList.widget.index, widget.index, this);
        }
      });
    } else {
      print("BoardView is null");
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    height = context.size.height;
    width = context.size.width;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
    if(widget.boardList.item_states.length > widget.index) {
      widget.boardList.item_states.removeAt(widget.index);
    }
    widget.boardList.item_states.insert(widget.index, this);
    return GestureDetector(
      onTapDown: (otd) {
        RenderBox object = context.findRenderObject();
        Offset pos = object.localToGlobal(Offset.zero);
        RenderBox box = widget.boardList.context.findRenderObject();
        Offset list_pos = box.localToGlobal(Offset.zero);
        Offset pos2 = object.globalToLocal(otd.globalPosition);
        widget.boardList.widget.boardView.left_list_x = list_pos.dx;
        widget.boardList.widget.boardView.top_list_y = list_pos.dy;
        widget.boardList.widget.boardView.top_item_y = pos.dy;
        widget.boardList.widget.boardView.bottom_item_y = pos.dy+object.size.height;
        widget.boardList.widget.boardView.bottom_list_y = list_pos.dy+box.size.height;
        widget.boardList.widget.boardView.right_list_x = list_pos.dx+box.size.width;

        widget.boardList.widget.boardView.initial_x = pos.dx;
        widget.boardList.widget.boardView.initial_y = pos.dy;
      },
      onTapCancel: () {},
      onTap: () {
        if (widget.onTapItem != null) {
          widget.onTapItem(widget.boardList.widget.index, widget.index, this);
        }
      },
      onLongPress: () {
        _StartDrag(widget, context);
      },
      child: widget.item,
    );
  }
}
