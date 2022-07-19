part of 'screen_cubit.dart';

abstract class ScreenState extends Equatable {
  List<Option>? teacher;
  List<Option>? group;
  String? content;

  @override
  List<Object> get props => [];
}

class ScreenInitial extends ScreenState {
  @override
  List<Object> get props => [];
}

class ScreenSelectView extends ScreenState {
  ScreenSelectView({
    required List<Option> teacher,
    required List<Option> group,
  }){
    this.group = group;
    this.teacher = teacher;
  }

  @override
  List<Object> get props => [teacher!, group!];
}

class ScreenLoader extends ScreenState {
  @override
  List<Object> get props => [];
}

class ScreenError extends ScreenState {
  @override
  List<Object> get props => [];
}

class ScreenResult extends ScreenState {
  @override
  List<Object> get props => [];
}
