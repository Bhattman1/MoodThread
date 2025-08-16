import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moodthread/services/auth_service.dart';
import 'package:moodthread/services/thread_service.dart';
import 'package:moodthread/models/prompt_model.dart';
import 'package:moodthread/models/thread_response_model.dart';
import 'package:moodthread/screens/thread_feed_screen.dart';
import 'package:moodthread/utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThreadService _threadService = ThreadService();
  PromptModel? _todayPrompt;
  ThreadResponseModel? _userResponse;
  bool _isLoading = true;
  bool _isSubmitting = false;
  DateTime? _nextPromptTime;

  @override
  void initState() {
    super.initState();
    _loadTodayPrompt();
    _calculateNextPromptTime();
  }

  void _calculateNextPromptTime() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    
    // Random time between 10 AM and 12 AM (midnight)
    final random = Random();
    final randomHour = 10 + random.nextInt(14); // 10 to 23 (10 AM to 11 PM)
    final randomMinute = random.nextInt(60);
    
    _nextPromptTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, randomHour, randomMinute);
  }

  Future<void> _loadTodayPrompt() async {
    setState(() => _isLoading = true);
    
    try {
      final prompt = await _threadService.getTodayPrompt();
      if (prompt != null) {
        setState(() => _todayPrompt = prompt);
        
        // Check if user has already responded
        final authService = context.read<AuthService>();
        if (authService.currentUser != null) {
          final response = await _threadService.getUserResponse(
            authService.currentUser!.id,
            prompt.id,
          );
          setState(() => _userResponse = response);
        }
      }
    } catch (e) {
      debugPrint('Error loading today\'s prompt: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitResponse(String response) async {
    if (_todayPrompt == null) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      final authService = context.read<AuthService>();
      final user = authService.currentUser;
      
      if (user != null) {
        final success = await _threadService.submitResponse(
          userId: user.id,
          promptId: _todayPrompt!.id,
          response: response,
          isAnonymous: true, // Default to anonymous
          username: user.username,
          avatar: user.avatar,
        );
        
        if (success) {
          // Reload user response
          await _loadTodayPrompt();
          
          // Navigate to thread feed
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ThreadFeedScreen(prompt: _todayPrompt!),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting response: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('MoodThread'),
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todayPrompt == null
              ? _buildNoPromptView()
              : _buildPromptView(),
    );
  }

  Widget _buildNoPromptView() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                ),
                child: Icon(
                  Icons.schedule,
                  size: MediaQuery.of(context).size.width * 0.15,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                'No prompt available',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'Check back later for today\'s prompt',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptView() {
    if (_userResponse != null) {
      return _buildResponseSubmittedView();
    }
    
    return _buildPromptInputView();
  }

  Widget _buildPromptInputView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            
            // Beautiful Prompt Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                child: Column(
                  children: [
                    // Prompt Icon
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.06),
                      ),
                      child: Icon(
                        Icons.psychology,
                        size: MediaQuery.of(context).size.width * 0.08,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    
                    // Prompt Label
                    Text(
                      'Today\'s Mood Check',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    
                    // Prompt Text
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _todayPrompt!.text,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    
                    // Instruction
                    Text(
                      'Share your response in one sentence',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            
            // Response Input Section
            _buildResponseInput(),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            
            // Time Remaining Card
            _buildTimeRemaining(),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseInput() {
    final responseController = TextEditingController();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Response',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
          ),
        ),
        
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        
        TextFormField(
          controller: responseController,
          decoration: InputDecoration(
            labelText: 'How are you feeling today?',
            hintText: 'Share your mood in one sentence...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          ),
          maxLines: 3,
          maxLength: 200,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _submitResponse(value.trim());
            }
          },
        ),
        
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.06,
          child: ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : () {
                    final response = responseController.text.trim();
                    if (response.isNotEmpty) {
                      _submitResponse(response);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isSubmitting
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Share Response',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponseSubmittedView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            
            // Success Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.successColor.withOpacity(0.1),
                    AppTheme.successColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.successColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.06),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: MediaQuery.of(context).size.width * 0.08,
                        color: AppTheme.successColor,
                      ),
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    
                    Text(
                      'Response Shared!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    
                    Text(
                      'Your response:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                    
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _userResponse!.response,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            
            // View Thread Button
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ThreadFeedScreen(prompt: _todayPrompt!),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'View Thread',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            
            // Time Remaining
            _buildTimeRemaining(),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRemaining() {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final remaining = endOfDay.difference(now);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: AppTheme.primaryColor,
                size: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(
                'Thread closes in',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          
          Text(
            '${remaining.inHours}h ${remaining.inMinutes % 60}m',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          
          Text(
            _nextPromptTime != null 
                ? 'Next prompt: ${DateFormat('h:mm a').format(_nextPromptTime!)}'
                : 'Next prompt: Random time tomorrow',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
