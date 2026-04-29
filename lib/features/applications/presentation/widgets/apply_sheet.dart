import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/auth_error_messages.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../requests/presentation/providers/requests_providers.dart';
import '../providers/applications_providers.dart';

/// Bottom sheet para postularse con un mensaje de presentacion.
class ApplySheet extends ConsumerStatefulWidget {
  const ApplySheet({required this.requestId, super.key});
  final String requestId;

  static Future<bool?> show(BuildContext context, String requestId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ApplySheet(requestId: requestId),
      ),
    );
  }

  @override
  ConsumerState<ApplySheet> createState() => _ApplySheetState();
}

class _ApplySheetState extends ConsumerState<ApplySheet> {
  final _ctrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final uid = ref.read(currentSessionProvider)?.user.id;
    if (uid == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(applicationsRepositoryProvider).apply(
            requestId: widget.requestId,
            applicantId: uid,
            message: _ctrl.text.trim().isEmpty ? null : _ctrl.text.trim(),
          );
      ref.invalidate(myApplicationOnRequestProvider(widget.requestId));
      ref.invalidate(applicantsForRequestProvider(widget.requestId));
      ref.invalidate(myApplicationsProvider);
      if (!mounted) return;
      Navigator.of(context).pop(true);
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
            'Postularse',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comparte un breve mensaje al creador (opcional, max 300 caracteres).',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            maxLength: 300,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Hola, tengo experiencia en...',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Text('Enviar postulacion'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
