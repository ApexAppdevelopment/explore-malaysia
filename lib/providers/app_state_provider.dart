import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/company_model.dart';
import '../models/job_model.dart';
import '../models/candidate_model.dart';
import '../models/blog_post_model.dart';

class AppStateProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  // Companies
  List<Company> _companies = [];
  List<Company> get companies => _companies;
  bool _loadingCompanies = false;
  bool get loadingCompanies => _loadingCompanies;

  // Jobs
  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;
  bool _loadingJobs = false;
  bool get loadingJobs => _loadingJobs;

  // Candidates
  List<Candidate> _candidates = [];
  List<Candidate> get candidates => _candidates;
  bool _loadingCandidates = false;
  bool get loadingCandidates => _loadingCandidates;

  // Blog Posts
  List<BlogPost> _blogPosts = [];
  List<BlogPost> get blogPosts => _blogPosts;
  bool _loadingBlogPosts = false;
  bool get loadingBlogPosts => _loadingBlogPosts;

  // Companies Methods
  Future<void> fetchCompanies() async {
    _loadingCompanies = true;
    notifyListeners();

    try {
      _companies = await _firebaseService.getCompanies();
    } catch (e) {
      print('Error fetching companies: $e');
    }

    _loadingCompanies = false;
    notifyListeners();
  }

  // Jobs Methods
  Future<void> fetchJobs() async {
    _loadingJobs = true;
    notifyListeners();

    try {
      _jobs = await _firebaseService.getJobs();
    } catch (e) {
      print('Error fetching jobs: $e');
    }

    _loadingJobs = false;
    notifyListeners();
  }

  // Candidates Methods
  Future<void> fetchCandidates() async {
    _loadingCandidates = true;
    notifyListeners();

    try {
      _candidates = await _firebaseService.getCandidates();
    } catch (e) {
      print('Error fetching candidates: $e');
    }

    _loadingCandidates = false;
    notifyListeners();
  }

  // Blog Posts Methods
  Future<void> fetchBlogPosts() async {
    _loadingBlogPosts = true;
    notifyListeners();

    try {
      _blogPosts = await _firebaseService.getBlogPosts();
    } catch (e) {
      print('Error fetching blog posts: $e');
    }

    _loadingBlogPosts = false;
    notifyListeners();
  }

  // Search Methods
  List<Job> searchJobs(String query) {
    return _jobs.where((job) {
      return job.title.toLowerCase().contains(query.toLowerCase()) ||
          job.description.toLowerCase().contains(query.toLowerCase()) ||
          job.companyName.toLowerCase().contains(query.toLowerCase()) ||
          job.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Company> searchCompanies(String query) {
    return _companies.where((company) {
      return company.name.toLowerCase().contains(query.toLowerCase()) ||
          company.description.toLowerCase().contains(query.toLowerCase()) ||
          company.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Candidate> searchCandidates(String query) {
    return _candidates.where((candidate) {
      return candidate.name.toLowerCase().contains(query.toLowerCase()) ||
          candidate.title.toLowerCase().contains(query.toLowerCase()) ||
          candidate.summary.toLowerCase().contains(query.toLowerCase()) ||
          candidate.location.toLowerCase().contains(query.toLowerCase()) ||
          candidate.skills.any((skill) =>
              skill.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  List<BlogPost> searchBlogPosts(String query) {
    return _blogPosts.where((post) {
      return post.title.toLowerCase().contains(query.toLowerCase()) ||
          post.content.toLowerCase().contains(query.toLowerCase()) ||
          post.excerpt.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Sync Methods
  Future<void> syncAllData() async {
    try {
      await _firebaseService.syncAllData();
      await Future.wait([
        fetchCompanies(),
        fetchJobs(),
        fetchCandidates(),
        fetchBlogPosts(),
      ]);
    } catch (e) {
      print('Error syncing all data: $e');
    }
  }
}
