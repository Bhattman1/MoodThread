import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodthread/models/prompt_model.dart';
import 'package:moodthread/models/thread_response_model.dart';
import 'package:moodthread/models/user_model.dart';

class ThreadService {
  // TODO: Re-enable Firebase after fixing initialization issues
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get today's active prompt
  Future<PromptModel?> getTodayPrompt() async {
    try {
      // TODO: Re-enable Firebase query after fixing initialization issues
      /*
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final query = await _firestore
          .collection('prompts')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return PromptModel.fromMap({
          'id': query.docs.first.id,
          ...query.docs.first.data(),
        });
      }
      */
      
      // For now, return a mock prompt
      return PromptModel(
        id: 'demo_prompt_1',
        text: 'How are you feeling today?',
        date: DateTime.now(),
        isActive: true,
        responseCount: 0,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error getting today\'s prompt: $e');
      return null;
    }
  }

  // Check if user has already responded today
  Future<bool> hasUserRespondedToday(String userId, String promptId) async {
    try {
      // For demo purposes, always return false (user can respond)
      return false;
    } catch (e) {
      debugPrint('Error checking user response: $e');
      return false;
    }
  }

  // Submit user response
  Future<bool> submitResponse({
    required String userId,
    required String promptId,
    required String response,
    required bool isAnonymous,
    String? username,
    String? avatar,
  }) async {
    try {
      // For demo purposes, just return success
      // In a real app, this would save to Firebase
      return true;
    } catch (e) {
      debugPrint('Error submitting response: $e');
      return false;
    }
  }

  // Get thread responses for today's prompt
  Stream<List<ThreadResponseModel>> getTodayThreadStream(String promptId) {
    // For demo purposes, return a stream with sample responses
    return Stream.value([
      ThreadResponseModel(
        id: 'demo_response_1',
        userId: 'demo_user_1',
        promptId: promptId,
        response: "I'm feeling overwhelmed with work deadlines.",
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isAnonymous: true,
        username: null,
        avatar: null,
        sameCount: 2,
      ),
      ThreadResponseModel(
        id: 'demo_response_2',
        userId: 'demo_user_2',
        promptId: promptId,
        response: "Missing my family who lives far away.",
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        isAnonymous: true,
        username: null,
        avatar: null,
        sameCount: 1,
      ),
      ThreadResponseModel(
        id: 'demo_response_3',
        userId: 'demo_user_3',
        promptId: promptId,
        response: "Excited about a new project I'm starting.",
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        isAnonymous: true,
        username: null,
        avatar: null,
        sameCount: 0,
      ),
    ]);
  }

  // Get user's response for today
  Future<ThreadResponseModel?> getUserResponse(String userId, String promptId) async {
    try {
      // For demo purposes, return null (user hasn't responded yet)
      return null;
    } catch (e) {
      debugPrint('Error getting user response: $e');
      return null;
    }
  }

  // Add "same" reaction to a response
  Future<void> addSameReaction(String responseId) async {
    try {
      // For demo purposes, just print a message
      debugPrint('Same reaction added to response: $responseId');
    } catch (e) {
      debugPrint('Error adding same reaction: $e');
    }
  }

  // Get random prompt from pool (for testing/development)
  Future<PromptModel?> getRandomPrompt() async {
    try {
      // For demo purposes, return a random prompt from a list
      final prompts = [
        "What's weighing on you right now?",
        "What's keeping you going?",
        "What are you trying to accept?",
        "What do you wish someone knew?",
        "How would you describe today in one sentence?",
      ];
      
      final randomIndex = DateTime.now().millisecondsSinceEpoch % prompts.length;
      return PromptModel(
        id: 'demo_prompt_${DateTime.now().millisecondsSinceEpoch}',
        text: prompts[randomIndex],
        date: DateTime.now(),
        isActive: true,
        responseCount: 0,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error getting random prompt: $e');
      return null;
    }
  }
}
