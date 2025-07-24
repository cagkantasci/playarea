import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        
        if (user == null) {
          return const Center(
            child: Text('Kullanıcı bilgisi yüklenemedi'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getRoleColor(user.role).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getRoleDisplayName(user.role),
                                style: TextStyle(
                                  color: _getRoleColor(user.role),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Hesap bilgileri
              Text(
                'Hesap Bilgileri',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              _InfoCard(
                icon: Icons.person,
                title: 'Ad Soyad',
                subtitle: user.name,
              ),
              _InfoCard(
                icon: Icons.email,
                title: 'E-posta',
                subtitle: user.email,
              ),
              _InfoCard(
                icon: Icons.work,
                title: 'Rol',
                subtitle: _getRoleDisplayName(user.role),
              ),
              _InfoCard(
                icon: Icons.calendar_today,
                title: 'Kayıt Tarihi',
                subtitle: _formatDate(user.createdAt),
              ),
              _InfoCard(
                icon: Icons.update,
                title: 'Son Güncelleme',
                subtitle: _formatDate(user.updatedAt),
              ),

              const SizedBox(height: 24),

              // Ayarlar
              Text(
                'Ayarlar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Bildirimler'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // Toggle notifications
                  },
                ),
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Karanlık Tema'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Toggle dark mode
                  },
                ),
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Dil'),
                subtitle: const Text('Türkçe'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Language settings
                },
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Uygulama Hakkında'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              const Divider(),

              const SizedBox(height: 24),

              // Çıkış butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: authProvider.isLoading ? null : () async {
                    final confirmed = await _showLogoutConfirmation(context);
                    if (confirmed == true) {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    }
                  },
                  icon: authProvider.isLoading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: const Text('Çıkış Yap'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'operator':
        return Colors.blue;
      case 'technician':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Yönetici';
      case 'operator':
        return 'Operatör';
      case 'technician':
        return 'Teknisyen';
      default:
        return role;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<bool?> _showLogoutConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Makine Kontrol Sistemi',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.precision_manufacturing,
        size: 48,
        color: Colors.blue,
      ),
      children: [
        const Text(
          'Rol tabanlı makine kontrol ve arıza takip sistemi.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Bu uygulama makinelerin durumunu takip etmek, arızaları bildirmek ve kontrol listelerini yönetmek için tasarlanmıştır.',
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
