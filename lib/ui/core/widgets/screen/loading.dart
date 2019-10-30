import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  /// Loading screen's title - visible in the application's navigation bar.
  final String title;

  /// Loading screen's message - visible in the application's body.
  final String message;

  /// When enabled, the entire widget will be wrapped inside a [Scaffold].
  final bool includeScaffold;

  const LoadingScreen({
    @required this.title,
    @required this.message,
    this.includeScaffold = true,
  })
      : assert(title != null),
        assert(message != null),
        assert(includeScaffold != null);

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      title: Text(this.title),
    );

    final body = Padding(
      padding: const EdgeInsets.all(20),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(this.message),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );

    if (includeScaffold) {
      return Scaffold(
        appBar: appBar,
        body: body,
      );
    } else {
      return body;
    }
  }
}
