import 'package:boardview/board_item.dart';
import 'package:boardview/boardview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BoardList extends StatefulWidget {
  final Widget header;
  final Widget footer;
  final List<BoardItem> items;
  final Color backgroundColor;
  final Color headerBackgroundColor;
  final BoardViewState boardView;

  const BoardList({
    Key key,
    this.header,
    this.items,
    this.footer,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.boardView,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  State<StatefulWidget> createState() {
    return BoardListState();
  }
}

class BoardListState extends State<BoardList> {
  List<BoardItemState> item_states = List<BoardItemState>();
  ScrollController boardListController = new ScrollController();


  void on_drop_list(int list_index) {
    widget.boardView.setState(() {
      widget.boardView.dragged_list_index = null;
    });
  }

  void _StartDrag(Widget item, BuildContext context) {
    if (widget.boardView != null) {
      widget.boardView.setState(() {
        widget.boardView.height = context.size.height;
        widget.boardView.dragged_list_index = widget.index;
        widget.boardView.dragged_item_index = null;
        widget.boardView.dragged_item = item;
        widget.boardView.on_drop_list = on_drop_list;
      });
    } else {
      print("BoardView is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list_widgets = new List<Widget>();
    if (widget.header != null) {
      Color headerBackgroundColor = Color.fromARGB(255, 255, 255, 255);
      if (widget.headerBackgroundColor != null) {
        headerBackgroundColor = widget.headerBackgroundColor;
      }
      list_widgets.add(GestureDetector(
        onTapDown: (otd) {
          RenderBox object = context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          widget.boardView.initial_x = pos.dx;
          widget.boardView.initial_y = pos.dy;

          widget.boardView.right_list_x = pos.dx+object.size.width;
          widget.boardView.left_list_x = pos.dx;
        },
        onTapCancel: () {},
        onLongPress: () {
          _StartDrag(widget, context);
        },
        child: Container(
          color: headerBackgroundColor,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.header,
              ]),
        ),
      ));
    }

    if (widget.items != null) {
      list_widgets.add(Container(
          child: Flexible(
              fit: FlexFit.loose,
              child: new ListView.builder(
                shrinkWrap: true,
                controller: boardListController,
                itemCount: widget.items.length,
                itemBuilder: (ctx, index) {
                  if (widget.items[index].boardList == null ||
                      widget.items[index].index != index ||
                      widget.items[index].boardList != this) {
                    widget.items[index] = new BoardItem(
                      boardList: this,
                      item: widget.items[index].item,
                      test: widget.items[index].test,
                      index: index,
                      onDropItem: widget.items[index].onDropItem,
                      onTapItem: widget.items[index].onTapItem,
                      onDragItem: widget.items[index].onDragItem,
                      onStartDragItem: widget.items[index].onStartDragItem,
                    );
                  }
                  if (widget.boardView.dragged_item_index == index && widget.boardView.dragged_list_index == widget.index) {
                    return Opacity(
                      opacity: 0.0,
                      child: widget.items[index],
                    );
                  } else {
                    return widget.items[index];
                  }
                },
              ))));
    }

    if (widget.footer != null) {
      list_widgets.add(widget.footer);
    }

    Color backgroundColor = Color.fromARGB(255, 255, 255, 255);

    if (widget.backgroundColor != null) {
      backgroundColor = widget.backgroundColor;
    }
    if(widget.boardView.list_states.length > widget.index) {
      widget.boardView.list_states.removeAt(widget.index);
    }
    widget.boardView.list_states.insert(widget.index, this);

    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: list_widgets,
        ));
  }
}
