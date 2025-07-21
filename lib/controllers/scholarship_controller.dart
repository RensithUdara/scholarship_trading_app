import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/scholarship.dart';
import '../models/scholarship_filter.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../core/constants/app_constants.dart';

class ScholarshipController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<Scholarship> _scholarships = [];
  List<Scholarship> _myScholarships = [];
  List<Scholarship> _filteredScholarships = [];
  Scholarship? _selectedScholarship;
  List<Bid> _scholarshipBids = [];
  List<Review> _scholarshipReviews = [];
  
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  
  // Filter properties
  String _selectedCategory = 'All Categories';
  String _selectedEducationLevel = 'All Levels';
  String _selectedState = 'All States';
  double _minPrice = 0;
  double _maxPrice = 100000;
  bool _showAuctionsOnly = false;
  bool _showFixedPriceOnly = false;
  String _sortBy = 'newest';

  // Getters
  List<Scholarship> get scholarships => _filteredScholarships;
  List<Scholarship> get myScholarships => _myScholarships;
  Scholarship? get selectedScholarship => _selectedScholarship;
  List<Bid> get scholarshipBids => _scholarshipBids;
  List<Review> get scholarshipReviews => _scholarshipReviews;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  
  // Filter getters
  String get selectedCategory => _selectedCategory;
  String get selectedEducationLevel => _selectedEducationLevel;
  String get selectedState => _selectedState;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  bool get showAuctionsOnly => _showAuctionsOnly;
  bool get showFixedPriceOnly => _showFixedPriceOnly;
  String get sortBy => _sortBy;

  // Load scholarships
  Future<void> loadScholarships({bool refresh = false}) async {
    if (refresh) {
      _scholarships.clear();
      _filteredScholarships.clear();
    }
    
    _setLoading(true);
    _clearError();

    try {
      Query query = _firebaseService.collection(AppConstants.scholarshipsCollection)
          .where('status', isEqualTo: AppConstants.scholarshipApproved);

      // Apply sorting
      switch (_sortBy) {
        case 'newest':
          query = query.orderBy('createdAt', descending: true);
          break;
        case 'oldest':
          query = query.orderBy('createdAt', descending: false);
          break;
        case 'price_low':
          query = query.orderBy('price', descending: false);
          break;
        case 'price_high':
          query = query.orderBy('price', descending: true);
          break;
        case 'popular':
          query = query.orderBy('viewCount', descending: true);
          break;
      }

      final snapshot = await query.limit(AppConstants.defaultPageSize).get();
      
      _scholarships = snapshot.docs
          .map((doc) => Scholarship.fromFirestore(doc))
          .toList();
      
      _applyFilters();
      
    } catch (e) {
      _errorMessage = 'Failed to load scholarships: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Search scholarships with query and filters
  Future<void> searchScholarships({
    String query = '',
    ScholarshipFilter? filter,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      Query firestoreQuery = _firebaseService.collection(AppConstants.scholarshipsCollection)
          .where('status', isEqualTo: AppConstants.scholarshipApproved);

      // Apply category filter
      if (filter?.category != null && filter!.category!.isNotEmpty) {
        firestoreQuery = firestoreQuery.where('category', isEqualTo: filter.category);
      }

      // Apply location filter
      if (filter?.location != null && filter!.location!.isNotEmpty) {
        firestoreQuery = firestoreQuery.where('location', isEqualTo: filter.location);
      }

      // Apply sorting
      String sortField = 'createdAt';
      bool descending = true;
      
      if (filter?.sortBy != null) {
        switch (filter!.sortBy) {
          case 'amount':
            sortField = 'price';
            descending = filter.sortOrder == 'desc';
            break;
          case 'deadline':
            sortField = 'applicationDeadline';
            descending = filter.sortOrder == 'desc';
            break;
          case 'title':
            sortField = 'title';
            descending = filter.sortOrder == 'desc';
            break;
          case 'viewCount':
            sortField = 'viewCount';
            descending = filter.sortOrder == 'desc';
            break;
          default:
            sortField = 'createdAt';
            descending = true;
        }
      }
      
      firestoreQuery = firestoreQuery.orderBy(sortField, descending: descending);

      final snapshot = await firestoreQuery.limit(100).get();
      
      List<Scholarship> results = snapshot.docs
          .map((doc) => Scholarship.fromFirestore(doc))
          .toList();

      // Apply client-side filters
      results = _applyClientSideFilters(results, query, filter);

      _scholarships = results;
      _filteredScholarships = results;
      
    } catch (e) {
      _errorMessage = 'Failed to search scholarships: $e';
      print('Search error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Apply filters that require client-side processing
  List<Scholarship> _applyClientSideFilters(
    List<Scholarship> scholarships,
    String query,
    ScholarshipFilter? filter,
  ) {
    List<Scholarship> filtered = [...scholarships];

    // Text search in title and description
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((scholarship) {
        final titleMatch = scholarship.title.toLowerCase().contains(lowerQuery);
        final descriptionMatch = scholarship.description.toLowerCase().contains(lowerQuery);
        final categoryMatch = scholarship.category.toLowerCase().contains(lowerQuery);
        return titleMatch || descriptionMatch || categoryMatch;
      }).toList();
    }

    // Amount range filter
    if (filter?.minAmount != null || filter?.maxAmount != null) {
      filtered = filtered.where((scholarship) {
        final amount = scholarship.price; // Use 'price' instead of 'amount'
        bool matchesMin = filter?.minAmount == null || amount >= filter!.minAmount!;
        bool matchesMax = filter?.maxAmount == null || amount <= filter!.maxAmount!;
        return matchesMin && matchesMax;
      }).toList();
    }

    // Deadline filters
    if (filter?.hasDeadlineSoon == true) {
      final weekFromNow = DateTime.now().add(const Duration(days: 7));
      filtered = filtered.where((scholarship) {
        return scholarship.applicationDeadline.isBefore(weekFromNow);
      }).toList();
    }

    if (filter?.deadlineAfter != null) {
      filtered = filtered.where((scholarship) {
        return scholarship.applicationDeadline.isAfter(filter!.deadlineAfter!);
      }).toList();
    }

    if (filter?.deadlineBefore != null) {
      filtered = filtered.where((scholarship) {
        return scholarship.applicationDeadline.isBefore(filter!.deadlineBefore!);
      }).toList();
    }

    return filtered;
  }

  // Load my scholarships (seller)
  Future<void> loadMyScholarships(String sellerId) async {
    _setLoading(true);
    _clearError();

    try {
      final snapshot = await _firebaseService.collection(AppConstants.scholarshipsCollection)
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('createdAt', descending: true)
          .get();
      
      _myScholarships = snapshot.docs
          .map((doc) => Scholarship.fromFirestore(doc))
          .toList();
      
    } catch (e) {
      _errorMessage = 'Failed to load your scholarships: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Create scholarship
  Future<bool> createScholarship({
    required String sellerId,
    required String title,
    required String description,
    required double price,
    required String category,
    required String educationLevel,
    required String state,
    required List<String> eligibilityCriteria,
    required String applicationProcess,
    required DateTime applicationDeadline,
    required bool isAuction,
    double? minimumBid,
    DateTime? auctionEndTime,
    List<XFile>? images,
    List<PlatformFile>? documents,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Upload images
      List<String> imageUrls = [];
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length && i < AppConstants.maxImagesPerScholarship; i++) {
          final imageBytes = await images[i].readAsBytes();
          final fileName = 'scholarship_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          final url = await _firebaseService.uploadFile(
            path: '${AppConstants.scholarshipImagesPath}/$sellerId',
            fileBytes: imageBytes,
            fileName: fileName,
          );
          imageUrls.add(url);
        }
      }

      // Upload documents
      List<String> documentUrls = [];
      if (documents != null && documents.isNotEmpty) {
        for (int i = 0; i < documents.length && i < AppConstants.maxDocumentsPerScholarship; i++) {
          final doc = documents[i];
          if (doc.bytes != null) {
            final fileName = 'document_${DateTime.now().millisecondsSinceEpoch}_${doc.name}';
            final url = await _firebaseService.uploadFile(
              path: '${AppConstants.scholarshipDocumentsPath}/$sellerId',
              fileBytes: doc.bytes!,
              fileName: fileName,
            );
            documentUrls.add(url);
          }
        }
      }

      // Create scholarship object
      final scholarship = Scholarship(
        id: '', // Will be set by Firestore
        sellerId: sellerId,
        title: title,
        description: description,
        price: price,
        imageUrls: imageUrls,
        documentUrls: documentUrls,
        isAuction: isAuction,
        minimumBid: minimumBid,
        auctionEndTime: auctionEndTime,
        category: category,
        educationLevel: educationLevel,
        state: state,
        eligibilityCriteria: eligibilityCriteria,
        applicationProcess: applicationProcess,
        applicationDeadline: applicationDeadline,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firebaseService.collection(AppConstants.scholarshipsCollection)
          .add(scholarship.toFirestore());

      // Reload scholarships
      await loadMyScholarships(sellerId);

      return true;
    } catch (e) {
      _errorMessage = 'Failed to create scholarship: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update scholarship
  Future<bool> updateScholarship(String scholarshipId, Map<String, dynamic> updates) async {
    _setLoading(true);
    _clearError();

    try {
      updates['updatedAt'] = Timestamp.now();
      
      await _firebaseService.collection(AppConstants.scholarshipsCollection)
          .doc(scholarshipId)
          .update(updates);

      // Update local data
      _updateLocalScholarship(scholarshipId, updates);

      return true;
    } catch (e) {
      _errorMessage = 'Failed to update scholarship: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete scholarship
  Future<bool> deleteScholarship(String scholarshipId) async {
    _setLoading(true);
    _clearError();

    try {
      // Get scholarship to delete associated files
      final scholarship = await getScholarshipById(scholarshipId);
      if (scholarship != null) {
        // Delete images
        for (String imageUrl in scholarship.imageUrls) {
          await _firebaseService.deleteFile(imageUrl);
        }
        
        // Delete documents
        for (String documentUrl in scholarship.documentUrls) {
          await _firebaseService.deleteFile(documentUrl);
        }
      }

      // Delete scholarship document
      await _firebaseService.collection(AppConstants.scholarshipsCollection)
          .doc(scholarshipId)
          .delete();

      // Remove from local data
      _scholarships.removeWhere((s) => s.id == scholarshipId);
      _myScholarships.removeWhere((s) => s.id == scholarshipId);
      _applyFilters();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete scholarship: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get scholarship by ID
  Future<Scholarship?> getScholarshipById(String scholarshipId) async {
    try {
      final doc = await _firebaseService.collection(AppConstants.scholarshipsCollection)
          .doc(scholarshipId)
          .get();
      
      if (doc.exists) {
        return Scholarship.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      _errorMessage = 'Failed to get scholarship: $e';
      return null;
    }
  }

  // Select scholarship and load details
  Future<void> selectScholarship(String scholarshipId) async {
    _selectedScholarship = null;
    _scholarshipBids.clear();
    _scholarshipReviews.clear();
    
    _setLoading(true);
    _clearError();

    try {
      // Load scholarship
      _selectedScholarship = await getScholarshipById(scholarshipId);
      
      if (_selectedScholarship != null) {
        // Increment view count
        await _firebaseService.collection(AppConstants.scholarshipsCollection)
            .doc(scholarshipId)
            .update({'viewCount': FieldValue.increment(1)});
        
        // Load bids if auction
        if (_selectedScholarship!.isAuction) {
          await _loadScholarshipBids(scholarshipId);
        }
        
        // Load reviews
        await _loadScholarshipReviews(scholarshipId);
      }
    } catch (e) {
      _errorMessage = 'Failed to load scholarship details: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load scholarship bids
  Future<void> _loadScholarshipBids(String scholarshipId) async {
    try {
      final snapshot = await _firebaseService.collection(AppConstants.bidsCollection)
          .where('scholarshipId', isEqualTo: scholarshipId)
          .where('isActive', isEqualTo: true)
          .orderBy('amount', descending: true)
          .get();
      
      _scholarshipBids = snapshot.docs
          .map((doc) => Bid.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error loading bids: $e');
    }
  }

  // Load scholarship reviews
  Future<void> _loadScholarshipReviews(String scholarshipId) async {
    try {
      final snapshot = await _firebaseService.collection(AppConstants.reviewsCollection)
          .where('scholarshipId', isEqualTo: scholarshipId)
          .where('isPublic', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .get();
      
      _scholarshipReviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error loading reviews: $e');
    }
  }

  // Place bid on auction
  Future<bool> placeBid({
    required String scholarshipId,
    required String bidderId,
    required double amount,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final batch = _firebaseService.batch();
      
      // Create bid
      final bidRef = _firebaseService.collection(AppConstants.bidsCollection).doc();
      final bid = Bid(
        id: bidRef.id,
        scholarshipId: scholarshipId,
        bidderId: bidderId,
        amount: amount,
        timestamp: DateTime.now(),
        isWinning: true,
      );
      batch.set(bidRef, bid.toFirestore());
      
      // Update scholarship current bid
      final scholarshipRef = _firebaseService.collection(AppConstants.scholarshipsCollection)
          .doc(scholarshipId);
      batch.update(scholarshipRef, {
        'currentBid': amount,
        'bidCount': FieldValue.increment(1),
        'updatedAt': Timestamp.now(),
      });
      
      // Mark previous bids as not winning
      final previousBids = await _firebaseService.collection(AppConstants.bidsCollection)
          .where('scholarshipId', isEqualTo: scholarshipId)
          .where('isWinning', isEqualTo: true)
          .get();
      
      for (var doc in previousBids.docs) {
        if (doc.id != bidRef.id) {
          batch.update(doc.reference, {'isWinning': false});
        }
      }
      
      await batch.commit();
      
      // Reload scholarship details
      await selectScholarship(scholarshipId);
      
      return true;
    } catch (e) {
      _errorMessage = 'Failed to place bid: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Apply filters
  void _applyFilters() {
    _filteredScholarships = _scholarships.where((scholarship) {
      // Category filter
      if (_selectedCategory != 'All Categories' && scholarship.category != _selectedCategory) {
        return false;
      }
      
      // Education level filter
      if (_selectedEducationLevel != 'All Levels' && scholarship.educationLevel != _selectedEducationLevel) {
        return false;
      }
      
      // State filter
      if (_selectedState != 'All States' && scholarship.state != _selectedState) {
        return false;
      }
      
      // Price filter
      final price = scholarship.currentPrice;
      if (price < _minPrice || price > _maxPrice) {
        return false;
      }
      
      // Auction/Fixed price filter
      if (_showAuctionsOnly && !scholarship.isAuction) {
        return false;
      }
      if (_showFixedPriceOnly && scholarship.isAuction) {
        return false;
      }
      
      return true;
    }).toList();
    
    notifyListeners();
  }

  // Update filters
  void updateFilters({
    String? category,
    String? educationLevel,
    String? state,
    double? minPrice,
    double? maxPrice,
    bool? showAuctionsOnly,
    bool? showFixedPriceOnly,
    String? sortBy,
  }) {
    _selectedCategory = category ?? _selectedCategory;
    _selectedEducationLevel = educationLevel ?? _selectedEducationLevel;
    _selectedState = state ?? _selectedState;
    _minPrice = minPrice ?? _minPrice;
    _maxPrice = maxPrice ?? _maxPrice;
    _showAuctionsOnly = showAuctionsOnly ?? _showAuctionsOnly;
    _showFixedPriceOnly = showFixedPriceOnly ?? _showFixedPriceOnly;
    _sortBy = sortBy ?? _sortBy;
    
    if (sortBy != null) {
      loadScholarships(refresh: true);
    } else {
      _applyFilters();
    }
  }

  // Clear filters
  void clearFilters() {
    _selectedCategory = 'All Categories';
    _selectedEducationLevel = 'All Levels';
    _selectedState = 'All States';
    _minPrice = 0;
    _maxPrice = 100000;
    _showAuctionsOnly = false;
    _showFixedPriceOnly = false;
    _sortBy = 'newest';
    
    _applyFilters();
  }

  // Update local scholarship data
  void _updateLocalScholarship(String scholarshipId, Map<String, dynamic> updates) {
    for (int i = 0; i < _scholarships.length; i++) {
      if (_scholarships[i].id == scholarshipId) {
        // Create updated scholarship (simplified update)
        _scholarships[i] = _scholarships[i].copyWith(
          status: updates['status'] ?? _scholarships[i].status,
        );
        break;
      }
    }
    
    for (int i = 0; i < _myScholarships.length; i++) {
      if (_myScholarships[i].id == scholarshipId) {
        _myScholarships[i] = _myScholarships[i].copyWith(
          status: updates['status'] ?? _myScholarships[i].status,
        );
        break;
      }
    }
    
    _applyFilters();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
