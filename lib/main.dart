import 'package:flutter/material.dart';
import 'package:gpt_schedules/cubits/screen/screen_cubit.dart';
import 'package:gpt_schedules/widgets/my_error.dart';
import 'package:gpt_schedules/widgets/my_init.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/my_home_page.dart';


void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Расписание занятий',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: BlocProvider(
        create: (_) => ScreenCubit(),
        child: BlocBuilder<ScreenCubit, ScreenState>(
          builder: (context, state) {
            if (state.runtimeType == ScreenInitial){
              return const MyInit();
            }
            if (state.runtimeType == ScreenSelectView){
              return MyHomePage(
                title: 'Расписание Занятий',
                listGroup: state.group!,
                listTeacher: state.teacher!,
              );
            }
            return const MyError();
          },
        )
      )
    );
  }
}


