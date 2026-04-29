import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/auth_error_messages.dart';
import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/profile_repository.dart';
import '../providers/profile_providers.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({required this.user, super.key});
  final AppUser user;

  static Future<void> show(BuildContext context, AppUser user) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditProfileSheet(user: user),
      ),
    );
  }

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late final TextEditingController _name;
  late final TextEditingController _career;
  late final TextEditingController _cycle;
  late final TextEditingController _bio;
  late final TextEditingController _portfolio;
  late final TextEditingController _linkedin;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.fullName);
    _career = TextEditingController(text: widget.user.career ?? '');
    _cycle = TextEditingController(text: widget.user.cycle?.toString() ?? '');
    _bio = TextEditingController(text: widget.user.bio ?? '');
    _portfolio = TextEditingController(text: widget.user.portfolioUrl ?? '');
    _linkedin = TextEditingController(text: widget.user.linkedinUrl ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _career.dispose();
    _cycle.dispose();
    _bio.dispose();
    _portfolio.dispose();
    _linkedin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final uid = ref.read(currentSessionProvider)?.user.id;
    if (uid == null) return;
    final cycle = int.tryParse(_cycle.text.trim());
    if (cycle == null || cycle < 1 || cycle > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ciclo invalido (1-10)')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(profileRepositoryProvider).updateProfile(
            uid,
            ProfileUpdateData(
              fullName: _name.text.trim(),
              career: _career.text.trim(),
              cycle: cycle,
              bio: _bio.text.trim().isEmpty ? null : _bio.text.trim(),
              portfolioUrl:
                  _portfolio.text.trim().isEmpty ? null : _portfolio.text.trim(),
              linkedinUrl:
                  _linkedin.text.trim().isEmpty ? null : _linkedin.text.trim(),
            ),
          );
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Editar perfil',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _career,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Carrera',
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cycle,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: const InputDecoration(
                labelText: 'Ciclo (1-10)',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bio,
              maxLength: 280,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio (opcional)',
                hintText: 'Estudiante apasionado por...',
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _portfolio,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Portafolio (URL, opcional)',
                prefixIcon: Icon(Icons.public),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _linkedin,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'LinkedIn (URL, opcional)',
                prefixIcon: Icon(Icons.work_outline),
              ),
            ),
            const SizedBox(height: 20),
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
      ),
    );
  }
}
