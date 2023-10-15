import 'package:flutter/cupertino.dart';
import '../Models/history_model.dart';

class HistoryProvider with ChangeNotifier {
  final Map<String, HistoryModel> _viewedItems = {};

  Map<String, HistoryModel> get getHistoryItems {
    return _viewedItems;
  }
  void addOtoViewedItem(String productID) {
      _viewedItems.putIfAbsent(
        productID,
            () => HistoryModel(
          id: DateTime.now().toString(),
          productID: productID,
        ),
      );
      notifyListeners();
  }
  void clearHistory() {
    _viewedItems.clear();
    notifyListeners();
  }
}
