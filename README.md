# LedgerLens

**LedgerLens** is a smart, offline-first expense tracking application built with Flutter. It leverages on-device Machine Learning to simplify expense entry through receipt scanning.

## Features

- **Expense Tracking**: Log daily expenses with categories, amounts, and dates.
- **Smart Scan (OCR)**: Automatically extract expense details from receipt photos using Google ML Kit.
- **Data Visualization**: Interactive charts to visualize spending habits.
- **Offline Storage**: Secure, local data persistence using SQLite.
- **Modern UI**: Clean Material 3 design.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Database**: [sqflite](https://pub.dev/packages/sqflite)
- **ML & Camera**: 
  - [google_mlkit_text_recognition](https://pub.dev/packages/google_mlkit_text_recognition)
  - [camera](https://pub.dev/packages/camera)
- **Utilities**: [intl](https://pub.dev/packages/intl), [fl_chart](https://pub.dev/packages/fl_chart)

## Getting Started

### Prerequisites
- Flutter SDK (3.10.x or later)
- Dart SDK
- Android Studio / Xcode (for mobile emulation)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ledger_lens.git
   cd ledger_lens
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## Project Structure

- `lib/features/`: Feature-based architecture (e.g., `expense_tracker`, `core`).
- `lib/core/`: Shared utilities and database helpers.
- `test/`: Unit and widget tests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
