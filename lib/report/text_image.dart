import 'dart:typed_data';
import 'dart:ui' as ui;

/// A piece of text drawn with Flutter's own text engine (which shapes
/// Devanagari correctly) and saved as a picture. The `pdf` package cannot
/// shape Devanagari, so names and notes typed in Nepali go into the report
/// as pictures.
class TextPicture {
  const TextPicture(this.png, this.width, this.height);
  final Uint8List png;

  /// Size in PDF points.
  final double width;
  final double height;
}

typedef TextPictureRenderer = Future<TextPicture?> Function(
  String text,
  double fontSize,
  double maxWidth,
);

final _devanagari = RegExp(r'[ऀ-ॿ]');

bool needsPicture(String text) => _devanagari.hasMatch(text);

/// Draws [text] at [fontSize] points, wrapped at [maxWidth] points.
Future<TextPicture?> renderTextPicture(
  String text,
  double fontSize,
  double maxWidth,
) async {
  const scale = 3.0; // pixels per point, so print stays sharp
  final builder =
      ui.ParagraphBuilder(
          ui.ParagraphStyle(
            fontFamily: 'NotoSansDevanagari',
            fontSize: fontSize * scale,
            textDirection: ui.TextDirection.ltr,
          ),
        )
        ..pushStyle(
          ui.TextStyle(
            color: const ui.Color(0xFF000000),
            fontFamily: 'NotoSansDevanagari',
            fontSize: fontSize * scale,
          ),
        )
        ..addText(text);
  final paragraph = builder.build()
    ..layout(ui.ParagraphConstraints(width: maxWidth * scale));
  final w = paragraph.longestLine.ceil() + 2;
  final h = paragraph.height.ceil() + 2;
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawParagraph(paragraph, ui.Offset.zero);
  final image = await recorder.endRecording().toImage(w, h);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  if (data == null) return null;
  return TextPicture(data.buffer.asUint8List(), w / scale, h / scale);
}
