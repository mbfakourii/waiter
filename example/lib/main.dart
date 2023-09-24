import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waiter/waiter.dart';
import 'package:waiter_example/dialog_show.dart';
import 'package:waiter_example/sheet_show.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
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
  Widget build(final BuildContext context) => Waiter(
        controller: waiterController,
        onTry: (final String value) {
          switch (value) {
            case 'errorTag1':
              _showToast('onTry errorTag1');

              Future<void>.delayed(const Duration(milliseconds: 2000), () {
                waiterController.hiddenLoading('errorTag1');
              });
          }
        },
        firstLoadShowLoading: false,
        progress: progress,
        currentNumberProgress: currentNumberProgress,
        totalNumberProgress: totalNumberProgress,
        onCancelProgress: (final String value) {
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
              children: <Widget>[
                _addButton('Show loading', () {
                  waiterController.showLoading();

                  Future<void>.delayed(const Duration(milliseconds: 2000), () {
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
                    (final Timer timer) {
                      progress.value = i.toDouble();
                      i++;
                      if (i == 101) {
                        timer.cancel();

                        Future<void>.delayed(const Duration(milliseconds: 1000),
                            () {
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

  Widget _addButton(final String name, final void Function() callback) =>
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: callback.call,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              name,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      );

  void _showToast(final String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_SHORT);
  }

  void _openSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      showDragHandle: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (final BuildContext context) => const SheetShow(),
    );
  }

  void _openDialog(final BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (final BuildContext context) => const DialogShow(),
    );
  }
}
