[![pub package](https://img.shields.io/pub/v/boardview.svg)](https://pub.dev/packages/boardview)

# Flutter BoardView
This is a custom widget that can create a draggable BoardView or also known as a kanban. The view can be reordered with drag and drop.

## Installation
Just add ``` boardview ``` to the ``` pubspec.yaml ``` file.

## Usage Example

To get started you can look inside the ``` /example``` folder. This package is broken into 3 core parts

![Example](https://github.com/jakebonk/FlutterBoardView/blob/master/images/example.gif?raw=true)

### BoardView

The BoardView class takes in a List of BoardLists. It can also take in a BoardViewController which is can be used to animate to positions in the BoardView

``` dart

BoardViewController boardViewController = new BoardViewController();

List<BoardList> _lists = List<BoardList>();

BoardView(
  lists: _lists,
  boardViewController: boardViewController,
);

```

### BoardList

The BoardList has several callback methods for when it is being dragged. The header item is a Row and expects a List<Widget> as its object. The header item on long press will begin the drag process for the BoardList.

``` dart

    BoardList(
      onStartDragList: (int listIndex) {
    
      },
      onTapList: (int listIndex) async {
    
      },
      onDropList: (int listIndex, int oldListIndex) {       
       
      },
      headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
      backgroundColor: Color.fromARGB(255, 235, 236, 240),
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "List Item",
                  style: TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );

```

### BoardItem

The BoardItem view has several callback methods that get called when dragging. A long press on the item field widget will begin the drag process.

``` dart

    BoardItem(
        onStartDragItem: (int listIndex, int itemIndex, BoardItemState state) {
        
        },
        onDropItem: (int listIndex, int itemIndex, int oldListIndex,
            int oldItemIndex, BoardItemState state) {
                      
        },
        onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {
        
        },
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Board Item"),
          ),
        )
    );

```
