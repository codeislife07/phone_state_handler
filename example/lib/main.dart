import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state_handler/phone_state_handler.dart';

main() {
  runApp(
    const MaterialApp(
      home: Example(),
    ),
  );
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  PhoneStateHandler status = PhoneStateHandler.nothing();
  bool granted = false;

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) setStream();
  }

  void setStream() {
    PhoneStateHandler.stream.listen((event) {
      setState(() {
        status = event;
      });
    });
  }

  IconData getIcons() {
    return switch (status.status) {
      PhoneStateHandlerStatus.NOTHING => Icons.clear,
      PhoneStateHandlerStatus.CALL_INCOMING => Icons.add_call,
      PhoneStateHandlerStatus.CALL_STARTED => Icons.call,
      PhoneStateHandlerStatus.CALL_ENDED => Icons.call_end,
    };
  }

  Color getColor() {
    return switch (status.status) {
      PhoneStateHandlerStatus.NOTHING ||
      PhoneStateHandlerStatus.CALL_ENDED =>
        Colors.red,
      PhoneStateHandlerStatus.CALL_INCOMING => Colors.green,
      PhoneStateHandlerStatus.CALL_STARTED => Colors.orange,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone State'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (Platform.isAndroid)
              MaterialButton(
                onPressed: !granted
                    ? () async {
                        bool temp = await requestPermission();
                        setState(() {
                          granted = temp;
                          if (granted) {
                            setStream();
                          }
                        });
                      }
                    : null,
                child: const Text('Request permission of Phone'),
              ),
            const Text(
              'Status of call',
              style: TextStyle(fontSize: 24),
            ),
            if (status.status == PhoneStateHandlerStatus.CALL_INCOMING ||
                status.status == PhoneStateHandlerStatus.CALL_STARTED)
              Text(
                'Number: ${status.number}',
                style: const TextStyle(fontSize: 24),
              ),
            Icon(
              getIcons(),
              color: getColor(),
              size: 80,
            )
          ],
        ),
      ),
    );
  }
}
