import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/issue_provider.dart';
import '../models/issue.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'open';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<IssueProvider>(context, listen: false).fetchIssues();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veriler yüklenirken hata oluştu: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'open':
        return Icons.error;
      case 'in_progress':
        return Icons.work;
      case 'closed':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'open':
        return 'Açık';
      case 'in_progress':
        return 'Devam Eden';
      case 'closed':
        return 'Kapalı';
      default:
        return 'Bilinmiyor';
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'low':
        return 'Düşük';
      case 'medium':
        return 'Orta';
      case 'high':
        return 'Yüksek';
      default:
        return 'Bilinmiyor';
    }
  }

  void _showIssueDetails(Issue issue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(issue.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Açıklama: ${issue.description}'),
            const SizedBox(height: 8),
            Text('Öncelik: ${_getPriorityText(issue.priority)}'),
            const SizedBox(height: 8),
            Text('Durum: ${_getStatusText(issue.status)}'),
            const SizedBox(height: 8),
            Text('Tarih: ${issue.createdAt.toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  void _showEditIssueDialog(Issue issue) {
    final titleController = TextEditingController(text: issue.title);
    final descriptionController = TextEditingController(
      text: issue.description,
    );
    String selectedStatus = issue.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arıza Düzenle'),
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
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Durum',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'open', child: Text('Açık')),
                  DropdownMenuItem(
                    value: 'in_progress',
                    child: Text('Devam Eden'),
                  ),
                  DropdownMenuItem(value: 'closed', child: Text('Kapalı')),
                ],
                onChanged: (value) {
                  selectedStatus = value!;
                },
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
            onPressed: () async {
              try {
                await context.read<IssueProvider>().updateIssueStatus(
                  issue.id,
                  selectedStatus,
                );
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Arıza güncellendi')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Hata: $e')));
                }
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Future<void> _closeIssue(Issue issue) async {
    try {
      await context.read<IssueProvider>().updateIssueStatus(issue.id, 'closed');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Arıza kapatıldı')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  void _showCreateIssueDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedPriority = 'medium';
    int selectedMachineId = 1;

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
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
              DropdownButtonFormField<int>(
                value: selectedMachineId,
                decoration: const InputDecoration(
                  labelText: 'Makine',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Test Makinesi 1')),
                  DropdownMenuItem(value: 2, child: Text('Test Makinesi 2')),
                  DropdownMenuItem(value: 3, child: Text('Test Makinesi 3')),
                ],
                onChanged: (value) {
                  selectedMachineId = value!;
                },
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
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  descriptionController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                );
                return;
              }

              try {
                final success = await context.read<IssueProvider>().createIssue(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  priority: selectedPriority,
                  machineId: selectedMachineId,
                );

                if (mounted) {
                  if (success) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Arıza başarıyla oluşturuldu'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Arıza oluşturulurken hata oluştu'),
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Hata: $e')));
                }
              }
            },
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
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
                border: const OutlineInputBorder(),
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
                  selected: _selectedFilter == 'open',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = 'open';
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Devam Eden'),
                  selected: _selectedFilter == 'in_progress',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = 'in_progress';
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Kapalı'),
                  selected: _selectedFilter == 'closed',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = 'closed';
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Arıza listesi - gerçek verilerle
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Consumer<IssueProvider>(
                    builder: (context, issueProvider, child) {
                      final filteredIssues = issueProvider.issues.where((
                        issue,
                      ) {
                        // Filtre kontrolü
                        bool matchesFilter = true;
                        if (_selectedFilter != 'all') {
                          matchesFilter = issue.status == _selectedFilter;
                        }

                        // Arama kontrolü
                        bool matchesSearch = true;
                        if (_searchController.text.isNotEmpty) {
                          final searchText = _searchController.text
                              .toLowerCase();
                          matchesSearch =
                              issue.title.toLowerCase().contains(searchText) ||
                              issue.description.toLowerCase().contains(
                                searchText,
                              );
                        }

                        return matchesFilter && matchesSearch;
                      }).toList();

                      if (filteredIssues.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Henüz arıza kaydı yok',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredIssues.length,
                        itemBuilder: (context, index) {
                          final issue = filteredIssues[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getStatusColor(
                                  issue.status,
                                ).withValues(alpha: 0.2),
                                child: Icon(
                                  _getStatusIcon(issue.status),
                                  color: _getStatusColor(issue.status),
                                ),
                              ),
                              title: Text(issue.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(issue.description),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(
                                            issue.priority,
                                          ).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          _getPriorityText(issue.priority),
                                          style: TextStyle(
                                            color: _getPriorityColor(
                                              issue.priority,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            issue.status,
                                          ).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          _getStatusText(issue.status),
                                          style: TextStyle(
                                            color: _getStatusColor(
                                              issue.status,
                                            ),
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
                                  if (issue.status != 'closed')
                                    const PopupMenuItem(
                                      value: 'close',
                                      child: ListTile(
                                        leading: Icon(Icons.check_circle),
                                        title: Text('Kapat'),
                                      ),
                                    ),
                                ],
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'details':
                                      _showIssueDetails(issue);
                                      break;
                                    case 'edit':
                                      _showEditIssueDialog(issue);
                                      break;
                                    case 'close':
                                      await _closeIssue(issue);
                                      break;
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateIssueDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
