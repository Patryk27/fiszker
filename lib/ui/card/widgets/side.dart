import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CardSide extends StatelessWidget {
  final Size size;
  final String text;

  CardSide({
    @required this.size,
    @required this.text,
  })
      : assert(size != null),
        assert(text != null);

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontSize: 22,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
    );

    return CustomPaint(
      size: Size(300, 200),
      painter: _CardSizePainter(
        text: text,
        textStyle: textStyle,
      ),
    );
  }
}

// @todo this is a dirty proof of concept - refactor!
class _CardSizePainter extends CustomPainter {
  _CardSizePainter({
    @required this.text,
    @required this.textStyle,
  })
      : assert(text != null),
        assert(textStyle != null);

  final String text;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    renderParagraph.layout(BoxConstraints(
      maxWidth: size.width,
      minHeight: 0,
    ));

    final lineHeight = renderParagraph.getMaxIntrinsicHeight(double.maxFinite);
    final textLineCount = (renderParagraph.getMaxIntrinsicHeight(size.width) / lineHeight).round();

    var lineCount = (size.height / lineHeight).round();

    if ((lineCount % 2 == 0) ^ (textLineCount % 2 == 0)) {
      lineCount -= 1;
    }

    final actualHeight = lineCount * lineHeight;
    final heightDiff = size.height - actualHeight;

    canvas.translate(0, heightDiff / 2);

    final linePaint = Paint()
      ..color = Color.fromARGB(25, 0, 0, 0)
      ..strokeWidth = 1;

    final backgroundPaint = Paint()
      ..color = Colors.white;

    canvas.drawRect(
      Rect.fromPoints(
        Offset(0, 0),
        Offset(size.width, actualHeight),
      ),
      backgroundPaint,
    );

    for (var i = 1; i < lineCount; i += 1) {
      final lineY = i * lineHeight;

      canvas.drawLine(
        Offset(0, lineY),
        Offset(size.width, lineY),
        linePaint,
      );
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: size.width,
      maxWidth: size.width,
    );

    final middle = ((lineCount - textLineCount) / 2).round();
    final textY = middle * lineHeight;

    textPainter.paint(
      canvas,
      Offset(0, textY),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
