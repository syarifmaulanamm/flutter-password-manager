import 'package:flutter/material.dart';
import '../../domain/models/password_entry.dart';
import 'generator_dialog.dart';

class EntryFormDialog extends StatefulWidget {
  final PasswordEntry? entry;
  final Function(String service, String username, String password, String? notes) onSubmit;

  const EntryFormDialog({
    super.key,
    this.entry,
    required this.onSubmit,
  });

  @override
  State<EntryFormDialog> createState() => _EntryFormDialogState();
}

class _EntryFormDialogState extends State<EntryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serviceController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _serviceController = TextEditingController(text: widget.entry?.serviceName ?? '');
    _usernameController = TextEditingController(text: widget.entry?.username ?? '');
    _passwordController = TextEditingController();
    _notesController = TextEditingController(text: widget.entry?.notes ?? '');
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _openGenerator() async {
    final generated = await showDialog<String>(
      context: context,
      builder: (context) => const GeneratorDialog(),
    );

    if (generated != null && generated.isNotEmpty) {
      setState(() {
        _passwordController.text = generated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Entri Password' : 'Tambah Entri Password Baru'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _serviceController,
                decoration: const InputDecoration(
                  labelText: 'Nama Layanan / Website',
                  hintText: 'Misal: Google, Netflix, Tokopedia',
                  prefixIcon: Icon(Icons.language),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Nama layanan wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username / Email',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Username wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: isEditing ? 'Password Baru (Kosongkan jika tak diubah)' : 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.auto_awesome, color: Colors.amber),
                        onPressed: _openGenerator,
                        tooltip: 'Generate Password',
                      ),
                    ],
                  ),
                ),
                validator: (val) {
                  if (!isEditing && (val == null || val.isEmpty)) {
                    return 'Password wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  prefixIcon: Icon(Icons.note),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                _serviceController.text.trim(),
                _usernameController.text.trim(),
                _passwordController.text,
                _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
              );
              Navigator.pop(context);
            }
          },
          child: Text(isEditing ? 'Simpan Perubahan' : 'Tambah'),
        ),
      ],
    );
  }
}
