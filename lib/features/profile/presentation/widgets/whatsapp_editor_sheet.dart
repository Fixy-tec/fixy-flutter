import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../../core/utils/auth_error_messages.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class WhatsappEditorSheet extends ConsumerStatefulWidget {
  const WhatsappEditorSheet({this.initial, super.key});
  final String? initial;

  static Future<void> show(BuildContext context, String? initial) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: WhatsappEditorSheet(initial: initial),
      ),
    );
  }

  @override
  ConsumerState<WhatsappEditorSheet> createState() =>
      _WhatsappEditorSheetState();
}

class _WhatsappEditorSheetState extends ConsumerState<WhatsappEditorSheet> {
  late final TextEditingController _ctrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final uid = ref.read(currentSessionProvider)?.user.id;
    if (uid == null) return;
    final text = _ctrl.text.trim();
    if (text.isNotEmpty && text.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numero invalido')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await supabase.from('profiles').update({
        'whatsapp_number': text.isEmpty ? null : text,
      }).eq('id', uid);
      ref.invalidate(currentUserProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Numero de WhatsApp',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Solo se mostrara cuando aceptes a un postulante o te aprueben.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]')),
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone),
              hintText: 'Ej: 987654321',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
