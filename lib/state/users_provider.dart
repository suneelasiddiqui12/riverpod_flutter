import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

// UserRepository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// UserListNotifier Provider
final userListProvider = StateNotifierProvider<UserListNotifier, AsyncValue<List<User>>>((ref) {
  return UserListNotifier(ref.read(userRepositoryProvider));
});

// User State Model
class UserState {
  final List<User> users;
  final bool isLoading;
  final String? errorMessage;
  final void Function()? retry;

  UserState({
    required this.users,
    this.isLoading = false,
    this.errorMessage,
    this.retry,
  });

  UserState copyWith({
    List<User>? users,
    bool? isLoading,
    String? errorMessage,
    void Function()? retry,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      retry: retry ?? this.retry,
    );
  }
}

// UserListNotifier Class
class UserListNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final UserRepository _userRepository;
  String? _searchQuery;
  String _sortOrder = 'name'; // can be 'name', 'email', or 'dateAdded'

  int _page = 1;
  final int _pageSize = 10;
  bool _isFetchingMore = false;
  bool _hasMore = true;


  UserListNotifier(this._userRepository) : super(const AsyncValue.loading()) {
    loadUsers();
  }

  // Getter for sort order
  String get sortOrder => _sortOrder;

  Future<void> loadUsers() async {
    try {
      state = const AsyncValue.loading();
      await _userRepository.loadUsers();
      _applyFilters();
    } catch (e) {
      state = AsyncValue.error(e.toString());
    }
  }

  // Add User
  Future<void> addUser(User user) async {
    try {
      _userRepository.addUser(user);
      state = AsyncValue.data([...state.value ?? [], user]);
      _applyFilters();
    } catch (e) {
      state = AsyncValue.error(e.toString());
    }
  }

  // Update User
  Future<void> updateUser(User user) async {
    try {
      _userRepository.updateUser(user);
      final updatedUsers = state.value?.map((u) => u.id == user.id ? user : u).toList() ?? [];
      state = AsyncValue.data(updatedUsers);
    } catch (e) {
      state = AsyncValue.error(e.toString());
    }
  }

  // Delete User
  Future<void> deleteUser(String id) async {
    try {
      _userRepository.deleteUser(id);
      state = AsyncValue.data(
        state.value?.where((user) => user.id != id).toList() ?? [],
      );
    } catch (e) {
      state = AsyncValue.error(e.toString());
    }
  }

  // Set Search Query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Set Sort Order
  void setSortOrder(String order) {
    _sortOrder = order;
    _applyFilters();
  }

  void _applyFilters() {
    List<User> filteredUsers = _userRepository.allUsers;

    // Search filter
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) =>
      user.name!.toLowerCase().contains(_searchQuery!.toLowerCase()) ||
          user.email!.toLowerCase().contains(_searchQuery!.toLowerCase())
      ).toList();
    }

    // Sort
    if (_sortOrder == 'name') {
      filteredUsers.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (_sortOrder == 'email') {
      filteredUsers.sort((a, b) => a.email!.compareTo(b.email!));
    }

    state = AsyncValue.data(filteredUsers);
  }
}


