import 'package:flutter/material.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Arama çubuğu
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Arıza ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Filtre butonları
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Açık'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Devam Eden'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Kapalı'),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Arıza listesi - şimdilik placeholder
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5, // Demo data
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.withOpacity(0.2),
                      child: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                    title: Text('Arıza ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Makine: Test Makinesi ${index + 1}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Yüksek',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Açık',
                                style: TextStyle(
                                  color: Colors.orange,
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
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Düzenle'),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'close',
                          child: ListTile(
                            leading: Icon(Icons.check),
                            title: Text('Kapat'),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        // Handle actions
                      },
                    ),
                    onTap: () {
                      // Show issue details
                      _showIssueDetails(context, index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create issue
          _showCreateIssueDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showIssueDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Arıza ${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Makine: Test Makinesi ${index + 1}'),
            const SizedBox(height: 8),
            const Text('Açıklama: Test arıza açıklaması'),
            const SizedBox(height: 8),
            const Text('Öncelik: Yüksek'),
            const SizedBox(height: 8),
            const Text('Durum: Açık'),
            const SizedBox(height: 8),
            const Text('Bildiren: Test Kullanıcı'),
            const SizedBox(height: 8),
            const Text('Tarih: 24/07/2025 10:30'),
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
              // Navigate to issue detail screen
            },
            child: const Text('Detaylı Görünüm'),
          ),
        ],
      ),
    );
  }

  void _showCreateIssueDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedPriority = 'medium';
    String selectedMachine = 'machine1';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Arıza Bildir'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMachine,
                decoration: const InputDecoration(
                  labelText: 'Makine',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'machine1', child: Text('Test Makinesi 1')),
                  DropdownMenuItem(value: 'machine2', child: Text('Test Makinesi 2')),
                  DropdownMenuItem(value: 'machine3', child: Text('Test Makinesi 3')),
                ],
                onChanged: (value) {
                  selectedMachine = value!;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Öncelik',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Düşük')),
                  DropdownMenuItem(value: 'medium', child: Text('Orta')),
                  DropdownMenuItem(value: 'high', child: Text('Yüksek')),
                ],
                onChanged: (value) {
                  selectedPriority = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Image picker functionality
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Fotoğraf Ekle'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Create issue
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Arıza kaydedildi'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
