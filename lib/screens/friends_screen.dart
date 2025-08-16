import 'package:flutter/material.dart';
import 'package:moodthread/utils/app_theme.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () {
              // TODO: Add friend functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add friends coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              
              // Friends Header
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
                      Icon(
                        Icons.people,
                        size: MediaQuery.of(context).size.width * 0.12,
                        color: AppTheme.primaryColor,
                      ),
                      
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      
                      Text(
                        'Friends Feed',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      
                      Text(
                        'See what your friends are feeling today',
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
              
              // Friends List
              _buildFriendsList(context),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    // Mock friends data - replace with real data later
    final friends = [
      {'name': 'Alex', 'mood': 'Feeling grateful for today\'s sunshine', 'time': '2h ago', 'avatar': 'A'},
      {'name': 'Sam', 'mood': 'A bit stressed but pushing through', 'time': '1h ago', 'avatar': 'S'},
      {'name': 'Jordan', 'mood': 'Excited about the weekend plans', 'time': '45m ago', 'avatar': 'J'},
      {'name': 'Taylor', 'mood': 'Missing my morning coffee routine', 'time': '30m ago', 'avatar': 'T'},
    ];

    if (friends.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        Text(
          'Today\'s Responses',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
          ),
        ),
        
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        
        ...friends.map((friend) => _buildFriendCard(context, friend)).toList(),
      ],
    );
  }

  Widget _buildFriendCard(BuildContext context, Map<String, String> friend) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.015),
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
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Row(
          children: [
            // Avatar
            Container(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.width * 0.12,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.06),
              ),
              child: Center(
                child: Text(
                  friend['avatar']!,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            
            // Friend Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        friend['name']!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      Text(
                        friend['time']!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                  
                  Text(
                    friend['mood']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.3,
                    ),
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  
                  // Action Buttons
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.favorite_border,
                        label: 'Same',
                        onTap: () {
                          // TODO: Add same reaction
                        },
                        context: context,
                      ),
                      
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      
                      _buildActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: 'Reply',
                        onTap: () {
                          // TODO: Add reply functionality
                        },
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.008,
        ),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: MediaQuery.of(context).size.width * 0.04,
              color: AppTheme.primaryColor,
            ),
            
            SizedBox(width: MediaQuery.of(context).size.width * 0.015),
            
            Text(
              label,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: MediaQuery.of(context).size.width * 0.15,
            color: AppTheme.textSecondaryColor,
          ),
          
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          
          Text(
            'No Friends Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          
          Text(
            'Add friends to see their daily mood updates and share your feelings together',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to add friends screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add friends functionality coming soon!')),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Add Friends'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
