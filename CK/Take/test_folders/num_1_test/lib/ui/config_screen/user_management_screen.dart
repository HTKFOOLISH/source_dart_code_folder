// lib/ui/config_screen/user_management_screen.dart

import 'package:flutter/material.dart';
import 'package:num_1_test/models/user_model.dart';
import 'package:num_1_test/state/user_provider.dart';
import 'package:provider/provider.dart';

// CHANGE: thêm import MQTT để có nút reconnect + hiển thị trạng thái
import 'package:num_1_test/mqtt/mqtt_config.dart'; // CHANGE
import 'package:num_1_test/mqtt/mqtt_service.dart'; // CHANGE

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  // CHANGE: Hàm reconnect MQTT từ màn hình quản lý user
  Future<void> _reconnectMqtt(BuildContext context) async {
    try {
      final cfg = await MqttConfig.load();
      if (cfg == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MQTT config chưa được thiết lập!')),
        );
        return;
      }
      await MqttService.I.connect(cfg);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('MQTT reconnected.')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Reconnect lỗi: $e')));
    }
  }

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

    // CHANGE: stream trạng thái để hiện icon cloud trong AppBar
    final connectionStream = MqttService.I.connection; // CHANGE

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          // CHANGE: Hiển thị trạng thái MQTT + nút reconnect nhanh
          StreamBuilder<bool>(
            stream: connectionStream,
            initialData: MqttService.I.isConnected,
            builder: (context, snap) {
              final ok = snap.data == true;
              return Row(
                children: [
                  Icon(
                    ok ? Icons.cloud_done : Icons.cloud_off,
                    color: ok ? Colors.lightGreen : Colors.redAccent,
                  ),
                  IconButton(
                    tooltip: 'Reconnect MQTT',
                    onPressed: () => _reconnectMqtt(context),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final bool canDelete = users.length > 1; // Không cho xoá user cuối

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
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
            ),
          );
        },
      ),
    );
  }
}
