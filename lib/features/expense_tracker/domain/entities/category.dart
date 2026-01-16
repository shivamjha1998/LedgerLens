import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final int iconCode; // Store icon codepoint
  final int colorValue; // Store color integer

  const Category({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
  });

  @override
  List<Object> get props => [id, name, iconCode, colorValue];
}
