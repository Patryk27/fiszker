import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:optional/optional.dart';

class CardSide extends StatelessWidget {
  /// Requested size of the widget.
  /// Actual widget might end up a bit smaller (due to the [text] being short), but it will never grow bigger.
  final Size size;

  /// Text to display.
  final String text;

  /// See: [_CardSizeLayout.textStyle]
  static const textStyle = const TextStyle(
    fontSize: 22,
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  /// See: [_CardSizeLayout.padding]
  static const padding = 15.0;

  CardSide({
    @required this.size,
    @required this.text,
  })
      : assert(size != null),
        assert(text != null);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 200),
      painter: _CardSizePainter(text, textStyle, padding),
    );
  }
}

class _CardSizePainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final double padding;

  /// Since laying this widget out is a quite expensive operation (we need to perform *at least* two text layouts and a
  /// few other operations), we keep a cache here.
  Optional<_CardSizeLayout> layout = const Optional.empty();

  _CardSizePainter(this.text, this.textStyle, this.padding);

  @override
  void paint(Canvas canvas, Size size) {
    final layout = _layout(size);

    _center(canvas, layout);
    _paintBackground(canvas, layout);
    _paintLineSeparators(canvas, layout);
    _paintLineTexts(canvas, layout);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  _CardSizeLayout _layout(Size size) {
    if (!layout.isPresent) {
      layout = Optional.of(
        _CardSizeLayout.build(text, textStyle, size, padding),
      );
    }

    return layout.value;
  }

  void _center(Canvas canvas, _CardSizeLayout layout) {
    canvas.translate(0, (layout.requestedSize.height - layout.actualSize.height) / 2.0);
  }

  void _paintBackground(Canvas canvas, _CardSizeLayout layout) {
    final paint = Paint()
      ..color = Colors.white;

    final rect = Rect.fromPoints(
      Offset(0, 0),
      Offset(layout.actualSize.width, layout.actualSize.height),
    );

    canvas.drawRect(rect, paint);
  }

  void _paintLineSeparators(Canvas canvas, _CardSizeLayout layout) {
    final paint = Paint()
      ..color = Color.fromARGB(25, 0, 0, 0)
      ..strokeWidth = 1;

    for (var i = 1; i < layout.lineCount; i += 1) {
      final lineY = i * layout.lineHeight;

      canvas.drawLine(
        Offset(0, lineY),
        Offset(layout.actualSize.width, lineY),
        paint,
      );
    }
  }

  void _paintLineTexts(Canvas canvas, _CardSizeLayout layout) {
    final x = layout.padding;
    final y = layout.lineHeight;

    layout.textPainter.paint(canvas, Offset(x, y));
  }
}

class _CardSizeLayout {
  String text;
  TextStyle textStyle;
  TextPainter textPainter;

  /// Average line-height of the text.
  ///
  /// This might be kinda tricky to accurately compute for non-european languages, but it's a best-effort value anyway.
  double lineHeight;

  /// Number of lines (after laying out [text] according to [actualSize]).
  int lineCount;

  /// Requested size of the entire widget.
  Size requestedSize;

  /// Actual size of the entire widget.
  ///
  /// It will usually be different than [requestedSize] (but not larger), because this value takes into account the
  /// [lineHeight] and [lineCount] properties.
  Size actualSize;

  /// Inner padding of the left and right side of the widget.
  ///
  /// We don't need no padding for the top and bottom, since they are always automatically separated by [lineHeight].
  double padding;

  static _CardSizeLayout build(String text, TextStyle textStyle, Size size, double padding) {
    RenderParagraph paragraph;

    // First things first: we need to see how the text lays itself out under current conditions (textStyle and size). It
    // might happen that user created a hell of a large flashcard that just won't fit in current container and so we
    // might be coerced to reduce the font size. It shouldn't happen often, but it might.
    while (true) {
      paragraph = RenderParagraph(
        TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      paragraph.layout(BoxConstraints(
        maxWidth: size.width - 2 * padding,
        minHeight: 0,
      ));

      // Case A: Paragraph fits the container - we're good!
      if (paragraph.getMaxIntrinsicHeight(size.width) <= size.height) {
        break;
      }

      // Case B: Paragraph doesn't fit the container, but we've already shrunk the font to a barely recognizable size;
      // at this point we just don't care anymore.
      if (textStyle.fontSize > 4.0) {
        break;
      }

      // Case C: Paragraph doesn't fit the container and we can still shrink the font a bit.
      textStyle = textStyle.copyWith(fontSize: textStyle.fontSize - 2.0);
    }

    // Compute the average line height
    final lineHeight = paragraph.getMaxIntrinsicHeight(double.maxFinite);

    // Compute the number of lines the text will occupy
    final lineCount = (paragraph.getMaxIntrinsicHeight(size.width - 2 * padding) / lineHeight).round() + 2;

    // Compute the actual widget's size
    final actualSize = Size(
      size.width,
      lineCount * lineHeight,
    );

    // Create the text painter
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: (actualSize.width - 2 * padding),
      maxWidth: (actualSize.width - 2 * padding),
    );

    return _CardSizeLayout()
      ..text = text
      ..textStyle = textStyle
      ..textPainter = textPainter
      ..lineHeight = lineHeight
      ..lineCount = lineCount
      ..requestedSize = size
      ..actualSize = actualSize
      ..padding = padding;
  }
}
