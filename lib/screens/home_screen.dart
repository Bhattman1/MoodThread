import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moodthread/services/auth_service.dart';
import 'package:moodthread/services/thread_service.dart';
import 'package:moodthread/models/prompt_model.dart';
import 'package:moodthread/models/thread_response_model.dart';
import 'package:moodthread/screens/thread_feed_screen.dart';
import 'package:moodthread/utils/app_theme.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    _loadTodayPrompt();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Navigate to profile screen
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todayPrompt == null
              ? _buildNoPromptView()
              : _buildPromptView(),
    );
  }

  Widget _buildNoPromptView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No prompt available',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for today\'s prompt',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Prompt Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.psychology,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Today\'s Prompt',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _todayPrompt!.text,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
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
          
          const SizedBox(height: 40),
          
          // Response Input
          _buildResponseInput(),
          
          const Spacer(),
          
          // Time Remaining
          _buildTimeRemaining(),
        ],
      ),
    );
  }

  Widget _buildResponseInput() {
    final responseController = TextEditingController();
    
    return Column(
      children: [
        TextFormField(
          controller: responseController,
          decoration: const InputDecoration(
            labelText: 'Your response',
            hintText: 'How are you feeling today?',
            border: OutlineInputBorder(),
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
        
        const SizedBox(height: 16),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : () {
                    final response = responseController.text.trim();
                    if (response.isNotEmpty) {
                      _submitResponse(response);
                    }
                  },
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Share Response'),
          ),
        ),
      ],
    );
  }

  Widget _buildResponseSubmittedView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Success Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 64,
                    color: AppTheme.successColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Response Shared!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your response:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Text(
                      _userResponse!.response,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // View Thread Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ThreadFeedScreen(prompt: _todayPrompt!),
                  ),
                );
              },
              child: const Text('View Thread'),
            ),
          ),
          
          const Spacer(),
          
          // Time Remaining
          _buildTimeRemaining(),
        ],
      ),
    );
  }

  Widget _buildTimeRemaining() {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final remaining = endOfDay.difference(now);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Text(
            'Thread closes in',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${remaining.inHours}h ${remaining.inMinutes % 60}m',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New prompt tomorrow at 9:00 AM',
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
