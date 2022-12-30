part of 'product.dart';

Sections sectionsFromJson(Map<String, dynamic> str) => Sections.fromJson(str);

class Sections {
  final bool error;
  final String message;
  final List<Section> result;

  const Sections({
    required this.error,
    required this.message,
    required this.result,
  });

  factory Sections.fromJson(Map<String, dynamic> json) => Sections(
        error: json['error'],
        message: json['message'],
        result: List.from(
          (json['result'] as List<Map<String, dynamic>>).map(Section.fromJson),
        ),
      );
}

class Section {
  final int id;
  final String categoryName;

  Section({required this.id, required this.categoryName});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      categoryName: json['name'],
    );
  }
}
