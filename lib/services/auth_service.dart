import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodthread/models/user_model.dart';

class AuthService extends ChangeNotifier {
  // TODO: Re-enable Firebase after fixing initialization issues
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthService() {
    // TODO: Re-enable Firebase auth state listener
    // _auth.authStateChanges().listen(_onAuthStateChanged);
    
    // For now, just set a mock user to get past the loading screen
    _currentUser = UserModel(
      id: 'temp-user',
      createdAt: DateTime.now(),
      isAnonymous: true,
      lastActive: DateTime.now(),
    );
    notifyListeners();
  }

  // TODO: Re-enable Firebase methods after fixing initialization issues
  /*
  void _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _currentUser = UserModel.fromMap({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }
  */

  Future<UserModel?> signInAnonymously() async {
    // TODO: Re-enable Firebase sign in after fixing initialization issues
    try {
      _setLoading(true);
      
      // For now, just return the mock user
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      
      _currentUser = UserModel(
        id: 'temp-user',
        createdAt: DateTime.now(),
        isAnonymous: true,
        lastActive: DateTime.now(),
      );
      notifyListeners();
      return _currentUser;
      
      /*
      final credential = await _auth.signInAnonymously();
      final user = credential.user;
      
      if (user != null) {
        // Create user document
        final userModel = UserModel(
          id: user.uid,
          createdAt: DateTime.now(),
          isAnonymous: true,
          lastActive: DateTime.now(),
        );
        
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
        
        _currentUser = userModel;
        notifyListeners();
        return userModel;
      }
      */
    } catch (e) {
      debugPrint('Error signing in anonymously: $e');
    } finally {
      _setLoading(false);
    }
    return null;
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    // TODO: Re-enable Firebase sign in after fixing initialization issues
    try {
      _setLoading(true);
      
      // For now, just return the mock user
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      
      _currentUser = UserModel(
        id: 'temp-user',
        createdAt: DateTime.now(),
        isAnonymous: true,
        lastActive: DateTime.now(),
      );
      notifyListeners();
      return _currentUser;
      
      /*
      final credential = await _auth.signInInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user;
      if (user != null) {
        await _loadUserData(user.uid);
        return _currentUser;
      }
      */
    } catch (e) {
      debugPrint('Error signing in with email: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
    return null;
  }

  Future<UserModel?> signUpWithEmail(String email, String password, String username) async {
    try {
      _setLoading(true);
      
      // Demo signup - create user with provided info
      final userModel = UserModel(
        id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        username: username,
        createdAt: DateTime.now(),
        isAnonymous: false,
        lastActive: DateTime.now(),
      );
      
      _currentUser = userModel;
      notifyListeners();
      return userModel;
    } catch (e) {
      debugPrint('Error signing up with email: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  Future<void> updateProfile({String? username, String? avatar}) async {
    if (_currentUser == null) return;
    
    try {
      _currentUser = _currentUser!.copyWith(
        username: username ?? _currentUser!.username,
        avatar: avatar ?? _currentUser!.avatar,
      );
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
