library boardview;

import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';

class BoardView extends StatefulWidget {
  final List<BoardList> lists;

  const BoardView({
    Key key,
    this.lists,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BoardViewState();
  }
}

typedef void OnDropItem(int list_index, int item_index);
typedef void OnDropList(int list_index);

class BoardViewState extends State<BoardView> {
  Widget dragged_item;
  int dragged_item_index;
  int dragged_list_index;
  double dx;
  double dx_init;
  double dy_init;
  double dy;
  double offset_x;
  double offset_y;
  double initial_x = 0;
  double initial_y = 0;
  double right_list_x;
  double left_list_x;
  double top_list_y;
  double bottom_list_y;
  double top_item_y;
  double bottom_item_y;
  double height;
  double width = 280;

  bool can_drag = true;

  ScrollController _boardViewController = new ScrollController();

  List<BoardListState> list_states = List<BoardListState>();

  OnDropItem on_drop_item;
  OnDropList on_drop_list;

  void move_down() {
    list_states[dragged_list_index].setState(() {
      top_item_y += list_states[dragged_list_index]
          .item_states[dragged_item_index+1].height;
      bottom_item_y += list_states[dragged_list_index]
          .item_states[dragged_item_index+1].height;
      var item = widget.lists[dragged_list_index].items[dragged_item_index];
      widget.lists[dragged_list_index].items.removeAt(dragged_item_index);
      var item_state =
          list_states[dragged_list_index].item_states[dragged_item_index];
      list_states[dragged_list_index].item_states.removeAt(dragged_item_index);
      widget.lists[dragged_list_index].items.insert(++dragged_item_index, item);
      list_states[dragged_list_index]
          .item_states
          .insert(dragged_item_index, item_state);
    });
  }

  void move_up() {
    list_states[dragged_list_index].setState(() {
      top_item_y -= list_states[dragged_list_index]
          .item_states[dragged_item_index-1].height;
      bottom_item_y -= list_states[dragged_list_index]
          .item_states[dragged_item_index-1].height;
      var item = widget.lists[dragged_list_index].items[dragged_item_index];
      widget.lists[dragged_list_index].items.removeAt(dragged_item_index);
      var item_state =
          list_states[dragged_list_index].item_states[dragged_item_index];
      list_states[dragged_list_index].item_states.removeAt(dragged_item_index);
      widget.lists[dragged_list_index].items.insert(--dragged_item_index, item);
      list_states[dragged_list_index]
          .item_states
          .insert(dragged_item_index, item_state);
    });
  }

  void move_list_right(){
    setState(() {
      var list = widget.lists[dragged_list_index];
      var list_state = list_states[dragged_list_index];
      widget.lists.removeAt(dragged_list_index);
      list_states.removeAt(dragged_list_index);
      dragged_list_index++;
      widget.lists.insert(dragged_list_index, list);
      list_states.insert(dragged_list_index, list_state);
      can_drag = false;
      if (_boardViewController != null && _boardViewController.hasClients) {
        int temp_list_index = dragged_list_index;
        _boardViewController
            .animateTo(dragged_list_index * width,
            duration: new Duration(milliseconds: 400), curve: Curves.ease)
            .whenComplete(() {
          RenderBox object =
          list_states[temp_list_index].context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          left_list_x = pos.dx;
          right_list_x = pos.dx + object.size.width;
          Future.delayed(new Duration(milliseconds: 300), () {
            can_drag = true;
          });
        });
      }
    });
  }

