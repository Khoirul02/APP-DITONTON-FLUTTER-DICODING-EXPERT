import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/presentation/pages/home_tv_show_page.dart';

class CurrentPageCubit extends Cubit<Widget> {
  CurrentPageCubit() : super(HomeTvShowPage());

  void changeCurrentPage(Widget page) {
    emit(page);
  }
}
