# Makine Kontrol Sistemi - Proje Dokümantasyonu

## Proje Genel Bilgileri

**Proje Adı:** Rol Tabanlı Makine Kontrol Sistemi  
**Teknolojiler:** Laravel (Backend), Vue.js (Admin Panel), Flutter (Mobil Uygulama)  
**Veritabanı:** MySQL  
**Geliştirme Tarihi:** 2025  

---

## Proje Mimarisi

### 1. Backend (Laravel API)
- **Lokasyon:** `backend/`
- **Port:** 8000
- **Framework:** Laravel 10+
- **Kimlik Doğrulama:** Laravel Sanctum
- **Veritabanı:** MySQL

### 2. Admin Panel (Vue.js)
- **Lokasyon:** `admin-panel/`
- **Port:** 5173 (Vite dev server)
- **Framework:** Vue 3 + Vite
- **State Management:** Pinia
- **Router:** Vue Router
- **HTTP Client:** Axios

### 3. Mobil Uygulama (Flutter)
- **Lokasyon:** `mobile_app/` (planlanıyor)
- **Framework:** Flutter
- **Platform:** iOS & Android

---

## Veritabanı Yapısı

### Ana Tablolar

#### 1. users
```sql
- id (Primary Key)
- name (string)
- email (string, unique)
- email_verified_at (timestamp)
- password (string)
- role_id (Foreign Key -> roles.id)
- created_at, updated_at
```

#### 2. roles
```sql
- id (Primary Key)
- name (string, unique)
- created_at, updated_at
```

#### 3. machines
```sql
- id (Primary Key)
- name (string)
- category_id (Foreign Key -> categories.id)
- created_at, updated_at
```

#### 4. categories
```sql
- id (Primary Key)
- name (string)
- created_at, updated_at
```

#### 5. checklist_templates
```sql
- id (Primary Key)
- name (string)
- description (text, nullable)
- created_at, updated_at
```

#### 6. checklist_items
```sql
- id (Primary Key)
- template_id (Foreign Key -> checklist_templates.id)
- name (string)
- description (text, nullable)
- created_at, updated_at
```

#### 7. issues
```sql
- id (Primary Key)
- title (string)
- description (text, nullable)
- machine_id (Foreign Key -> machines.id)
- created_at, updated_at
```

#### 8. approvals
```sql
- id (Primary Key)
- title (string)
- status (string)
- created_at, updated_at
```

---

## Backend API Endpoints

### Kimlik Doğrulama
- `POST /api/register` - Kullanıcı kaydı
- `POST /api/login` - Giriş yapma
- `POST /api/logout` - Çıkış yapma
- `GET /api/user` - Mevcut kullanıcı bilgileri

### Ana Kaynaklar (CRUD)
- `GET /api/machines` - Tüm makineler
- `POST /api/machines` - Yeni makine ekleme
- `GET /api/machines/{id}` - Makine detayı
- `PUT /api/machines/{id}` - Makine güncelleme
- `DELETE /api/machines/{id}` - Makine silme

*Aynı yapı categories, users, roles, checklist_templates, checklist_items, issues, approvals için geçerli*

---

## Admin Panel Özellikleri

### Tamamlanan Özellikler

#### 1. CRUD İşlemleri
- ✅ Makineler yönetimi
- ✅ Kategoriler yönetimi
- ✅ Kullanıcılar yönetimi
- ✅ Roller yönetimi
- ✅ Kontrol Listesi Şablonları yönetimi
- ✅ Kontrol Listesi Öğeleri yönetimi
- ✅ Arıza Kayıtları yönetimi
- ✅ Onay Süreçleri yönetimi

#### 2. Kullanıcı Deneyimi
- ✅ Arama ve filtreleme (tüm modüller)
- ✅ Sayfalama (pagination) - 10 kayıt/sayfa
- ✅ Bildirim sistemi (başarı/hata mesajları)
- ✅ Form validasyonu ve inline hata mesajları
- ✅ Responsive tasarım
- ✅ Loading durumları

#### 3. Güvenlik
- ✅ Rol tabanlı erişim kontrolü
- ✅ Route guard'ları
- ✅ Token tabanlı kimlik doğrulama
- ✅ CORS konfigürasyonu

#### 4. Navigasyon
- ✅ Ana menü sistemi
- ✅ Breadcrumb navigasyonu
- ✅ Dinamik sayfa başlıkları

---

## Klasör Yapısı

### Backend (Laravel)
```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── AuthController.php
│   │   │   ├── MachineController.php
│   │   │   ├── CategoryController.php
│   │   │   ├── UserController.php
│   │   │   ├── RoleController.php
│   │   │   ├── ChecklistTemplateController.php
│   │   │   ├── ChecklistItemController.php
│   │   │   ├── IssueController.php
│   │   │   └── ApprovalController.php
│   │   └── Middleware/
│   └── Models/
│       ├── User.php
│       ├── Role.php
│       ├── Machine.php
│       ├── Category.php
│       ├── ChecklistTemplate.php
│       ├── ChecklistItem.php
│       ├── Issue.php
│       └── Approval.php
├── database/
│   ├── migrations/
│   └── seeders/
└── routes/
    └── api.php
```

