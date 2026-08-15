import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/password_entry.dart';
import '../../core/utils/clipboard_service.dart';
import '../viewmodels/password_viewmodel.dart';

class PasswordTile extends StatefulWidget {
  final PasswordEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PasswordTile({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<PasswordTile> createState() => _PasswordTileState();
}

class _PasswordTileState extends State<PasswordTile> {
  bool _showPassword = false;
  String? _decryptedPassword;

  void _toggleShowPassword(PasswordViewModel vm) async {
    if (!_showPassword) {
      if (_decryptedPassword == null) {
        final dec = await vm.decryptPassword(widget.entry.encryptedPassword);
        setState(() {
          _decryptedPassword = dec;
          _showPassword = true;
        });
      } else {
        setState(() {
          _showPassword = true;
        });
      }
    } else {
      setState(() {
        _showPassword = false;
      });
    }
  }

  void _copyUsername() {
    ClipboardService.copyToClipboard(widget.entry.username);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username disalin! (Auto-clear dalam 30s)')),
    );
  }

  void _copyPassword(PasswordViewModel vm) async {
    final password = _decryptedPassword ?? await vm.decryptPassword(widget.entry.encryptedPassword);
    ClipboardService.copyToClipboard(password);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password disalin! (Auto-clear dalam 30s)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordVm = context.read<PasswordViewModel>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            widget.entry.serviceName.isNotEmpty ? widget.entry.serviceName[0].toUpperCase() : '?',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800),
          ),
        ),
        title: Text(
          widget.entry.serviceName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(widget.entry.username),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Password: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        _showPassword ? (_decryptedPassword ?? '...') : '••••••••••••',
                        style: TextStyle(
                          fontFamily: _showPassword ? 'Monospace' : null,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => _toggleShowPassword(passwordVm),
                      tooltip: 'Toggle Password',
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyPassword(passwordVm),
                      tooltip: 'Copy Password',
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Username: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(widget.entry.username)),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: _copyUsername,
                      tooltip: 'Copy Username',
                    ),
                  ],
                ),
                if (widget.entry.notes != null && widget.entry.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Catatan: ${widget.entry.notes}', style: const TextStyle(color: Colors.grey)),
                ],
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit, color: Colors.amber),
                      label: const Text('Edit'),
                      onPressed: widget.onEdit,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Hapus'),
                      onPressed: widget.onDelete,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
