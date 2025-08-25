import 'package:ditonton/presentation/pages/home_tv_show_page.dart';
import 'package:flutter/material.dart';

class CurrentPageNotifier extends ChangeNotifier {
  Widget _currentPage = HomeTvShowPage();
  Widget get currentPage => _currentPage;

  void changeCurrentPage(Widget page) async {
    _currentPage = page;
    notifyListeners();
  }
}
