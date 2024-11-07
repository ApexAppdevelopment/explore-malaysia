import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final String location;
  final String website;
  final String email;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.location,
    required this.website,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'].toString(),
      name: json['title']['rendered'] ?? '',
      description: json['content']['rendered'] ?? '',
      logoUrl: json['acf']?['company_logo'] ?? '',
      location: json['acf']?['location'] ?? '',
      website: json['acf']?['website'] ?? '',
      email: json['acf']?['email'] ?? '',
      phone: json['acf']?['phone'] ?? '',
      createdAt: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['modified'] ?? DateTime.now().toIso8601String()),
    );
  }

  factory Company.fromFirestore(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      location: json['location'] ?? '',
      website: json['website'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'location': location,
      'website': website,
      'email': email,
      'phone': phone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
