class Issue {
  final int id;
  final String title;
  final String description;
  final int machineId;
  final String? machineName;
  final int reportedBy;
  final String? reporterName;
  final String status;
  final String priority;
  final List<String> photos;
  final DateTime createdAt;
  final DateTime updatedAt;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.machineId,
    this.machineName,
    required this.reportedBy,
    this.reporterName,
    required this.status,
    required this.priority,
    this.photos = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      machineId: json['machine_id'],
      machineName: json['machine_name'],
      reportedBy: json['reported_by'],
      reporterName: json['reporter_name'],
      status: json['status'] ?? 'open',
      priority: json['priority'] ?? 'medium',
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'machine_id': machineId,
      'machine_name': machineName,
      'reported_by': reportedBy,
      'reporter_name': reporterName,
      'status': status,
      'priority': priority,
      'photos': photos,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isOpen => status == 'open';
  bool get isInProgress => status == 'in_progress';
  bool get isClosed => status == 'closed';
  
  bool get isHighPriority => priority == 'high';
  bool get isMediumPriority => priority == 'medium';
  bool get isLowPriority => priority == 'low';
}
