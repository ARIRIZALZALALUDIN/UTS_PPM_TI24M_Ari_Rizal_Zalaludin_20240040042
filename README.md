# Activity Counter (UTS Pemrograman Mobile)

Aplikasi Flutter untuk mencatat dan menghitung aktivitas, dengan arsitektur MVVM
(Model - Data - Repository - ViewModel - View).

## Menjalankan
```
flutter pub get
flutter run
```

## Struktur
```
lib/
├── main.dart
├── models/activity_model.dart
├── data/activity_data.dart
├── repositories/activity_repository.dart
├── viewmodels/activity_viewmodel.dart
└── views/
    ├── home_view.dart
    ├── activity_form_view.dart
    └── activity_detail_view.dart
```

Alur data: View -> ViewModel -> Repository -> Data, lalu ViewModel memanggil
`notifyListeners()` sehingga View (ListenableBuilder) otomatis dibangun ulang.

Nama: Ari Rizal Zalaludin   NIM: 20240040042   Kelas: TI24M
