import 'package:cloud_firestore/cloud_firestore.dart';

class Candidate {
  final String id;
  final String name;
  final String profilePicture;
  final String title;
  final String summary;
  final String email;
  final String phone;
  final String location;
  final List<String> skills;
  final List<Education> education;
  final List<Experience> experience;
  final String resumeUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Candidate({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.title,
    required this.summary,
    required this.email,
    required this.phone,
    required this.location,
    required this.skills,
    required this.education,
    required this.experience,
    required this.resumeUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'].toString(),
      name: json['title']['rendered'] ?? '',
      profilePicture: json['acf']?['profile_picture'] ?? '',
      title: json['acf']?['professional_title'] ?? '',
      summary: json['content']['rendered'] ?? '',
      email: json['acf']?['email'] ?? '',
      phone: json['acf']?['phone'] ?? '',
      location: json['acf']?['location'] ?? '',
      skills: List<String>.from(json['acf']?['skills'] ?? []),
      education: (json['acf']?['education'] as List<dynamic>? ?? [])
          .map((e) => Education.fromJson(e))
          .toList(),
      experience: (json['acf']?['experience'] as List<dynamic>? ?? [])
          .map((e) => Experience.fromJson(e))
          .toList(),
      resumeUrl: json['acf']?['resume_url'] ?? '',
      createdAt: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['modified'] ?? DateTime.now().toIso8601String()),
    );
  }

  factory Candidate.fromFirestore(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      education: (json['education'] as List<dynamic>? ?? [])
          .map((e) => Education.fromFirestore(e))
          .toList(),
      experience: (json['experience'] as List<dynamic>? ?? [])
          .map((e) => Experience.fromFirestore(e))
          .toList(),
      resumeUrl: json['resumeUrl'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profilePicture': profilePicture,
      'title': title,
      'summary': summary,
      'email': email,
      'phone': phone,
      'location': location,
      'skills': skills,
      'education': education.map((e) => e.toJson()).toList(),
      'experience': experience.map((e) => e.toJson()).toList(),
      'resumeUrl': resumeUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Education {
  final String institution;
  final String degree;
  final String field;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;

  Education({
    required this.institution,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    required this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      institution: json['institution'] ?? '',
      degree: json['degree'] ?? '',
      field: json['field'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      description: json['description'] ?? '',
    );
  }

  factory Education.fromFirestore(Map<String, dynamic> json) {
    return Education(
      institution: json['institution'] ?? '',
      degree: json['degree'] ?? '',
      field: json['field'] ?? '',
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'field': field,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }
}

class Experience {
  final String company;
  final String position;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final List<String> responsibilities;

  Experience({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.responsibilities,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      description: json['description'] ?? '',
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
    );
  }

  factory Experience.fromFirestore(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      description: json['description'] ?? '',
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'responsibilities': responsibilities,
    };
  }
}
