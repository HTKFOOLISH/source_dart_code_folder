// lib/ui/config_screen/user_management_screen.dart

import 'package:flutter/material.dart';
import 'package:num_1_test/models/user_model.dart';
import 'package:num_1_test/state/user_provider.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  Future<void> _showAddUserDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    final result = await showDialog<User>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Add New User'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameCtrl,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Cannot be empty' : null,
                ),
                TextFormField(
                  controller: passwordCtrl,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Cannot be empty' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final user = User(
                    username: usernameCtrl.text.trim(),
                    password: passwordCtrl.text,
                  );
                  Navigator.of(context).pop(user);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null && context.mounted) {
      final provider = context.read<UserProvider>();
      final success = await provider.add(result);

      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username already exists!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = context.watch<UserProvider>().users;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final bool canDelete = users.length > 1; // Không cho xoá user cuối

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.username),
            subtitle: const Text('********'),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: canDelete ? Colors.redAccent : Colors.grey,
              ),
              onPressed: !canDelete
                  ? null // Vô hiệu hoá nút
                  : () {
                context.read<UserProvider>().remove(user.username);
              },
            ),
          );
        },
      ),
    );
  }
}