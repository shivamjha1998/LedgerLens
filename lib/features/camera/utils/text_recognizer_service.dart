import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptData {
  final double? amount;
  final DateTime? date;
  final String? merchant;

  ReceiptData({this.amount, this.date, this.merchant});
}

class TextRecognizerService {
  final _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.japanese,
  );

  Future<ReceiptData> processImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    return _parseText(recognizedText);
  }

  ReceiptData _parseText(RecognizedText recognizedText) {
    double? amount;
    DateTime? date;
    String? merchant;
    bool amountFoundViaKeyword = false;

    final lines = recognizedText.text.split('\n');

    for (var line in lines) {
      final text = line.trim();
      if (text.isEmpty) continue;

      // --- Amount Detection ---
      // Regex for currency: $10.50, ¥1000, 1,000
      final amountRegex = RegExp(r'[$¥￥]?\s*(\d{1,3}(,\d{3})*(\.\d+)?)\s*[円]?');

      final lowerText = text.toLowerCase();
      // Keywords
      final isTotalLine =
          lowerText.contains('total') ||
          text.contains('合計') ||
          text.contains('小計') ||
          text.contains('お支払');

      final isExcludedLine =
          lowerText.contains('change') ||
          lowerText.contains('cash') ||
          lowerText.contains('tender') ||
          text.contains('お釣り') ||
          text.contains('お預かり');

      final amountMatch = amountRegex.firstMatch(text);
      if (amountMatch != null) {
        String rawAmount = amountMatch.group(1)!;
        rawAmount = rawAmount.replaceAll(',', '');
        final val = double.tryParse(rawAmount);

        if (val != null) {
          if (isTotalLine) {
            amount = val;
            amountFoundViaKeyword = true;
          } else if (!amountFoundViaKeyword && !isExcludedLine) {
            if (amount == null || val > amount) {
              amount = val;
            }
          }
        }
      }

      // --- Date Detection ---
      final dateRegex = RegExp(r'(\d{4})[年/-](\d{1,2})[月/-](\d{1,2})[日]?');
      final usDateRegex = RegExp(r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})');

      if (date == null) {
        // Japanese/ISO YYYY-MM-DD
        final jpMatch = dateRegex.firstMatch(text);
        if (jpMatch != null) {
          try {
            final y = int.parse(jpMatch.group(1)!);
            final m = int.parse(jpMatch.group(2)!);
            final d = int.parse(jpMatch.group(3)!);
            date = DateTime(y, m, d);
          } catch (_) {}
        } else {
          // US/EU MM/DD/YYYY
          final usMatch = usDateRegex.firstMatch(text);
          if (usMatch != null) {
            try {
              final p1 = int.parse(usMatch.group(1)!);
              final p2 = int.parse(usMatch.group(2)!);
              final yRaw = int.parse(usMatch.group(3)!);
              final y = yRaw < 100 ? 2000 + yRaw : yRaw;
              if (p1 <= 12 && p2 <= 31) {
                date = DateTime(y, p1, p2);
              } else if (p2 <= 12 && p1 <= 31) {
                date = DateTime(y, p2, p1);
              }
            } catch (_) {}
          }
        }
      }

      // --- Merchant Detection ---
      if (merchant == null && text.length < 30) {
        if (!RegExp(r'^[\d,.\s¥￥]+$').hasMatch(text) &&
            !dateRegex.hasMatch(text) &&
            !usDateRegex.hasMatch(text)) {
          merchant = text;
        }
      }
    }

    return ReceiptData(amount: amount, date: date, merchant: merchant);
  }

  void dispose() {
    _textRecognizer.close();
  }
}
