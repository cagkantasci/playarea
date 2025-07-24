class ChecklistTemplate {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChecklistTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChecklistTemplate.fromJson(Map<String, dynamic> json) {
    return ChecklistTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ChecklistItem {
  final int id;
  final int templateId;
  final String text;
  final bool isRequired;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChecklistItem({
    required this.id,
    required this.templateId,
    required this.text,
    required this.isRequired,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'],
      templateId: json['template_id'],
      text: json['text'],
      isRequired: json['is_required'] == 1 || json['is_required'] == true,
      order: json['order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'template_id': templateId,
      'text': text,
      'is_required': isRequired,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
