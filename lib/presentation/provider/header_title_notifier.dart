import 'package:flutter/foundation.dart';

class HeaderTitleNotifier extends ChangeNotifier {
  String _headerTitle = 'TV Show';
  String get headerTitle => _headerTitle;

  void changeHeaderTitle(String header) async {
    _headerTitle = header;
    notifyListeners();
  }
}
