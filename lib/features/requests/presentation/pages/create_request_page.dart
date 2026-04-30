import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/reputation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_error_messages.dart';
import '../../../../shared/models/request_summary.dart';
import '../../../../shared/models/tag.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../feed/presentation/providers/feed_providers.dart';
import '../../data/requests_repository.dart';
import '../providers/requests_providers.dart';

class CreateRequestPage extends ConsumerStatefulWidget {
  const CreateRequestPage({super.key});

  @override
  ConsumerState<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends ConsumerState<CreateRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _benefitCtrl = TextEditingController();
  final _participantsCtrl = TextEditingController(text: '1');

  RequestType _type = RequestType.asesoria;
  int _difficulty = 3;
  DateTime? _deadline;
  final Set<String> _selectedTagIds = {};
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _benefitCtrl.dispose();
    _participantsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 180)),
      locale: const Locale('es'),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTagIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un tag')),
      );
      return;
    }
    final uid = ref.read(currentSessionProvider)?.user.id;
    if (uid == null) return;

    setState(() => _saving = true);
    try {
      final benefitText = _benefitCtrl.text.trim();
      await ref.read(requestsRepositoryProvider).createRequest(
            CreateRequestData(
              type: _type,
              title: _titleCtrl.text.trim(),
              description: _descCtrl.text.trim(),
              difficultyLevel: _difficulty,
              tagIds: _selectedTagIds.toList(),
              economicBenefit:
                  benefitText.isEmpty ? null : num.tryParse(benefitText),
              participantsNeeded:
                  int.tryParse(_participantsCtrl.text.trim()) ?? 1,
              deadline: _deadline,
            ),
            uid,
          );

      ref.invalidate(feedProvider);
      ref.invalidate(myCreatedRequestsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud publicada')),
      );
      context.pop();
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
    final tagsAsync = ref.watch(tagCatalogProvider);
    final basePoints = basePointsByLevel[_difficulty] ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _SectionLabel('Tipo'),
              Row(
                children: [
                  Expanded(
                    child: _TypeCard(
                      title: 'Asesoria',
                      subtitle: 'Busca a alguien que te ayude',
                      selected: _type == RequestType.asesoria,
                      onTap: () => setState(() => _type = RequestType.asesoria),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeCard(
                      title: 'Proyecto',
                      subtitle: 'Busca socios para crear algo',
                      selected: _type == RequestType.proyecto,
                      onTap: () => setState(() => _type = RequestType.proyecto),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionLabel('Titulo'),
              TextFormField(
                controller: _titleCtrl,
                maxLength: 80,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Ej: Ayuda con algoritmos en Python',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa un titulo';
                  if (v.trim().length < 10) return 'Minimo 10 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _SectionLabel('Descripcion'),
              TextFormField(
                controller: _descCtrl,
                maxLength: 1000,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Detalla lo que necesitas...',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Ingresa una descripcion';
                  }
                  if (v.trim().length < 20) return 'Minimo 20 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _SectionLabel('Tags'),
              tagsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Text('Error: $e'),
                data: (tags) => _TagSelector(
                  tags: tags,
                  selected: _selectedTagIds,
                  onChanged: (ids) => setState(() {
                    _selectedTagIds
                      ..clear()
                      ..addAll(ids);
                  }),
                ),
              ),
              const SizedBox(height: 20),
              _SectionLabel('Dificultad'),
              Row(
                children: List.generate(5, (i) {
                  final level = i + 1;
                  final selected = level == _difficulty;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 4 ? 8 : 0),
                      child: OutlinedButton(
                        onPressed: () => setState(() => _difficulty = level),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: selected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          foregroundColor: selected
                              ? Theme.of(context).colorScheme.onPrimary
                              : null,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          '$level',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                '+$basePoints pts base para el asesor seleccionado',
                style: TextStyle(
                  color: AppColors.pointsPositive,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              if (_type == RequestType.proyecto) ...[
                _SectionLabel('Cantidad de participantes'),
                TextFormField(
                  controller: _participantsCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n < 1) return 'Mayor a 0';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
              ],
              _SectionLabel('Beneficio economico (opcional)'),
              TextFormField(
                controller: _benefitCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  prefixText: 'S/ ',
                  hintText: 'Voluntario si lo dejas vacio',
                ),
              ),
              const SizedBox(height: 12),
              _SectionLabel('Fecha limite (opcional)'),
              InkWell(
                onTap: _pickDeadline,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _deadline == null
                        ? 'Sin fecha limite'
                        : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      )
                    : const Text('Publicar solicitud'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  // ignore: unused_element_parameter
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : scheme.surfaceContainer,
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: selected ? scheme.onPrimaryContainer : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: selected
                    ? scheme.onPrimaryContainer.withValues(alpha: 0.85)
                    : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagSelector extends StatelessWidget {
  const _TagSelector({
    required this.tags,
    required this.selected,
    required this.onChanged,
  });
  final List<Tag> tags;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((t) {
        final isSelected = selected.contains(t.id);
        return FilterChip(
          label: Text(t.name),
          selected: isSelected,
          onSelected: (v) {
            final next = {...selected};
            if (v) {
              next.add(t.id);
            } else {
              next.remove(t.id);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}
