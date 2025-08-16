import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moodthread/services/thread_service.dart';
import 'package:moodthread/models/prompt_model.dart';
import 'package:moodthread/models/thread_response_model.dart';
import 'package:moodthread/utils/app_theme.dart';
import 'package:intl/intl.dart';

class ThreadFeedScreen extends StatefulWidget {
  final PromptModel prompt;

  const ThreadFeedScreen({
    super.key,
    required this.prompt,
  });

  @override
  State<ThreadFeedScreen> createState() => _ThreadFeedScreenState();
}

class _ThreadFeedScreenState extends State<ThreadFeedScreen> {
  final ThreadService _threadService = ThreadService();
  bool _showUsernames = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Today\'s Thread'),
        actions: [
          IconButton(
            icon: Icon(
              _showUsernames ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _showUsernames = !_showUsernames;
              });
            },
            tooltip: _showUsernames ? 'Hide usernames' : 'Show usernames',
          ),
        ],
      ),
      body: Column(
        children: [
          // Prompt Header
          _buildPromptHeader(),
          
          // Thread Feed
          Expanded(
            child: _buildThreadFeed(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.psychology,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Prompt',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    Text(
                      widget.prompt.text,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.prompt.responseCount} responses',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              Text(
                'Thread closes at 11:59 PM',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThreadFeed() {
    return StreamBuilder<List<ThreadResponseModel>>(
      stream: _threadService.getTodayThreadStream(widget.prompt.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading thread',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again later',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        }
        
        final responses = snapshot.data ?? [];
        
        if (responses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No responses yet',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to share how you feel',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: responses.length,
          itemBuilder: (context, index) {
            final response = responses[index];
            return _buildResponseCard(response, index);
          },
        );
      },
    );
  }

  Widget _buildResponseCard(ThreadResponseModel response, int index) {
    final timeAgo = _getTimeAgo(response.createdAt);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Response Header
            Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _getAvatarText(response),
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _showUsernames && response.username != null
                            ? response.username!
                            : 'Anonymous',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Same Button
                TextButton.icon(
                  onPressed: () {
                    _threadService.addSameReaction(response.id);
                  },
                  icon: Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: AppTheme.textSecondaryColor,
                  ),
                  label: Text(
                    '${response.sameCount}',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 0),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Response Text
            Text(
              response.response,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Response Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Response #${index + 1}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                if (response.isAnonymous)
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_off,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Anonymous',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getAvatarText(ThreadResponseModel response) {
    if (response.avatar != null) {
      return response.avatar!;
    }
    
    if (response.username != null && response.username!.isNotEmpty) {
      return response.username![0].toUpperCase();
    }
    
    // Generate random emoji based on response text
    final emojis = ['😊', '😔', '😌', '😤', '😌', '😐', '😊', '😔'];
    final index = response.response.hashCode % emojis.length;
    return emojis[index];
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
