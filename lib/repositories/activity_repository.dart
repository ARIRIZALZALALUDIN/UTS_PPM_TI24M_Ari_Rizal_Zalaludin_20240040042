import '../data/activity_data.dart';
import '../models/activity_model.dart';

/// REPOSITORY: mengelola akses & manipulasi data (CRUD) ke Data.
class ActivityRepository {
  final ActivityData _data;

  ActivityRepository(this._data);

  List<ActivityModel> getAll() => List.of(_data.activities);

  ActivityModel? getById(String id) {
    final index = _data.activities.indexWhere((a) => a.id == id);
    return index == -1 ? null : _data.activities[index];
  }

  void add(ActivityModel activity) => _data.activities.add(activity);

  void updateName(String id, String newName) {
    final index = _data.activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      _data.activities[index] = _data.activities[index].copyWith(name: newName);
    }
  }

  void updateCounter(String id, int newValue) {
    final index = _data.activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      _data.activities[index] =
          _data.activities[index].copyWith(counter: newValue);
    }
  }

  void delete(String id) => _data.activities.removeWhere((a) => a.id == id);
}