  void move_right() {
    setState(() {
      var item = widget.lists[dragged_list_index].items[dragged_item_index];
      var item_state =
          list_states[dragged_list_index].item_states[dragged_item_index];
      list_states[dragged_list_index].setState(() {
        widget.lists[dragged_list_index].items.removeAt(dragged_item_index);
        list_states[dragged_list_index]
            .item_states
            .removeAt(dragged_item_index);
      });
      dragged_list_index++;
      list_states[dragged_list_index].setState(() {
        double closest_value = 10000;
        for (int i = 0;
            i < list_states[dragged_list_index].item_states.length;
            i++) {
          if (list_states[dragged_list_index].item_states[i].context != null) {
            RenderBox box = list_states[dragged_list_index]
                .item_states[i]
                .context
                .findRenderObject();
            Offset pos = box.localToGlobal(Offset.zero);
            var temp = (pos.dy - dy + (box.size.height / 2)).abs();
            if (temp < closest_value) {
              closest_value = temp;
              dragged_item_index = i;
              dy_init = dy;
            }
          }
        }
        widget.lists[dragged_list_index].items.insert(dragged_item_index, item);
        list_states[dragged_list_index]
            .item_states
            .insert(dragged_item_index, item_state);
        can_drag = false;
      });
      if (_boardViewController != null && _boardViewController.hasClients) {
        int temp_list_index = dragged_list_index;
        int temp_item_index = dragged_item_index;
        _boardViewController
            .animateTo(dragged_list_index * width,
                duration: new Duration(milliseconds: 400), curve: Curves.ease)
            .whenComplete(() {
          RenderBox object =
              list_states[temp_list_index].context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          left_list_x = pos.dx;
          right_list_x = pos.dx + object.size.width;
          RenderBox box =
          list_states[temp_list_index].item_states[temp_item_index].context.findRenderObject();
          Offset item_pos = box.localToGlobal(Offset.zero);
          top_item_y = item_pos.dy;
          bottom_item_y = item_pos.dy + box.size.height;
          Future.delayed(new Duration(milliseconds: 300), () {
            can_drag = true;
          });
        });
      }
    });
  }

  void move_list_left(){
    setState(() {
      var list = widget.lists[dragged_list_index];
      var list_state = list_states[dragged_list_index];
      widget.lists.removeAt(dragged_list_index);
      list_states.removeAt(dragged_list_index);
      dragged_list_index--;
      widget.lists.insert(dragged_list_index, list);
      list_states.insert(dragged_list_index, list_state);
      can_drag = false;
      if (_boardViewController != null && _boardViewController.hasClients) {
        int temp_list_index = dragged_list_index;
        _boardViewController
            .animateTo(dragged_list_index * width,
            duration: new Duration(milliseconds: 400), curve: Curves.ease)
            .whenComplete(() {
          RenderBox object =
          list_states[temp_list_index].context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          left_list_x = pos.dx;
          right_list_x = pos.dx + object.size.width;
          Future.delayed(new Duration(milliseconds: 300), () {
            can_drag = true;
          });
        });
      }
    });
  }

