import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String title;
  final String description;
  final String companyId;
  final String companyName;
  final String companyLogo;
  final String location;
  final String employmentType;
  final String salary;
  final List<String> requirements;
  final List<String> responsibilities;
  final String applicationUrl;
  final DateTime expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.companyId,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.employmentType,
    required this.salary,
    required this.requirements,
    required this.responsibilities,
    required this.applicationUrl,
    required this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'].toString(),
      title: json['title']['rendered'] ?? '',
      description: json['content']['rendered'] ?? '',
      companyId: json['acf']?['company_id'] ?? '',
      companyName: json['acf']?['company_name'] ?? '',
      companyLogo: json['acf']?['company_logo'] ?? '',
      location: json['acf']?['location'] ?? '',
      employmentType: json['acf']?['employment_type'] ?? '',
      salary: json['acf']?['salary'] ?? '',
      requirements: List<String>.from(json['acf']?['requirements'] ?? []),
      responsibilities: List<String>.from(json['acf']?['responsibilities'] ?? []),
      applicationUrl: json['acf']?['application_url'] ?? '',
      expiryDate: DateTime.parse(json['acf']?['expiry_date'] ?? DateTime.now().add(const Duration(days: 30)).toIso8601String()),
      createdAt: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['modified'] ?? DateTime.now().toIso8601String()),
    );
  }

  factory Job.fromFirestore(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      companyId: json['companyId'] ?? '',
      companyName: json['companyName'] ?? '',
      companyLogo: json['companyLogo'] ?? '',
      location: json['location'] ?? '',
      employmentType: json['employmentType'] ?? '',
      salary: json['salary'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      applicationUrl: json['applicationUrl'] ?? '',
      expiryDate: (json['expiryDate'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'companyId': companyId,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'location': location,
      'employmentType': employmentType,
      'salary': salary,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'applicationUrl': applicationUrl,
      'expiryDate': expiryDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
