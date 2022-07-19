part of 'modal_schedules_cubit.dart';

abstract class ModalSchedulesState extends Equatable {
  const ModalSchedulesState(this.content);

  final List<String> content;
}

class ModalSchedulesInitial extends ModalSchedulesState {
  const ModalSchedulesInitial() : super(const <String>['']);

  @override
  List<Object> get props => [];
}

class ModalSchedulesResult extends ModalSchedulesState {
  const ModalSchedulesResult(List<String> content) : super(content);

  @override
  List<Object> get props => [content];
}

class ModalSchedulesError extends ModalSchedulesState {
  const ModalSchedulesError() : super(const <String>['Ошибка!']);

  @override
  List<Object> get props => [content];
}
