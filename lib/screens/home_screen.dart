import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/constants/app_colors.dart';
import 'package:riverpod_flutter/screens/bottom_navigation_screen.dart';
import 'package:riverpod_flutter/screens/profile_screen.dart';
import 'package:riverpod_flutter/state/users_provider.dart';
import 'package:riverpod_flutter/widgets/sort_drop_down.dart';
import 'add_user_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          "User Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(userListProvider.notifier).loadUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          UserSearchSortWidget(
            sortBy: ref.read(userListProvider.notifier).sortOrder, // Assuming this is a string from your notifier
            onSortChanged: (value) {
              ref.read(userListProvider.notifier).setSortOrder(value!);
            },
            onSearchChanged: (value) {
              ref.read(userListProvider.notifier).setSearchQuery(value);
            },
          ),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Text(
                      "No users available, please add some!",
                      style: TextStyle(fontSize: 20, color: AppColors.textColor),
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        color: AppColors.cardColor,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accentColor,
                            child: Icon(Icons.person, color: AppColors.textColor),
                          ),
                          title: Text(
                            user.name ?? 'No Name',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          subtitle: Text(
                            user.email ?? 'No Email',
                            style: TextStyle(color: AppColors.textColor.withOpacity(0.7)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirmDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete User'),
                                      content: Text('Are you sure you want to delete ${user.name}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
            
                                  if (confirmDelete == true) {
                                    ref.read(userListProvider.notifier).deleteUser(user.id ?? " ");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${user.name} deleted successfully!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                              Icon(Icons.arrow_forward_ios, color: AppColors.textColor),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddUserScreen(user: user),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Failed to load users. Please try again.",
                      style: TextStyle(fontSize: 18, color: AppColors.textColor),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => ref.read(userListProvider.notifier).loadUsers(),
                      icon: Icon(Icons.refresh),
                      label: Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          );
          ref.read(userListProvider.notifier).loadUsers();
        },
        backgroundColor: AppColors.buttonColor,
        tooltip: "Add a new user",
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBarScreen()
    );
  }
}
class UserSearchSortWidget extends StatelessWidget {
  final String sortBy;
  final ValueChanged<String?> onSortChanged;
  final ValueChanged<String> onSearchChanged;

  const UserSearchSortWidget({
    super.key,
    required this.sortBy,
    required this.onSortChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: SearchBar(
            hintText: 'Search Users',
            onChanged: onSearchChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: SortDropdown(
              selectedValue: sortBy,
              onChanged: onSortChanged,
              options: ['name', 'email'],
            ),
          ),
        ),
      ],
    );
  }
}
