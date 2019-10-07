import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

class AppCrashScreen extends StatelessWidget {
  AppCrashScreen({
    @required this.errorMessage,
  }) : assert(errorMessage != null);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'W Fiszkerze wystąpił błąd, przez co nie może on kontynuować działania.',

                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Spróbuj uruchomić aplikację ponownie - jeśli błąd się powtórzy, śmiało pisz na: wychowaniec.patryk@gmail.com',

                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 80),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Błąd:',

                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    errorMessage,

                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
