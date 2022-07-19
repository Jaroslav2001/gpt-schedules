import 'package:flutter/material.dart';

import 'package:gpt_schedules/cubits/screen/screen_cubit.dart';
import 'package:provider/src/provider.dart';

class MyInit extends StatelessWidget {
  const MyInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ScreenCubit>().init();
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/img/logo.png'),
        title: const Text('Загрузка Расписания!'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
              margin: const EdgeInsets.all(20),
                child: Image.asset(
                    'assets/img/logo.png',
                  width: 256,
                  height: 256,
                ),
            ),
            const CircularProgressIndicator(),
          ],
        )
      ),
    );
  }
}
