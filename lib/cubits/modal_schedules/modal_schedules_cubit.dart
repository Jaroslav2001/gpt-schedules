import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gpt_schedules/api/api.dart';

part 'modal_schedules_state.dart';


class ModalSchedulesCubit extends Cubit<ModalSchedulesState> {
  ModalSchedulesCubit() : super(const ModalSchedulesInitial());

  Future<void> init(FormPost formPost, int modal)async {
    ContentList content = await getSchedules(formPost, modal);
    if(content.status == 200){
      emit(ModalSchedulesResult(
        content.body
      ));
    }else{
      emit(const ModalSchedulesError());
    }
  }
}
