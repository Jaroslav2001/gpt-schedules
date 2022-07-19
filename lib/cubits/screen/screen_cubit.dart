import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../api/api.dart';

part 'screen_state.dart';

class ScreenCubit extends Cubit<ScreenState> {
  ScreenCubit() : super(ScreenInitial());

  Future<void> init() async {
    ContentGroup content = await getListSchedules();
    if(content.status == 200){
      emit(ScreenSelectView(
        group: content.group,
        teacher: content.teacher,
      ));
    }else{
      emit(ScreenError());
    }
  }

  Future<void> reset() async {
    emit(ScreenInitial());
  }

  Future<void> getSchedules(Option option) async{

  }
}
