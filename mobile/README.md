# Makine Kontrol Sistemi - Mobil Uygulama

Flutter tabanlı rol-based makine kontrol ve arıza takip mobil uygulaması.

## Özellikler

### 🔐 Kullanıcı Yönetimi
- Rol tabanlı giriş sistemi (Admin, Operatör, Teknisyen)
- Güvenli oturum yönetimi
- Kullanıcı profil yönetimi

### 🏭 Makine Yönetimi
- Makine listesi görüntüleme
- Makine durumu takibi (Aktif, Arızalı, Bakımda)
- Makine detay görüntüleme
- Arama ve filtreleme

### 🚨 Arıza Yönetimi
- Arıza bildirimi oluşturma
- Arıza listesi ve takibi
- Fotoğraf ekleme özelliği
- Öncelik seviyesi belirleme

### 📋 Kontrol Listeleri
- Düzenli kontrol görevleri
- Checklist tamamlama
- İlerleme takibi

### 📱 Mobil Özellikler
- Responsive tasarım
- Offline çalışma kapasitesi
- Push bildirimleri
- Kamera entegrasyonu

## Teknoloji Stack

- **Flutter** 3.x
- **Dart** 3.x
- **Provider** - State Management
- **Dio** - HTTP Client
- **SQLite** - Local Database
- **SharedPreferences** - Local Storage
- **Material Design 3** - UI Framework

## Kurulum

### Gereksinimler
- Flutter SDK 3.8.1 veya üzeri
- Dart SDK 3.0 veya üzeri
- Android SDK / Xcode (platform geliştirme için)

### Adımlar

1. Projeyi klonlayın:
```bash
git clone <repository-url>
cd mobile_app
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Backend API URL'ini yapılandırın:
```dart
// lib/services/api_service.dart
static const String baseUrl = 'http://your-api-url/api';
```

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## API Entegrasyonu

Bu uygulama Laravel backend API'si ile çalışır. Backend kurulumu için ana projenin README dosyasına bakın.

### API Endpoints
- `POST /api/login` - Kullanıcı girişi
- `POST /api/register` - Kullanıcı kaydı
- `GET /api/machines` - Makine listesi
- `GET /api/issues` - Arıza listesi
- `POST /api/issues` - Yeni arıza
- `GET /api/checklists` - Kontrol listesi

## Demo Hesaplar

Uygulama test edilebilmesi için aşağıdaki demo hesapları içerir:

- **Admin**: admin@test.com / password
- **Operatör**: operator@test.com / password  
- **Teknisyen**: tech@test.com / password

## Klasör Yapısı

```
lib/
├── main.dart                 # Ana uygulama giriş noktası
├── models/                   # Veri modelleri
│   ├── user.dart
│   ├── machine.dart
│   ├── issue.dart
│   └── checklist.dart
├── services/                 # API ve servis sınıfları
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── machine_service.dart
├── providers/                # State management (Provider)
│   ├── auth_provider.dart
│   └── machine_provider.dart
├── screens/                  # Ekran widget'ları
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── machines_screen.dart
│   ├── issues_screen.dart
│   └── profile_screen.dart
├── widgets/                  # Ortak widget'lar
└── utils/                    # Yardımcı fonksiyonlar
```

## Demo Hesaplar

Test için kullanabileceğiniz demo hesaplar:
- **Admin**: admin@test.com / password
- **Operatör**: operator@test.com / password  
- **Teknisyen**: tech@test.com / password

## Çalıştırma

```bash
flutter run
```

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.
