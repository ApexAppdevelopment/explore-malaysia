import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/company_model.dart';
import '../models/job_model.dart';
import '../models/candidate_model.dart';
import '../models/blog_post_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // WordPress API endpoints
  static const String _baseUrl = 'https://explorejobs.com.my/wp-json/wp/v2';
  static const String _companiesEndpoint = '$_baseUrl/companies';
  static const String _jobsEndpoint = '$_baseUrl/jobs';
  static const String _candidatesEndpoint = '$_baseUrl/candidates';
  static const String _postsEndpoint = '$_baseUrl/posts';

  // Companies
  Stream<List<Company>> streamCompanies() {
    return _firestore
        .collection('companies')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Company.fromFirestore(doc.data()))
            .toList());
  }

  Future<List<Company>> getCompanies() async {
    final snapshot = await _firestore.collection('companies').get();
    return snapshot.docs
        .map((doc) => Company.fromFirestore(doc.data()))
        .toList();
  }

  // Jobs
  Stream<List<Job>> streamJobs() {
    return _firestore
        .collection('jobs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Job.fromFirestore(doc.data())).toList());
  }

  Future<List<Job>> getJobs() async {
    final snapshot = await _firestore.collection('jobs').get();
    return snapshot.docs.map((doc) => Job.fromFirestore(doc.data())).toList();
  }

  // Candidates
  Stream<List<Candidate>> streamCandidates() {
    return _firestore
        .collection('candidates')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Candidate.fromFirestore(doc.data()))
            .toList());
  }

  Future<List<Candidate>> getCandidates() async {
    final snapshot = await _firestore.collection('candidates').get();
    return snapshot.docs
        .map((doc) => Candidate.fromFirestore(doc.data()))
        .toList();
  }

  // Blog Posts
  Stream<List<BlogPost>> streamBlogPosts() {
    return _firestore
        .collection('blog_posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BlogPost.fromFirestore(doc.data()))
            .toList());
  }

  Future<List<BlogPost>> getBlogPosts() async {
    final snapshot = await _firestore.collection('blog_posts').get();
    return snapshot.docs
        .map((doc) => BlogPost.fromFirestore(doc.data()))
        .toList();
  }

  // WordPress Sync Methods
  Future<void> syncCompanies() async {
    try {
      final response = await http.get(Uri.parse(_companiesEndpoint));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final batch = _firestore.batch();
        
        for (var item in data) {
          final company = Company.fromJson(item);
          final docRef = _firestore.collection('companies').doc(company.id);
          batch.set(docRef, company.toJson());
        }
        
        await batch.commit();
      }
    } catch (e) {
      print('Error syncing companies: $e');
    }
  }

  Future<void> syncJobs() async {
    try {
      final response = await http.get(Uri.parse(_jobsEndpoint));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final batch = _firestore.batch();
        
        for (var item in data) {
          final job = Job.fromJson(item);
          final docRef = _firestore.collection('jobs').doc(job.id);
          batch.set(docRef, job.toJson());
        }
        
        await batch.commit();
      }
    } catch (e) {
      print('Error syncing jobs: $e');
    }
  }

  Future<void> syncCandidates() async {
    try {
      final response = await http.get(Uri.parse(_candidatesEndpoint));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final batch = _firestore.batch();
        
        for (var item in data) {
          final candidate = Candidate.fromJson(item);
          final docRef = _firestore.collection('candidates').doc(candidate.id);
          batch.set(docRef, candidate.toJson());
        }
        
        await batch.commit();
      }
    } catch (e) {
      print('Error syncing candidates: $e');
    }
  }

  Future<void> syncBlogPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$_postsEndpoint?_embed'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final batch = _firestore.batch();
        
        for (var item in data) {
          final post = BlogPost.fromJson(item);
          final docRef = _firestore.collection('blog_posts').doc(post.id);
          batch.set(docRef, post.toJson());
        }
        
        await batch.commit();
      }
    } catch (e) {
      print('Error syncing blog posts: $e');
    }
  }

  // Sync all data
  Future<void> syncAllData() async {
    await Future.wait([
      syncCompanies(),
      syncJobs(),
      syncCandidates(),
      syncBlogPosts(),
    ]);
  }
}
