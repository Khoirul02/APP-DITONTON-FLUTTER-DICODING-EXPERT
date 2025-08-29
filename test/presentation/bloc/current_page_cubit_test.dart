import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/presentation/bloc/current_page_cubit.dart';
import 'package:flutter/material.dart';

void main() {
  late CurrentPageCubit cubit;

  setUp(() {
    cubit = CurrentPageCubit();
  });

  test('changeCurrentPage should emit new page', () {
    final newPage = Scaffold(body: Text('New Page'));
    cubit.changeCurrentPage(newPage);
    expect(cubit.state, newPage);
  });
}
