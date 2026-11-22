import 'package:flutter/material.dart';

import '../viewmodels/activity_viewmodel.dart';
import 'activity_form_view.dart';

/// VIEW: Halaman Detail aktivitas (counter, +, -, reset, hapus).
class ActivityDetailView extends StatelessWidget {
  final ActivityViewModel viewModel;
  final String activityId;

  const ActivityDetailView({
    super.key,
    required this.viewModel,
    required this.activityId,
  });

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ));
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _onReset(BuildContext context) async {
    final ok = await _confirm(
      context,
      title: 'Reset Counter',
      message: 'Yakin ingin mengembalikan nilai counter menjadi 0?',
      confirmLabel: 'Reset',
    );
    if (ok && context.mounted) {
      viewModel.reset(activityId);
      _showSnack(context, 'Counter di-reset menjadi 0');
    }
  }

  Future<void> _onDelete(BuildContext context) async {
    final ok = await _confirm(
      context,
      title: 'Hapus Aktivitas',
      message: 'Yakin ingin menghapus aktivitas ini?',
      confirmLabel: 'Hapus',
    );
    if (ok && context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      viewModel.deleteActivity(activityId);
      Navigator.pop(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Aktivitas berhasil dihapus')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final activity = viewModel.getById(activityId);

        // Aktivitas sudah dihapus -> halaman kosong sesaat sebelum ditutup.
        if (activity == null) {
          return const Scaffold(body: SizedBox.shrink());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Aktivitas'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActivityFormView(
                      viewModel: viewModel,
                      activityId: activityId,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Hapus',
                onPressed: () => _onDelete(context),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    activity.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 180,
                    height: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${activity.counter}',
                      style: const TextStyle(
                          fontSize: 64, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        iconSize: 36,
                        tooltip: 'Kurang',
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          final changed = viewModel.decrement(activityId);
                          _showSnack(
                            context,
                            changed
                                ? 'Counter berkurang menjadi ${activity.counter - 1}'
                                : 'Counter tidak boleh kurang dari 0',
                          );
                        },
                      ),
                      const SizedBox(width: 32),
                      IconButton.filled(
                        iconSize: 36,
                        tooltip: 'Tambah',
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          viewModel.increment(activityId);
                          _showSnack(context,
                              'Counter bertambah menjadi ${activity.counter + 1}');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _onReset(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _onDelete(context),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus Aktivitas'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
