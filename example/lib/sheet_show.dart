import 'package:flutter/material.dart';
import 'package:waiter/waiter.dart';

class SheetShow extends StatefulWidget {
  const SheetShow({super.key});

  @override
  State<SheetShow> createState() => _SheetShowState();
}

class _SheetShowState extends State<SheetShow> {
  WaiterController waiterController = WaiterController();
  GlobalKey mainKey = GlobalKey();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      waiterController.hiddenLoading("hiddenLoading");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: mainKey,
      child: Waiter(
        firstLoadShowLoading: true,
        mainKey: mainKey,
        controller: waiterController,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Send email'),
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
            ListTile(
              leading: Icon(Icons.accessibility_new),
              title: Text('Accessibility'),
            ),
          ],
        ),
      ),
    );
  }
}
