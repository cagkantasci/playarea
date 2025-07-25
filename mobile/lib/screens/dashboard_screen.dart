import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/machine_provider.dart';
import 'login_screen.dart';
import 'machines_screen.dart';
import 'issues_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Veri yükleme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MachineProvider>().loadMachines();
    });
  }

  List<Widget> get _pages => [
    const DashboardHomeScreen(),
    const MachinesScreen(),
    const IssuesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Makine Kontrol Sistemi'),
        actions: [
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profil'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Çıkış Yap'),
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    Navigator.pop(context);
                    await context.read<AuthProvider>().logout();
                    if (mounted) {
                      navigator.pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.precision_manufacturing),
            label: 'Makineler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Arızalar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final machineProvider = context.watch<MachineProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hoş geldin mesajı
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hoş geldin, ${user?.name ?? 'Kullanıcı'}!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rol: ${_getRoleDisplayName(user?.role ?? '')}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // İstatistikler
          Text(
            'Özet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Toplam Makine',
                  value: machineProvider.machines.length.toString(),
                  icon: Icons.precision_manufacturing,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  title: 'Aktif Makine',
                  value: machineProvider.machines
                      .where((m) => m.isActive)
                      .length
                      .toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Bakımda',
                  value: machineProvider.machines
                      .where((m) => m.isMaintenance)
                      .length
                      .toString(),
                  icon: Icons.build,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  title: 'Arızalı',
                  value: machineProvider.machines
                      .where((m) => m.isInactive)
                      .length
                      .toString(),
                  icon: Icons.error,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Hızlı aksiyonlar
          Text(
            'Hızlı İşlemler',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          if (user?.isOperator == true || user?.isAdmin == true) ...[
            ListTile(
              leading: const Icon(Icons.add, color: Colors.blue),
              title: const Text('Yeni Arıza Bildir'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to create issue
              },
            ),
            const Divider(),
          ],

          ListTile(
            leading: const Icon(Icons.search, color: Colors.green),
            title: const Text('Makine Ara'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to machines with search
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.checklist, color: Colors.purple),
            title: const Text('Kontrol Listesi'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to checklist
            },
          ),
        ],
      ),
    );
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
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
