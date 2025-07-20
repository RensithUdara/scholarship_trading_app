import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../core/constants/app_constants.dart';

class ChatController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<Chat> _chats = [];
  Chat? _selectedChat;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  List<Chat> get chats => _chats;
  Chat? get selectedChat => _selectedChat;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load user chats
  Future<void> loadUserChats(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final snapshot = await _firebaseService.collection(AppConstants.chatsCollection)
          .where('participants', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      _chats = snapshot.docs
          .map((doc) => Chat.fromFirestore(doc))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load chats: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Create or get chat for scholarship
  Future<Chat?> createOrGetChat({
    required String scholarshipId,
    required String buyerId,
    required String sellerId,
  }) async {
    try {
      // Check if chat already exists
      final existingChatQuery = await _firebaseService.collection(AppConstants.chatsCollection)
          .where('scholarshipId', isEqualTo: scholarshipId)
          .where('buyerId', isEqualTo: buyerId)
          .where('sellerId', isEqualTo: sellerId)
          .get();

      if (existingChatQuery.docs.isNotEmpty) {
        return Chat.fromFirestore(existingChatQuery.docs.first);
      }

      // Create new chat
      final newChat = Chat(
        id: '', // Will be set by Firestore
        scholarshipId: scholarshipId,
        buyerId: buyerId,
        sellerId: sellerId,
        createdAt: DateTime.now(),
      );

      final docRef = await _firebaseService.collection(AppConstants.chatsCollection)
          .add(newChat.toFirestore());

      return newChat.copyWith(id: docRef.id);
    } catch (e) {
      _errorMessage = 'Failed to create chat: $e';
      return null;
    }
  }

  // Select chat and load messages
  Future<void> selectChat(String chatId) async {
    _selectedChat = null;
    _messages.clear();
    
    _setLoading(true);
    _clearError();

    try {
      // Load chat
      final chatDoc = await _firebaseService.collection(AppConstants.chatsCollection)
          .doc(chatId)
          .get();

      if (chatDoc.exists) {
        _selectedChat = Chat.fromFirestore(chatDoc);
        
        // Load messages
        await _loadChatMessages(chatId);
        
        // Listen to new messages
        _listenToMessages(chatId);
      }
    } catch (e) {
      _errorMessage = 'Failed to load chat: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load chat messages
  Future<void> _loadChatMessages(String chatId) async {
    try {
      final snapshot = await _firebaseService.collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      _messages = snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error loading chat messages: $e');
    }
  }

  // Listen to new messages
  void _listenToMessages(String chatId) {
    _firebaseService.collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final newMessage = ChatMessage.fromMap(
          snapshot.docs.first.id,
          snapshot.docs.first.data(),
        );
        
        // Add to messages if it's not already there
        if (_messages.isEmpty || _messages.first.id != newMessage.id) {
          _messages.insert(0, newMessage);
          notifyListeners();
        }
      }
    });
  }

  // Send message
  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? imageUrl,
  }) async {
    if (text.trim().isEmpty && imageUrl == null) return false;

    try {
      final message = ChatMessage(
        id: '', // Will be set by Firestore
        senderId: senderId,
        text: text.trim(),
        timestamp: DateTime.now(),
        imageUrl: imageUrl,
      );

      // Add message to subcollection
      await _firebaseService.collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());

      // Update chat's last message and timestamp
      await _firebaseService.collection(AppConstants.chatsCollection)
          .doc(chatId)
          .update({
        'lastMessage': message.toMap(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'unreadCount': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      _errorMessage = 'Failed to send message: $e';
      return false;
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      // Update unread count for the chat
      await _firebaseService.collection(AppConstants.chatsCollection)
          .doc(chatId)
          .update({'unreadCount': 0});

      // Mark individual messages as read (optional, for detailed tracking)
      final unreadMessages = await _firebaseService.collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: userId)
          .get();

      final batch = _firebaseService.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // Delete chat (admin only)
  Future<bool> deleteChat(String chatId) async {
    _setLoading(true);
    _clearError();

    try {
      // Delete all messages in the chat
      final messagesSnapshot = await _firebaseService.collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection('messages')
          .get();

      final batch = _firebaseService.batch();
      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete the chat document
      batch.delete(_firebaseService.collection(AppConstants.chatsCollection).doc(chatId));
      
      await batch.commit();

      // Remove from local list
      _chats.removeWhere((chat) => chat.id == chatId);
      
      if (_selectedChat?.id == chatId) {
        _selectedChat = null;
        _messages.clear();
      }

      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete chat: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get chat by ID
  Future<Chat?> getChatById(String chatId) async {
    try {
      final doc = await _firebaseService.collection(AppConstants.chatsCollection)
          .doc(chatId)
          .get();

      if (doc.exists) {
        return Chat.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      _errorMessage = 'Failed to get chat: $e';
      return null;
    }
  }

  // Search messages
  List<ChatMessage> searchMessages(String query) {
    if (query.trim().isEmpty) return _messages;
    
    return _messages.where((message) =>
      message.text.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Get unread message count for user
  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _firebaseService.collection(AppConstants.chatsCollection)
          .where('participants', arrayContains: userId)
          .where('unreadCount', isGreaterThan: 0)
          .get();

      int totalUnread = 0;
      for (var doc in snapshot.docs) {
        final chat = Chat.fromFirestore(doc);
        totalUnread += chat.unreadCount;
      }

      return totalUnread;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // Clear current chat selection
  void clearSelectedChat() {
    _selectedChat = null;
    _messages.clear();
    notifyListeners();
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

  @override
  void dispose() {
    // Cancel any active listeners
    super.dispose();
  }
}
