

import 'package:impo/src/models/calender/cell_item.dart';

class GirdItem {

  String? persianTitle;
  List<CellItem> cells = [];
  int indexOfLastDayOfMonth = 0;
  int indexSelect = 0;
  bool isCurrent = false;
  List currents = [];
//  GirdItem({this.persianTitle,this.cells,this.indexOfLastDayOfMonth,this.indexSelect,this.isCurrent});
//
//
//  GirdItem.fromJson(Map<String,dynamic> parsedJson){
//    persianTitle = parsedJson['persianTitle'];
//    cells = parsedJson['cells'];
//    indexOfLastDayOfMonth = parsedJson['indexOfLastDayOfMonth'];
//    indexSelect = parsedJson['indexSelect'];
//    isCurrent = parsedJson['isCurrent'];
//  }

   String getPersianTitle() {
    return persianTitle!;
  }

  void setPersianTitle(String persianTitle) {
    this.persianTitle = persianTitle;
  }

  List<CellItem> getCells() {
    return cells;
  }

  void setCells(List<CellItem> cells) {
    this.cells = cells;
  }

   int getIndexOfLastDayOfMonth() {
    return indexOfLastDayOfMonth;
  }

  void setIndexOfLastDayOfMonth(int indexOfLastDayOfMonth) {
    this.indexOfLastDayOfMonth = indexOfLastDayOfMonth;
  }

    int getIndexSelect() {
    return indexSelect;
  }

    void setIndexSelect(int indexSelect) {
    this.indexSelect = indexSelect;
  }

    bool getCurrent() {
    return isCurrent;
  }

  void setCurrent(bool current) {
    isCurrent = current;
  }

  List getCurrents() {
    return currents;
  }

  void setCurrents(List _currents) {
    currents = _currents;
  }



}