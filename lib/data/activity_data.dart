import '../models/activity_model.dart';

/// DATA: sumber data. Menyimpan daftar aktivitas sementara di dalam List
/// selama aplikasi berjalan (tidak permanen).
class ActivityData {
  final List<ActivityModel> activities = [
    const ActivityModel(id: '1', name: 'Push Up', counter: 10),
    const ActivityModel(id: '2', name: 'Membaca Buku', counter: 3),
    const ActivityModel(id: '3', name: 'Minum Air Putih', counter: 5),
  ];
}
