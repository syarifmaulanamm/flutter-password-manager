import 'package:flutter/material.dart';
import '../../core/utils/password_generator.dart';
import '../../core/utils/clipboard_service.dart';

class GeneratorDialog extends StatefulWidget {
  const GeneratorDialog({super.key});

  @override
  State<GeneratorDialog> createState() => _GeneratorDialogState();
}

class _GeneratorDialogState extends State<GeneratorDialog> {
  int _length = 16;
  bool _includeLowercase = true;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;

  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    setState(() {
      _generatedPassword = PasswordGenerator.generate(
        length: _length,
        includeLowercase: _includeLowercase,
        includeUppercase: _includeUppercase,
        includeNumbers: _includeNumbers,
        includeSymbols: _includeSymbols,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Password Generator'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      _generatedPassword,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Monospace',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _generatePassword,
                    tooltip: 'Generate Ulang',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Panjang: '),
                Text('$_length', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _length.toDouble(),
              min: 6,
              max: 32,
              divisions: 26,
              label: '$_length',
              onChanged: (val) {
                setState(() {
                  _length = val.round();
                });
                _generatePassword();
              },
            ),
            CheckboxListTile(
              title: const Text('Huruf Kecil (a-z)'),
              value: _includeLowercase,
              onChanged: (val) {
                setState(() => _includeLowercase = val ?? true);
                _generatePassword();
              },
            ),
            CheckboxListTile(
              title: const Text('Huruf Besar (A-Z)'),
              value: _includeUppercase,
              onChanged: (val) {
                setState(() => _includeUppercase = val ?? true);
                _generatePassword();
              },
            ),
            CheckboxListTile(
              title: const Text('Angka (0-9)'),
              value: _includeNumbers,
              onChanged: (val) {
                setState(() => _includeNumbers = val ?? true);
                _generatePassword();
              },
            ),
            CheckboxListTile(
              title: const Text('Simbol (!@#\$)'),
              value: _includeSymbols,
              onChanged: (val) {
                setState(() => _includeSymbols = val ?? true);
                _generatePassword();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.copy),
          label: const Text('Salin & Pakai'),
          onPressed: () {
            ClipboardService.copyToClipboard(_generatedPassword);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password disalin! (Auto-clear dalam 30 detik)')),
            );
            Navigator.pop(context, _generatedPassword);
          },
        ),
      ],
    );
  }
}
