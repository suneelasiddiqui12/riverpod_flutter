import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/constants/app_colors.dart';
import 'package:riverpod_flutter/models/user.dart';
import 'package:riverpod_flutter/state/users_provider.dart';
 // Red for errors

class AddUserScreen extends ConsumerWidget {
  final User? user;

  const AddUserScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          user == null ? "Add User" : "Edit User",
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: AppColors.cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildTextField(
                          nameController,
                          "Name",
                              (value) {
                            if (value == null || value.isEmpty) {
                              return "Name cannot be empty";
                            }
                            return null;
                          },
                          TextInputType.text
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          emailController,
                          "Email",
                              (value) {
                            if (value == null || value.isEmpty) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                            TextInputType.emailAddress
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final userId = user?.id ?? DateTime.now().toString();
                              final newUser = User(
                                id: userId,
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                              );

                              final usersNotifier = ref.read(userListProvider.notifier);
                              if (user == null) {
                                usersNotifier.addUser(newUser);
                              } else {
                                usersNotifier.updateUser(newUser);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    user == null ? "User Added Successfully!" : "User Updated Successfully!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50), // Full width with consistent height
                            backgroundColor: AppColors.buttonColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 3,
                            foregroundColor: Colors.white, // Set the text color to white
                          ),
                          child: Text(user == null ? "Add User" : "Update User"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String? Function(String?)? validator,
      TextInputType? keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        prefixIcon: label == "Name" ? Icon(Icons.person, color: AppColors.accentColor) : Icon(Icons.email, color: AppColors.accentColor),
        errorStyle: TextStyle(color: AppColors.errorColor, fontSize: 12),
      ),
      style: TextStyle(color: AppColors.textColor),
      validator: validator,
    );
  }
}
