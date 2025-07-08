import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/board_controller.dart';
import 'package:boardview/board_callbacks.dart';
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
  
  // State for demonstrating callbacks
  bool _isScrolling = false;
  bool _isAnimating = false;
  bool _isDragging = false;
  String _lastAction = 'No actions yet';
  int _currentListIndex = 0;


  //Modern controller for better performance and features
  final BoardController boardController = BoardController();
  
  @override
  void initState() {
    super.initState();
    boardController.itemWidth = 300;
    _setupCallbacks();
  }
  
  /// Sets up callbacks to demonstrate the functionality
  void _setupCallbacks() {
    boardController.setCallbacks(BoardCallbacks(
      onScroll: (position, maxExtent) {
        final newIndex = (position / 300).round();
        if (newIndex != _currentListIndex) {
          setState(() {
            _currentListIndex = newIndex;
          });
        }
      },
      onScrollStateChanged: (isScrolling) {
        setState(() {
          _isScrolling = isScrolling;
          _lastAction = isScrolling ? 'Started scrolling' : 'Stopped scrolling';
        });
      },
      onAnimationStateChanged: (isAnimating) {
        setState(() {
          _isAnimating = isAnimating;
          _lastAction = isAnimating ? 'Animation started' : 'Animation completed';
        });
      },
      onDragStart: (listIndex, itemIndex) {
        setState(() {
          _isDragging = true;
          _lastAction = 'Started dragging item $itemIndex from list $listIndex';
        });
      },
      onDragEnd: (fromListIndex, fromItemIndex, toListIndex, toItemIndex) {
        setState(() {
          _isDragging = false;
          _lastAction = 'Moved item from list $fromListIndex to list $toListIndex';
        });
      },
      onDragCancel: (listIndex, itemIndex) {
        setState(() {
          _isDragging = false;
          _lastAction = 'Cancelled dragging item $itemIndex from list $listIndex';
        });
      },
      onItemReorder: (listIndex, fromIndex, toIndex) {
        setState(() {
          _lastAction = 'Reordered item in list $listIndex from $fromIndex to $toIndex';
        });
      },
      onItemMove: (fromListIndex, fromItemIndex, toListIndex, toItemIndex) {
        setState(() {
          _lastAction = 'Moved item from list $fromListIndex to list $toListIndex';
        });
      },
      onListReorder: (fromIndex, toIndex) {
        setState(() {
          _lastAction = 'Moved list from position $fromIndex to $toIndex';
        });
      },
      onError: (error, stackTrace) {
        setState(() {
          _lastAction = 'Error: $error';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      },
    ));
  }
  
  @override
  void dispose() {
    boardController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    List<BoardList> _lists = [];
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i]) as BoardList);
    }
    return Column(
      children: [
        // Status panel to show callback information
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border(bottom: BorderSide(color: Colors.blue[200]!)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _isDragging ? Colors.orange : _isAnimating ? Colors.green : _isScrolling ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isDragging ? 'Dragging' : _isAnimating ? 'Animating' : _isScrolling ? 'Scrolling' : 'Idle',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Current List: ${_currentListIndex + 1}'),
                ],
              ),
              SizedBox(height: 4),
              Text('Last Action: $_lastAction', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        // Control buttons to showcase modern controller features
        Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => boardController.animateToList(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentListIndex == 0 ? Colors.blue : null,
                ),
                child: Text('To Do'),
              ),
              ElevatedButton(
                onPressed: () => boardController.animateToList(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentListIndex == 1 ? Colors.blue : null,
                ),
                child: Text('In Progress'),
              ),
              ElevatedButton(
                onPressed: () => boardController.animateToList(2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentListIndex == 2 ? Colors.blue : null,
                ),
                child: Text('Done'),
              ),
            ],
          ),
        ),
        // Board view
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: BoardView(
              lists: _lists,
              boardController: boardController,
              width: 300,
              scrollbar: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
        onStartDragItem: (int? listIndex, int? itemIndex, BoardItemState? state) {
          // Notify the controller about the drag start
          boardController.notifyDragStart(listIndex!, itemIndex!);
        },
        onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
            int? oldItemIndex, BoardItemState? state) {
          //Used to update our local item data
          var item = _listData[oldListIndex!].items![oldItemIndex!];
          _listData[oldListIndex].items!.removeAt(oldItemIndex);
          _listData[listIndex!].items!.insert(itemIndex!, item);
          
          // Notify the controller about the drag end
          boardController.notifyDragEnd(oldListIndex, oldItemIndex, listIndex, itemIndex);
          
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
        
        // Notify the controller about the list reorder
        boardController.notifyListReorder(oldListIndex, listIndex);
        
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
