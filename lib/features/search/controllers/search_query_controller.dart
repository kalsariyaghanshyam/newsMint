import 'package:flutter/material.dart';

class SearchQueryController extends ChangeNotifier {
  String _query = '';

  String get query => _query;

  void setQuery(String val) {
    if (_query != val) {
      _query = val;
      notifyListeners();
    }
  }

  void clear() {
    if (_query.isNotEmpty) {
      _query = '';
      notifyListeners();
    }
  }
}
