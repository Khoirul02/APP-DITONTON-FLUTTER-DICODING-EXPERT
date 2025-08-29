import 'package:bloc/bloc.dart';

class HeaderTitleCubit extends Cubit<String> {
  HeaderTitleCubit() : super('TV Show'); // default header

  void changeHeaderTitle(String header) {
    emit(header);
  }
}
