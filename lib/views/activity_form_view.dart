import 'package:flutter/material.dart';

import '../viewmodels/activity_viewmodel.dart';

/// VIEW: Halaman Tambah / Edit aktivitas.
/// Jika [activityId] null -> mode tambah, jika ada -> mode edit.
class ActivityFormView extends StatefulWidget {
  final ActivityViewModel viewModel;
  final String? activityId;

  const ActivityFormView({super.key, required this.viewModel, this.activityId});

  @override
  State<ActivityFormView> createState() => _ActivityFormViewState();
}

class _ActivityFormViewState extends State<ActivityFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  bool get _isEdit => widget.activityId != null;

  @override
  void initState() {
    super.initState();
    final existing =
        _isEdit ? widget.viewModel.getById(widget.activityId!) : null;
    _controller = TextEditingController(text: existing?.name ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final name = _controller.text;

    if (_isEdit) {
      widget.viewModel.updateName(widget.activityId!, name);
    } else {
      widget.viewModel.addActivity(name);
    }

    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(_isEdit
            ? 'Aktivitas berhasil diubah'
            : 'Aktivitas berhasil ditambahkan'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Aktivitas' : 'Tambah Aktivitas'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                decoration: const InputDecoration(
                  labelText: 'Nama Aktivitas',
                  hintText: 'Contoh: Push Up',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama aktivitas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
