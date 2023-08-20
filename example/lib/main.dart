import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waiter/waiter.dart';
import 'package:waiter_example/sheet_show.dart';

import 'dialog_show.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: Colors.black, background: Colors.white),
      ),
      home: const WaiterTest(),
    );
  }
}

class WaiterTest extends StatefulWidget {
  const WaiterTest({super.key});

  @override
  State<WaiterTest> createState() => _WaiterTestState();
}

class _WaiterTestState extends State<WaiterTest> {
  WaiterController waiterController = WaiterController();

  ValueNotifier<double> progress = ValueNotifier<double>(0);
  ValueNotifier<int> currentNumberProgress = ValueNotifier<int>(0);
  ValueNotifier<int> totalNumberProgress = ValueNotifier<int>(0);
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return Waiter(
      controller: waiterController,
      onTry: (value) {
        switch (value) {
          case 'errorTag1':
            _showToast('onTry errorTag1');

            Future.delayed(const Duration(milliseconds: 2000), () {
              waiterController.hiddenLoading('errorTag1');
            });
            break;
        }
      },
      firstLoadShowLoading: false,
      progress: progress,
      currentNumberProgress: currentNumberProgress,
      totalNumberProgress: totalNumberProgress,
      onCancelProgress: (value) {
        _showToast('onCancelProgress');
        timer.cancel();
      },
      onDismissProgress: () {
        timer.cancel();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Waiter Example')),
        body: Center(
          child: Column(
            children: [
              _addButton('Show loading', () {
                waiterController.showLoading();

                Future.delayed(const Duration(milliseconds: 2000), () {
                  waiterController.hiddenLoading('tag');
                });
              }),
              _addButton('Show error', () {
                waiterController.showError('errorTag1');
              }),
              _addButton('Show progress', () async {
                totalNumberProgress.value = 1;
                currentNumberProgress.value = 1;

                waiterController.showProgress('progressTag1');

                int i = 0;
                timer = Timer.periodic(
                  const Duration(milliseconds: 30),
                  (Timer timer) {
                    progress.value = i.toDouble();
                    i++;
                    if (i == 101) {
                      timer.cancel();

                      Future.delayed(const Duration(milliseconds: 1000), () {
                        waiterController.hiddenProgress('progressTag1');
                      });
                    }
                  },
                );
              }),
              _addButton('Open sheet', () {
                _openSheet(context);
              }),
              _addButton('Open dialog', () {
                _openDialog(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addButton(String name, void Function() callback) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          onPressed: () => callback.call()),
    );
  }

  void _showToast(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_SHORT);
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        showDragHandle: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return const SheetShow();
        });
  }

  void _openDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const DialogShow();
        });
  }
}
