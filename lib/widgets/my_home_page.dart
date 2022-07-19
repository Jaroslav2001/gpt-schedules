import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_schedules/api/api.dart';
import 'package:gpt_schedules/cubits/modal_schedules/modal_schedules_cubit.dart';
import 'package:table_calendar/table_calendar.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.listTeacher,
    required this.listGroup,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final List<Option> listGroup;
  final List<Option> listTeacher;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = 'https://guspoliteh.ru/studentu/raspisanie-zanyatiy/';
  CalendarFormat _calendarFormat = CalendarFormat.month;
  //DateTime _focusedDay = DateTime.now();
  late Option selectTeacher;
  late Option selectGroup;
  late DateTime _selectedDay;
  int? day;

  @override
  void initState() {
    selectTeacher = widget.listTeacher[0];
    selectGroup = widget.listGroup[0];
    _selectedDay = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: Image.asset('assets/img/logo.png'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              locale: 'ru_RU',
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Месяц',
                CalendarFormat.twoWeeks: '2 недели',
                CalendarFormat.week: 'Неделя',
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              // onPageChanged: (focusedDay) {
              //   _focusedDay = focusedDay;
              // },
            ),
            // Преподаватели
            Column(
              children: <Widget>[
                DropdownButton<Option>(
                  value: selectTeacher,
                  icon: const Icon(Icons.assignment_ind_outlined),
                  elevation: 16,
                  underline: Container(
                    height: 1.5,
                    color: Colors.black,
                  ),
                  onChanged: (Option? newValue) {
                    setState(() {
                      selectTeacher = newValue!;
                    });
                  },
                  items: widget.listTeacher
                      .map<DropdownMenuItem<Option>>((Option value) {
                    return DropdownMenuItem<Option>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await showViewSchedules(context,
                        FormPost(date: _selectedDay, option: selectTeacher),
                        1
                    );
                  },
                  child: const Text('Просмотр'),
                )
              ],
            ),
            // Студенты
            Column(
              children: <Widget>[
                DropdownButton<Option>(
                  value: selectGroup,
                  icon: const Icon(Icons.group),
                  elevation: 16,
                  underline: Container(
                    height: 1.5,
                    color: Colors.black,
                  ),
                  onChanged: (Option? newValue) {
                    setState(() {
                      selectGroup = newValue!;
                    });
                  },
                  items: widget.listGroup
                      .map<DropdownMenuItem<Option>>((Option value) {
                    return DropdownMenuItem<Option>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await showViewSchedules(context,
                        FormPost(date: _selectedDay, option: selectGroup),
                        2
                    );
                  },
                  child: const Text('Просмотр'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<Text> getListText(List<String> content){
  List<Text> result = [];
  for (var element in content) {
    result.add(Text(element));
  }
  return result;
}

Future showViewSchedules(BuildContext context,
    FormPost formPost, int modal) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
            child: Column(
              children: [
                Text(
                    '${formPost.date.day}-'
                        '${formPost.date.month}-'
                        '${formPost.date.year}'
                ),
                Text(formPost.option.name)
              ],
            )),
        content: BlocProvider(
          create: (_) => ModalSchedulesCubit(),
          child: BlocBuilder<ModalSchedulesCubit, ModalSchedulesState>(
            builder: (context, state){
              if (state.runtimeType == ModalSchedulesInitial){
                context.read<ModalSchedulesCubit>().init(formPost, modal);
                return Column(
                  children: const [
                    CircularProgressIndicator(),
                  ],
                );
              }
              if(state.runtimeType == ModalSchedulesResult){
                return Column(
                  children: getListText(state.content),
                );
              }
              return Column(
                children: const [
                  Text('Ошибка запроса!')
                ],
              );
            },
          ),
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Закрыть окно'),
            ),
          ),
        ],
      );
    },
  );
}
