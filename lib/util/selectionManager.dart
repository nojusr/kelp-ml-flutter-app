import 'package:flutter/material.dart';

class SelectionManager extends ChangeNotifier {
  List<String> selectedItemKeys = List<String>();
  bool selectionActive = false;

  bool checkIfSelected(String key) {
    if (this.selectedItemKeys.contains(key)) {
      return true;
    } else {
      return false;
    }
  }

  void addToSelection(String key) {
    if (this.selectedItemKeys.contains(key)) {
      return;
    } else {
      this.selectedItemKeys.add(key);
    }

    if (this.getSelectedAmount() > 0) {
      this.selectionActive = true;
      notifyListeners();
    }
  }

  void removeFromSelection(String key) {
    this.selectedItemKeys.removeWhere((item) => item == key);
    if (this.getSelectedAmount() <= 0) {
      this.selectionActive = false;
    }
    notifyListeners();
  }

  void clearSelection() {
    this.selectedItemKeys.clear();
    this.selectionActive = false;
    notifyListeners();
  }

  int getSelectedAmount() {
    return this.selectedItemKeys.length;
  }
}
