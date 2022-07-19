import 'package:flutter/material.dart';

import 'package:gpt_schedules/cubits/screen/screen_cubit.dart';
import 'package:provider/src/provider.dart';

class MyError extends StatelessWidget {
  const MyError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание занятий'),
        leading: Image.asset('assets/img/logo.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Ошибка загрузки'),
            const Text('Проверите интернет соединение!'),
            ElevatedButton(
              onPressed: () {
                context.read<ScreenCubit>().reset();
              },
              child: const Text('Повтор загрузки'),
            )
          ],
        ),
      ),
    );
  }
}
