class ReminderModel {
  final String id;
  final String title;
  final String category; // 'service' | 'tax'
  final String vehicleName;
  final int? targetKm;
  final int? currentKm;
  final DateTime? dueDate;
  final String status; // 'critical', 'warning', 'safe'
  final String description;
  final bool isEnabled;

  const ReminderModel({
    required this.id,
    required this.title,
    required this.category,
    required this.vehicleName,
    this.targetKm,
    this.currentKm,
    this.dueDate,
    required this.status,
    required this.description,
    this.isEnabled = true,
  });

  ReminderModel copyWith({
    String? id,
    String? title,
    String? category,
    String? vehicleName,
    int? targetKm,
    int? currentKm,
    DateTime? dueDate,
    String? status,
    String? description,
    bool? isEnabled,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      vehicleName: vehicleName ?? this.vehicleName,
      targetKm: targetKm ?? this.targetKm,
      currentKm: currentKm ?? this.currentKm,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  int? get remainingKm {
    if (targetKm != null && currentKm != null) {
      return targetKm! - currentKm!;
    }
    return null;
  }

  int? get remainingDays {
    if (dueDate != null) {
      final now = DateTime.now();
      final difference = dueDate!.difference(now).inDays;
      return difference;
    }
    return null;
  }
}

class VehicleSummary {
  final String id;
  final String name;
  final String plateNumber;
  final int currentKm;
  final String type;
  final String lastServiceDate;

  const VehicleSummary({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.currentKm,
    required this.type,
    required this.lastServiceDate,
  });
}
