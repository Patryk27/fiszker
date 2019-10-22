import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

import 'crash/dump.dart';
import 'crash/header.dart';
import 'crash/icon.dart';
import 'crash/subhead.dart';

class AppCrashScreen extends StatelessWidget {
  final String dump;

  AppCrashScreen({
    @required this.dump,
  }) : assert(dump != null);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // User might try to go back to the application by pressing the "back" key (if on Android) - we forbid that, since
      // the previous screen might be in a particularly nasty, unusable state (it crashed for a reason, after all!)
      onWillPop: () async {
        return false;
      },

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: const Text('Fiszker'),
        ),

        body: Padding(
          padding: const EdgeInsets.all(DIALOG_PADDING),

          child: Column(
            children: [
              Expanded(
                flex: 2,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CrashIcon(),
                    const SizedBox(height: 25),
                    const CrashHeader(),
                    const SizedBox(height: 25),
                    const CrashSubhead(),
                  ],
                ),
              ),

              const Divider(height: 80),

              Expanded(
                child: CrashDump(
                  dump: dump,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
