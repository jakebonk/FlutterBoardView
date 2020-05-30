class BoardItemObject{

  String title;

  BoardItemObject({this.title}){
    if(this.title == null){
      this.title = "";
    }
  }

}