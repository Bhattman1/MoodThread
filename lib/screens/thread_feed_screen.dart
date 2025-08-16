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
      body: SafeArea(
        child: Column(
          children: [
            // Prompt Header
            _buildPromptHeader(),
            
            // Thread Feed
            Expanded(
              child: _buildThreadFeed(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptHeader() {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.psychology,
                  color: AppTheme.primaryColor,
                  size: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005),
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${widget.prompt.responseCount} responses',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Thread closes at 11:59 PM',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.end,
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
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: MediaQuery.of(context).size.width * 0.15,
                    color: AppTheme.errorColor,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  Text(
                    'Error loading thread',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                  Text(
                    'Please try again later',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        
        final responses = snapshot.data ?? [];
        
        if (responses.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: MediaQuery.of(context).size.width * 0.15,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  Text(
                    'No responses yet',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                  Text(
                    'Be the first to share how you feel',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
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
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Response Header
            Row(
              children: [
                // Avatar
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
                  ),
                  child: Center(
                    child: Text(
                      _getAvatarText(response),
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                
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
                    size: MediaQuery.of(context).size.width * 0.05,
                    color: AppTheme.textSecondaryColor,
                  ),
                  label: Text(
                    '${response.sameCount}',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: MediaQuery.of(context).size.height * 0.005,
                    ),
                    minimumSize: const Size(0, 0),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.012),
            
            // Response Text
            Text(
              response.response,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.4,
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.008),
            
            // Response Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Response #${index + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ),
                if (response.isAnonymous)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_off,
                        size: MediaQuery.of(context).size.width * 0.04,
                        color: AppTheme.textSecondaryColor,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
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
