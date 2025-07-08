import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:boardview/boardview.dart';

import 'BoardItemObject.dart';
import 'BoardListObject.dart';

class BoardViewExample extends StatefulWidget {
  @override
  _BoardViewExampleState createState() => _BoardViewExampleState();
}

class _BoardViewExampleState extends State<BoardViewExample> {
  List<BoardListObject> _listData = [
    BoardListObject(title: "To Do", items: [
      BoardItemObject(title: "Task 1"),
      BoardItemObject(title: "Task 2"),
      BoardItemObject(title: "Task 3"),
    ]),
    BoardListObject(title: "In Progress", items: [
      BoardItemObject(title: "Task 4"),
      BoardItemObject(title: "Task 5"),
    ]),
    BoardListObject(title: "Done", items: [
      BoardItemObject(title: "Task 6"),
      BoardItemObject(title: "Task 7"),
      BoardItemObject(title: "Task 8"),
      BoardItemObject(title: "Task 9"),
    ])
  ];


  //Can be used to animate to different sections of the BoardView
  BoardViewController boardViewController = BoardViewController();



  @override
  Widget build(BuildContext context) {
    List<BoardList> _lists = [];
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i]) as BoardList);
    }
    return Container(
      color: Colors.grey[100],
      child: BoardView(
        lists: _lists,
        boardViewController: boardViewController,
        width: 300,
        scrollbar: true,
      ),
    );
  }

  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
        onStartDragItem: (int? listIndex, int? itemIndex, BoardItemState? state) {

        },
        onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
            int? oldItemIndex, BoardItemState? state) {
          //Used to update our local item data
          var item = _listData[oldListIndex!].items![oldItemIndex!];
          _listData[oldListIndex].items!.removeAt(oldItemIndex);
          _listData[listIndex!].items!.insert(itemIndex!, item);
          setState(() {}); // Update the UI
        },
        onTapItem: (int? listIndex, int? itemIndex, BoardItemState? state) async {

        },
        item: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              itemObject.title!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ));
  }

  Widget _createBoardList(BoardListObject list) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.items!.length; i++) {
      items.insert(i, buildBoardItem(list.items![i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int? listIndex) {

      },
      onTapList: (int? listIndex) async {

      },
      onDropList: (int? listIndex, int? oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex!];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex!, list);
        setState(() {}); // Update the UI
      },
      headerBackgroundColor: Colors.blue[100],
      backgroundColor: Colors.grey[50],
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ))),
      ],
      items: items,
    );
  }
}
