import 'package:flutter/material.dart';

class ServiceRecord {
  final String id;
  final String jenisServis;
  final DateTime tanggal;
  final int kilometer;
  final int biaya;
  final String catatan;
  final IconData icon;

  ServiceRecord({
    required this.id,
    required this.jenisServis,
    required this.tanggal,
    required this.kilometer,
    required this.biaya,
    this.catatan = '',
    this.icon = Icons.build_outlined,
  });

  ServiceRecord copyWith({
    String? id,
    String? jenisServis,
    DateTime? tanggal,
    int? kilometer,
    int? biaya,
    String? catatan,
    IconData? icon,
  }) {
    return ServiceRecord(
      id: id ?? this.id,
      jenisServis: jenisServis ?? this.jenisServis,
      tanggal: tanggal ?? this.tanggal,
      kilometer: kilometer ?? this.kilometer,
      biaya: biaya ?? this.biaya,
      catatan: catatan ?? this.catatan,
      icon: icon ?? this.icon,
    );
  }
}
