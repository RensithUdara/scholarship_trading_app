class AppConstants {
  // App Information
  static const String appName = 'Scholarship Marketplace';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Buy, Sell, and Auction Scholarships in Australia';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String scholarshipsCollection = 'scholarships';
  static const String transactionsCollection = 'transactions';
  static const String bidsCollection = 'bids';
  static const String reviewsCollection = 'reviews';
  static const String chatsCollection = 'chats';
  static const String reportsCollection = 'reports';
  static const String notificationsCollection = 'notifications';
  
  // Firebase Storage Paths
  static const String scholarshipImagesPath = 'scholarships';
  static const String scholarshipDocumentsPath = 'documents';
  static const String userAvatarsPath = 'avatars';
  static const String verificationDocumentsPath = 'verification';
  
  // User Roles
  static const String buyerRole = 'buyer';
  static const String sellerRole = 'seller';
  static const String adminRole = 'admin';
  
  // Scholarship Status
  static const String scholarshipPending = 'pending';
  static const String scholarshipApproved = 'approved';
  static const String scholarshipRejected = 'rejected';
  static const String scholarshipSold = 'sold';
  static const String scholarshipExpired = 'expired';
  
  // Transaction Status
  static const String transactionPending = 'pending';
  static const String transactionConfirmed = 'confirmed';
  static const String transactionCompleted = 'completed';
  static const String transactionFailed = 'failed';
  static const String transactionRefunded = 'refunded';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderProcessing = 'processing';
  static const String orderConfirmed = 'confirmed';
  static const String orderCompleted = 'completed';
  static const String orderCancelled = 'cancelled';
  
  // Report Status
  static const String reportOpen = 'open';
  static const String reportInvestigating = 'investigating';
  static const String reportResolved = 'resolved';
  static const String reportClosed = 'closed';
  
  // Notification Types
  static const String notificationBid = 'bid';
  static const String notificationOutbid = 'outbid';
  static const String notificationAuctionWon = 'auction_won';
  static const String notificationAuctionEnded = 'auction_ended';
  static const String notificationPaymentReceived = 'payment_received';
  static const String notificationOrderUpdate = 'order_update';
  static const String notificationMessage = 'message';
  static const String notificationReport = 'report';
  static const String notificationApproval = 'approval';
  
  // Commission and Fees
  static const double adminCommissionRate = 0.10; // 10%
  static const double sellerCommissionRate = 0.90; // 90%
  static const double stripeFeeRate = 0.029; // 2.9%
  static const double gstRate = 0.10; // 10% GST for Australia
  
  // Auction Settings
  static const int defaultAuctionDurationHours = 24;
  static const int minBidIncrementAUD = 10;
  static const int maxAuctionDurationDays = 30;
  static const int auctionExtensionMinutes = 10; // Extend auction if bid in last 10 mins
  
  // File Upload Limits
  static const int maxImageSizeMB = 10;
  static const int maxDocumentSizeMB = 50;
  static const int maxImagesPerScholarship = 5;
  static const int maxDocumentsPerScholarship = 3;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Chat Settings
  static const int maxMessageLength = 1000;
  static const int chatHistoryDays = 90;
  
  // Review Settings
  static const int minRating = 1;
  static const int maxRating = 5;
  static const int maxReviewLength = 500;
  
  // Search and Filter
  static const List<String> scholarshipCategories = [
    'Academic Excellence',
    'Sports',
    'Arts & Creative',
    'STEM',
    'Community Service',
    'Leadership',
    'Need-Based',
    'International Students',
    'Indigenous Students',
    'Disability Support',
    'Other',
  ];
  
  static const List<String> educationLevels = [
    'High School',
    'Undergraduate',
    'Postgraduate',
    'PhD',
    'Vocational',
    'Other',
  ];
  
  static const List<String> australianStates = [
    'All States',
    'New South Wales',
    'Victoria',
    'Queensland',
    'Western Australia',
    'South Australia',
    'Tasmania',
    'Northern Territory',
    'Australian Capital Territory',
  ];
  
  // Validation Rules
  static const int minScholarshipTitleLength = 10;
  static const int maxScholarshipTitleLength = 100;
  static const int minScholarshipDescriptionLength = 50;
  static const int maxScholarshipDescriptionLength = 2000;
  static const int minScholarshipValue = 100;
  static const int maxScholarshipValue = 100000;
  
  // Currency
  static const String currency = 'AUD';
  static const String currencySymbol = '\$';
  static const String countryCode = 'AU';
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  
  // Support and Contact
  static const String supportEmail = 'support@scholarshipmarketplace.com.au';
  static const String supportPhone = '+61 1300 123 456';
  static const String privacyPolicyUrl = 'https://scholarshipmarketplace.com.au/privacy';
  static const String termsOfServiceUrl = 'https://scholarshipmarketplace.com.au/terms';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/scholarshipmarketplace';
  static const String twitterUrl = 'https://twitter.com/scholarshipmp';
  static const String instagramUrl = 'https://instagram.com/scholarshipmarketplace';
  
  // Cache Durations (in minutes)
  static const int userDataCacheDuration = 30;
  static const int scholarshipCacheDuration = 15;
  static const int reportsCacheDuration = 60;
  
  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String generalError = 'Something went wrong. Please try again';
  static const String authenticationError = 'Authentication failed. Please login again';
  static const String permissionError = 'You don\'t have permission to perform this action';
  static const String validationError = 'Please check your input and try again';
  
  // Success Messages
  static const String scholarshipListedSuccess = 'Scholarship listed successfully!';
  static const String bidPlacedSuccess = 'Bid placed successfully!';
  static const String purchaseSuccess = 'Purchase completed successfully!';
  static const String reportSubmittedSuccess = 'Report submitted successfully!';
  static const String messagesentSuccess = 'Message sent successfully!';
  static const String reviewSubmittedSuccess = 'Review submitted successfully!';
}
