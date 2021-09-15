import 'board_item_object.dart';

class BoardListObject {
  String? title;
  List<BoardItemObject>? items;

  BoardListObject({this.title = '', this.items = const []});
}
