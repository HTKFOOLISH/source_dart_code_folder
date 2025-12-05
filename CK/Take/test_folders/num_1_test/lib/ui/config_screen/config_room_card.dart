import 'package:flutter/material.dart';
import 'package:num_1_test/models/room.dart';

class ConfigRoomCard extends StatefulWidget {
  const ConfigRoomCard({super.key});

  @override
  State<ConfigRoomCard> createState() => _ConfigRoomCardState();
}

class _ConfigRoomCardState extends State<ConfigRoomCard> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _deviceCountCtrl = TextEditingController(text: '0');
  bool _initialState = false;

  final List<String> _assetOptions = <String>[
    'assets/images/living_room.png',
    'assets/images/bed_room.png',
    'assets/images/kitchen.png',
    'assets/images/garage.png',
    'assets/images/garden.png',
    'assets/images/reading.png',
  ];
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = _assetOptions.first;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _deviceCountCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final deviceCount = int.tryParse(_deviceCountCtrl.text) ?? 0;

    final room = Room(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      imagePath: _selectedImage!,
      deviceCount: deviceCount,
      initialState: _initialState,
    );

    Navigator.of(context).pop(room);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'VD: Living Room',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Enter Room\'s Name please';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deviceCountCtrl,
                decoration: const InputDecoration(
                  labelText: 'No.Devices',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter number of devices';
                  final n = int.tryParse(v);
                  if (n == null || n < 0) return 'Invalid input';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Image',
                  border: OutlineInputBorder(),
                ),
                // ----
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.black,
                    value: _selectedImage,
                    isExpanded: true,
                    items: _assetOptions
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedImage = v),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Turn on initial state'),
                value: _initialState,
                onChanged: (v) => setState(() => _initialState = v),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.check),
                      label: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
