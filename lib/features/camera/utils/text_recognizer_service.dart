import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptData {
  final double? amount;
  final DateTime? date;
  final String? merchant;

  ReceiptData({this.amount, this.date, this.merchant});
}

class TextRecognizerService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<ReceiptData> processImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    return _parseText(recognizedText);
  }

  ReceiptData _parseText(RecognizedText recognizedText) {
    double? amount;
    DateTime? date;
    String? merchant;

    final lines = recognizedText.text.split('\n');

    for (var line in lines) {
      // Amount detection
      final amountRegex = RegExp(r'\$?\d{1,5}\.\d{2}');
      final amountMatch = amountRegex.firstMatch(line);
      if (amountMatch != null) {
        final amountString = amountMatch.group(0)?.replaceAll(r'$', '');
        if (amountString != null) {
          final val = double.tryParse(amountString);
          if (val != null) {
            // Heuristic
            // Only update if amount is null OR we found "Total" keyword
            // OR if val is clearly larger (assuming total is largest)
            // But we must check nullability correctly
            if (line.toLowerCase().contains('total')) {
              amount = val;
            } else if (amount == null) {
              amount = val;
            } else if (val > amount) {
              amount = val;
            }
          }
        }
      }

      // Date detection
      final dateRegex = RegExp(r'\d{1,2}[/-]\d{1,2}[/-]\d{2,4}');
      final dateMatch = dateRegex.firstMatch(line);

      // We check date == null so we only take the first date found (usually at top)
      if (dateMatch != null && date == null) {
        try {
          final dateStr = dateMatch.group(0)!;
          final parts = dateStr.split(RegExp(r'[/-]'));
          if (parts.length == 3) {
            final month = int.parse(parts[0]);
            final day = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            final fullYear = year < 100 ? 2000 + year : year;
            date = DateTime(fullYear, month, day);
          }
        } catch (_) {}
      }

      if (merchant == null && line.trim().isNotEmpty && line.length < 30) {
        // Skip purely numeric lines for merchant
        if (!RegExp(r'^\d+$').hasMatch(line.trim())) {
          merchant = line.trim();
        }
      }
    }

    return ReceiptData(amount: amount, date: date, merchant: merchant);
  }

  void dispose() {
    _textRecognizer.close();
  }
}
