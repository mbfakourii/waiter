import 'package:flutter/material.dart';
import 'package:waiter/waiter.dart';

class DialogShow extends StatefulWidget {
  const DialogShow({super.key});

  @override
  State<DialogShow> createState() => _DialogShowState();
}

class _DialogShowState extends State<DialogShow> {
  WaiterController waiterController = WaiterController();
  GlobalKey mainKey = GlobalKey();

  @override
  void initState() {
    Future<void>.delayed(const Duration(milliseconds: 2000), () {
      waiterController.hiddenLoading('hiddenLoading');
    });

    super.initState();
  }

  @override
  Widget build(final BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            width: double.maxFinite,
            child: Waiter(
              firstLoadShowLoading: true,
              mainKey: mainKey,
              controller: waiterController,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  key: mainKey,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Send email'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Call phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time_filled),
                      title: Text('Time'),
                    ),
                    ListTile(
                      leading: Icon(Icons.code),
                      title: Text('Code'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Icon(Icons.accessibility_new),
                        title: Text('Accessibility'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
