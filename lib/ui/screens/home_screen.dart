import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/password_viewmodel.dart';
import '../widgets/password_tile.dart';
import '../widgets/entry_form_dialog.dart';
import '../widgets/generator_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PasswordViewModel>().loadEntries();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (context) => EntryFormDialog(
        onSubmit: (service, username, password, notes) {
          context.read<PasswordViewModel>().addEntry(
                serviceName: service,
                username: username,
                plainPassword: password,
                notes: notes,
              );
        },
      ),
    );
  }

  void _openEditDialog(entry) {
    showDialog(
      context: context,
      builder: (context) => EntryFormDialog(
        entry: entry,
        onSubmit: (service, username, password, notes) async {
          final vm = context.read<PasswordViewModel>();
          final finalPassword = password.isEmpty ? await vm.decryptPassword(entry.encryptedPassword) : password;

          vm.updateEntry(
            id: entry.id,
            serviceName: service,
            username: username,
            plainPassword: finalPassword,
            notes: notes,
            createdAt: entry.createdAt,
          );
        },
      ),
    );
  }

  void _openGeneratorDialog() {
    showDialog(
      context: context,
      builder: (context) => const GeneratorDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.read<AuthViewModel>();
    final passwordVm = context.watch<PasswordViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Colors.amber),
            tooltip: 'Generator Password',
            onPressed: _openGeneratorDialog,
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Kunci Brankas',
            onPressed: () {
              authVm.lockApp();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari layanan atau username...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          passwordVm.setSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                passwordVm.setSearchQuery(query);
              },
            ),
          ),
          Expanded(
            child: passwordVm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : passwordVm.entries.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada password tersimpan.\nTekan + untuk menambah.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: passwordVm.entries.length,
                        itemBuilder: (context, index) {
                          final entry = passwordVm.entries[index];
                          return PasswordTile(
                            entry: entry,
                            onEdit: () => _openEditDialog(entry),
                            onDelete: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Entri'),
                                  content: Text('Apakah Anda yakin ingin menghapus "${entry.serviceName}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: () {
                                        passwordVm.deleteEntry(entry.id);
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Entri'),
      ),
    );
  }
}
