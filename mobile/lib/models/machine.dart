class Machine {
  final int id;
  final String name;
  final int categoryId;
  final String? categoryName;
  final String? description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Machine({
    required this.id,
    required this.name,
    required this.categoryId,
    this.categoryName,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      description: json['description'],
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'category_name': categoryName,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isActive => status == 'active';
  bool get isInactive => status == 'inactive';
  bool get isMaintenance => status == 'maintenance';
}