  void move_left() {
    setState(() {
      var item = widget.lists[dragged_list_index].items[dragged_item_index];
      var item_state =
          list_states[dragged_list_index].item_states[dragged_item_index];
      list_states[dragged_list_index].setState(() {
        widget.lists[dragged_list_index].items.removeAt(dragged_item_index);
        list_states[dragged_list_index]
            .item_states
            .removeAt(dragged_item_index);
      });
      dragged_list_index--;
      list_states[dragged_list_index].setState(() {
        double closest_value = 10000;
        for (int i = 0;
            i < list_states[dragged_list_index].item_states.length;
            i++) {
          if (list_states[dragged_list_index].item_states[i].context != null) {
            RenderBox box = list_states[dragged_list_index]
                .item_states[i]
                .context
                .findRenderObject();
            Offset pos = box.localToGlobal(Offset.zero);
            var temp = (pos.dy - dy + (box.size.height / 2)).abs();
            if (temp < closest_value) {
              closest_value = temp;
              dragged_item_index = i;
              dy_init = dy;
            }
          }
        }
        widget.lists[dragged_list_index].items.insert(dragged_item_index, item);
        list_states[dragged_list_index]
            .item_states
            .insert(dragged_item_index, item_state);
        can_drag = false;
      });
      if (_boardViewController != null && _boardViewController.hasClients) {
        int temp_list_index = dragged_list_index;
        int temp_item_index = dragged_item_index;
        _boardViewController
            .animateTo(dragged_list_index * width,
                duration: new Duration(milliseconds: 400), curve: Curves.ease)
            .whenComplete(() {
          RenderBox object =
              list_states[temp_list_index].context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          left_list_x = pos.dx;
          right_list_x = pos.dx + object.size.width;
          RenderBox box =
          list_states[temp_list_index].item_states[temp_item_index].context.findRenderObject();
          Offset item_pos = box.localToGlobal(Offset.zero);
          top_item_y = item_pos.dy;
          bottom_item_y = item_pos.dy + box.size.height;
          Future.delayed(new Duration(milliseconds: 300), () {
            can_drag = true;
          });
        });
      } else {
        print("eh");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack_widgets = <Widget>[
      ListView.builder(
        itemCount: widget.lists.length,
        scrollDirection: Axis.horizontal,
        controller: _boardViewController,
        itemBuilder: (BuildContext context, int index) {
          if (widget.lists[index].boardView == null) {
            widget.lists[index] = BoardList(
              items: widget.lists[index].items,
              headerBackgroundColor: widget.lists[index].headerBackgroundColor,
              backgroundColor: widget.lists[index].backgroundColor,
              footer: widget.lists[index].footer,
              header: widget.lists[index].header,
              boardView: this,
            );
          }
          if (widget.lists[index].index != index) {
            widget.lists[index] = BoardList(
              items: widget.lists[index].items,
              headerBackgroundColor: widget.lists[index].headerBackgroundColor,
              backgroundColor: widget.lists[index].backgroundColor,
              footer: widget.lists[index].footer,
              header: widget.lists[index].header,
              boardView: this,
              index: index,
            );
          }
          var temp = Container(
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[Expanded(child: widget.lists[index])],
              ));
          if (dragged_list_index == index && dragged_item_index == null) {
            return Opacity(
              opacity: 0.0,
              child: temp,
            );
          } else {
            return temp;
          }
        },
      )
    ];

    if (initial_x != null &&
        initial_y != null &&
        offset_x != null &&
        offset_y != null &&
        dx != null &&
        dy != null &&
        height != null &&
        width != null) {
      if (can_drag && dx_init != null && dy_init != null) {
        if (dragged_item_index != null && dragged_item != null && top_item_y != null && bottom_item_y != null) {
          //dragging item
          if (0 <= dragged_list_index - 1 && dx < left_list_x + 45) {
            //scroll left
            if (_boardViewController != null &&
                _boardViewController.hasClients) {
              _boardViewController.animateTo(
                  _boardViewController.position.pixels - 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              RenderBox object =
                  list_states[dragged_list_index].context.findRenderObject();
              Offset pos = object.localToGlobal(Offset.zero);
              left_list_x = pos.dx;
              right_list_x = pos.dx + object.size.width;
            }
          }
          if (widget.lists.length > dragged_list_index + 1 &&
              dx > right_list_x - 45) {
            //scroll right
            if (_boardViewController != null &&
                _boardViewController.hasClients) {
              _boardViewController.animateTo(
                  _boardViewController.position.pixels + 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              RenderBox object =
              list_states[dragged_list_index].context.findRenderObject();
              Offset pos = object.localToGlobal(Offset.zero);
              left_list_x = pos.dx;
              right_list_x = pos.dx + object.size.width;
            }
          }
          if (0 <= dragged_list_index - 1 && dx < left_list_x) {
            //move left
            move_left();
          }
          if (widget.lists.length > dragged_list_index + 1 &&
              dx > right_list_x) {
            //move right
            move_right();
          }
          if (0 <= dragged_item_index - 1 &&
              dy < top_list_y + 70){
            //scroll up
            if (list_states[dragged_list_index].boardListController != null &&
                list_states[dragged_list_index].boardListController.hasClients) {
              list_states[dragged_list_index].boardListController.animateTo(
                  list_states[dragged_list_index].boardListController.position.pixels - 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              top_item_y += 5;
              bottom_item_y += 5;
            }
          }
          if (0 <= dragged_item_index - 1 &&
              dy <
                  top_item_y -
                      list_states[dragged_list_index]
                              .item_states[dragged_item_index - 1]
                              .height /
                          2) {
            //move up
            move_up();
          }
          if (widget.lists[dragged_list_index].items.length >
              dragged_item_index + 1 &&
              dy > bottom_list_y - 70){
            //scroll down
            if (list_states[dragged_list_index].boardListController != null &&
                list_states[dragged_list_index].boardListController.hasClients) {
              list_states[dragged_list_index].boardListController.animateTo(
                  list_states[dragged_list_index].boardListController.position.pixels + 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              top_item_y -= 5;
              bottom_item_y -= 5;
            }
          }
          if (widget.lists[dragged_list_index].items.length >
                  dragged_item_index + 1 &&
              dy >
                  bottom_item_y +
                      list_states[dragged_list_index]
                              .item_states[dragged_item_index + 1]
                              .height /
                          2) {
            //move down
            move_down();
          }
        } else {
          //dragging list
          if (0 <= dragged_list_index - 1 && dx < left_list_x + 45) {
            //scroll left
            if (_boardViewController != null &&
                _boardViewController.hasClients) {
              _boardViewController.animateTo(
                  _boardViewController.position.pixels - 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              left_list_x += 5;
              right_list_x += 5;
            }
          }

          if (widget.lists.length > dragged_list_index + 1 &&
              dx > right_list_x - 45) {
            //scroll right
            if (_boardViewController != null &&
                _boardViewController.hasClients) {
              _boardViewController.animateTo(
                  _boardViewController.position.pixels + 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              left_list_x -= 5;
              right_list_x -= 5;
            }
          }
          if (widget.lists.length > dragged_list_index + 1 &&
              dx  > right_list_x) {
            //move right
            move_list_right();
          }
          if (0 <= dragged_list_index - 1 && dx < left_list_x) {
            //move left
            move_list_left();
          }
        }

      }
      stack_widgets.add(Positioned(
        width: width,
        height: height,
        child: dragged_item,
        left: (dx - offset_x) + initial_x,
        top: (dy - offset_y) + initial_y,
      ));
    }

    return Container(
        child: Listener(
            onPointerMove: (opm) {
              if (dragged_item != null) {
                setState(() {
                  if (dx_init == null) {
                    dx_init = opm.position.dx;
                  }
                  if (dy_init == null) {
                    dy_init = opm.position.dy;
                  }
                  dx = opm.position.dx;
                  dy = opm.position.dy;
                });
              }
            },
            onPointerDown: (opd) {
              setState(() {
                RenderBox box = context.findRenderObject();
                Offset pos = box.localToGlobal(opd.position);
                offset_x = pos.dx;
                offset_y = pos.dy;
              });
            },
            onPointerUp: (opu) {
              setState(() {
                if (on_drop_item != null) {
                  on_drop_item(dragged_list_index, dragged_item_index);
                }
                if (on_drop_list != null) {
                  on_drop_list(dragged_list_index);
                }
                dragged_item = null;
                offset_x = null;
                offset_y = null;
                initial_x = null;
                initial_y = null;
                dx = null;
                dy = null;
                dragged_item_index = null;
                dragged_list_index = null;
                on_drop_item = null;
                on_drop_list = null;
                dx_init = null;
                dy_init = null;
                left_list_x = null;
                right_list_x = null;
                top_list_y = null;
                bottom_list_y = null;
                top_item_y = null;
                bottom_item_y = null;
              });
            },
            child: new Stack(
              children: stack_widgets,
            )));
  }
}
