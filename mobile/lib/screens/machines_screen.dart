import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/machine_provider.dart';
import '../models/machine.dart';

class MachinesScreen extends StatefulWidget {
  const MachinesScreen({super.key});

  @override
  State<MachinesScreen> createState() => _MachinesScreenState();
}

class _MachinesScreenState extends State<MachinesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MachineProvider>().loadMachines();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MachineProvider>(
        builder: (context, machineProvider, child) {
          return Column(
            children: [
              // Arama çubuğu
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Makine ara...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              machineProvider.setSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    machineProvider.setSearchQuery(value);
                  },
                ),
              ),

              // Yenile butonu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: machineProvider.isLoading
                          ? null
                          : () => machineProvider.loadMachines(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Yenile'),
                    ),
                    const Spacer(),
                    Text(
                      '${machineProvider.filteredMachines.length} makine',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Makine listesi
              Expanded(
                child: machineProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : machineProvider.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              machineProvider.error!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => machineProvider.loadMachines(),
                              child: const Text('Tekrar Dene'),
                            ),
                          ],
                        ),
                      )
                    : machineProvider.filteredMachines.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.precision_manufacturing_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Makine bulunamadı',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => machineProvider.loadMachines(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: machineProvider.filteredMachines.length,
                          itemBuilder: (context, index) {
                            final machine =
                                machineProvider.filteredMachines[index];
                            return MachineCard(machine: machine);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MachineCard extends StatelessWidget {
  final Machine machine;

  const MachineCard({super.key, required this.machine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(
            machine.status,
          ).withValues(alpha: 0.2),
          child: Icon(
            _getStatusIcon(machine.status),
            color: _getStatusColor(machine.status),
          ),
        ),
        title: Text(
          machine.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (machine.categoryName != null)
              Text('Kategori: ${machine.categoryName}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      machine.status,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusDisplayName(machine.status),
                    style: TextStyle(
                      color: _getStatusColor(machine.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'details',
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('Detaylar'),
              ),
            ),
            const PopupMenuItem(
              value: 'report_issue',
              child: ListTile(
                leading: Icon(Icons.report_problem),
                title: Text('Arıza Bildir'),
              ),
            ),
            const PopupMenuItem(
              value: 'maintenance',
              child: ListTile(leading: Icon(Icons.build), title: Text('Bakım')),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'details':
                _showMachineDetails(context, machine);
                break;
              case 'report_issue':
                // Navigate to report issue
                break;
              case 'maintenance':
                // Navigate to maintenance
                break;
            }
          },
        ),
        onTap: () => _showMachineDetails(context, machine),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.check_circle;
      case 'inactive':
        return Icons.error;
      case 'maintenance':
        return Icons.build;
      default:
        return Icons.help;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'inactive':
        return 'Arızalı';
      case 'maintenance':
        return 'Bakımda';
      default:
        return status;
    }
  }

  void _showMachineDetails(BuildContext context, Machine machine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(machine.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${machine.id}'),
            const SizedBox(height: 8),
            if (machine.categoryName != null) ...[
              Text('Kategori: ${machine.categoryName}'),
              const SizedBox(height: 8),
            ],
            Text('Durum: ${_getStatusDisplayName(machine.status)}'),
            const SizedBox(height: 8),
            if (machine.description != null) ...[
              Text('Açıklama: ${machine.description}'),
              const SizedBox(height: 8),
            ],
            Text('Oluşturulma: ${_formatDate(machine.createdAt)}'),
            Text('Güncellenme: ${_formatDate(machine.updatedAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to machine detail screen
            },
            child: const Text('Detaylı Görünüm'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
