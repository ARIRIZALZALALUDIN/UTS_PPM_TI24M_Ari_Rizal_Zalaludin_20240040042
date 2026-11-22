import 'package:flutter/material.dart';

import '../viewmodels/activity_viewmodel.dart';
import 'activity_detail_view.dart';
import 'activity_form_view.dart';

/// VIEW: Halaman Home (daftar aktivitas).
class HomeView extends StatelessWidget {
  final ActivityViewModel viewModel;

  const HomeView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Counter'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      // ListenableBuilder membangun ulang tampilan otomatis saat ViewModel berubah.
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final activities = viewModel.activities;

          if (activities.isEmpty) {
            return const Center(
              child: Text('Belum ada aktivitas.\nTekan tombol Tambah untuk membuat.',
                  textAlign: TextAlign.center),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Card(
                child: ListTile(
                  title: Text(activity.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Counter: ${activity.counter}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActivityDetailView(
                        viewModel: viewModel,
                        activityId: activity.id,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActivityFormView(
                          viewModel: viewModel,
                          activityId: activity.id,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActivityFormView(viewModel: viewModel),
          ),
        ),
      ),
    );
  }
}