### Admin Panel (Vue.js)
```
admin-panel/
├── src/
│   ├── components/
│   │   └── Notification.vue
│   ├── views/
│   │   ├── LoginView.vue
│   │   ├── MachinesView.vue
│   │   ├── CategoriesView.vue
│   │   ├── UsersView.vue
│   │   ├── RolesView.vue
│   │   ├── ChecklistTemplatesView.vue
│   │   ├── ChecklistItemsView.vue
│   │   ├── IssuesView.vue
│   │   └── ApprovalsView.vue
│   ├── router/
│   │   └── index.js
│   ├── stores/
│   │   └── auth.js
│   ├── axios.js
│   ├── App.vue
│   └── main.js
├── package.json
└── vite.config.js
```

---

## Kurulum ve Çalıştırma

### Backend Kurulum
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan serve
```

### Admin Panel Kurulum
```bash
cd admin-panel
npm install
npm run dev
```

### Veritabanı Konfigürasyonu
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=machine_control
DB_USERNAME=root
DB_PASSWORD=
```

---

## Kullanılan Paketler

### Backend (Laravel)
- `laravel/sanctum` - API kimlik doğrulama
- `laravel/tinker` - REPL aracı

### Admin Panel (Vue.js)
- `vue@^3.4.0` - Vue.js framework
- `vue-router@^4.0.0` - Router
- `pinia@^2.1.0` - State management
- `axios@^1.6.0` - HTTP client
- `@vitejs/plugin-vue` - Vite Vue plugin

---

## Güvenlik Özellikleri

### API Güvenliği
- CORS konfigürasyonu
- Rate limiting
- Input validation
- SQL injection koruması
- XSS koruması

### Frontend Güvenliği
- Token tabanlı kimlik doğrulama
- Route guards
- Input sanitization
- CSRF koruması

---

## Performans Optimizasyonları

### Backend
- Database indexing
- Eager loading
- API response caching
- Query optimization

### Frontend
- Component lazy loading
- Image optimization
- Bundle splitting
- Virtual scrolling (büyük listeler için)

---

## Test Stratejisi

### Backend Testleri
- Unit testler (Model testleri)
- Feature testler (API endpoint testleri)
- Integration testleri

### Frontend Testleri
- Component testleri
- E2E testleri
- Unit testleri

---

## Deployment

### Production Ortamı
- **Backend:** Apache/Nginx + PHP-FPM
- **Frontend:** Static build (dist/) → Web server
- **Database:** MySQL 8.0+
- **SSL:** Let's Encrypt/Commercial SSL

### Environment Variables
```env
# Backend (.env)
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.yourdomain.com

# Frontend (.env.production)
VITE_API_URL=https://api.yourdomain.com/api
```

---

## Gelecek Planları

### Mobil Uygulama (Flutter)
- [ ] Giriş/çıkış ekranları
- [ ] Makine listesi ve detay
- [ ] QR kod okuyucu
- [ ] Fotoğraf yükleme
- [ ] Offline çalışma
- [ ] Push bildirimler

### Yeni Özellikler
- [ ] Real-time bildirimler (WebSocket)
- [ ] Raporlama sistemi
- [ ] Excel export/import
- [ ] Çok dilli destek
- [ ] Dark mode
- [ ] Audit log sistemi

### Teknik Geliştirmeler
- [ ] Unit testler
- [ ] CI/CD pipeline
- [ ] Docker containerization
- [ ] Redis cache layer
- [ ] Elasticsearch entegrasyonu

---

## İletişim ve Destek

**Geliştirici:** [Geliştirici Adı]  
**E-posta:** [Email]  
**GitHub:** https://github.com/cagkantasci/playarea  

---

## Lisans

Bu proje MIT lisansı altında geliştirilmiştir.

---

## Sürüm Geçmişi

### v1.0.0 (Mevcut)
- ✅ Temel CRUD işlemleri
- ✅ Rol tabanlı kimlik doğrulama
- ✅ Admin panel UI/UX
- ✅ Form validasyonu
- ✅ Arama ve sayfalama
- ✅ Bildirim sistemi

### v1.1.0 (Planlanan)
- [ ] Flutter mobil uygulama
- [ ] Fotoğraf yükleme
- [ ] QR kod sistemi
- [ ] Real-time bildirimler

### v1.2.0 (Planlanan)
- [ ] Raporlama modülü
- [ ] Excel entegrasyonu
- [ ] Çok dilli destek
- [ ] Gelişmiş analitik

---

## Teknik Notlar

### API Response Format
```json
{
  "data": [...],
  "message": "Success message",
  "status": "success"
}
```

### Error Response Format
```json
{
  "message": "Error message",
  "errors": {...},
  "status": "error"
}
```

### Naming Conventions
- **Database:** snake_case
- **API:** camelCase
- **Vue Components:** PascalCase
- **Variables:** camelCase

---

*Bu dokümantasyon projenin mevcut durumunu yansıtmaktadır ve düzenli olarak güncellenmektedir.*
