import 'package:flutter/material.dart';
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

/// Crear solicitud en 3 pasos:
/// 1. Tipo (Asesoria / Proyecto)
/// 2. Detalles (titulo + descripcion + tags)
/// 3. Condiciones (dificultad + deadline + participantes + pago + resumen)
class CreateRequestPage extends ConsumerStatefulWidget {
  const CreateRequestPage({super.key});

  @override
  ConsumerState<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends ConsumerState<CreateRequestPage> {
  final _pageCtrl = PageController();
  int _step = 0;
  bool _saving = false;

  // Step 1
  RequestType _type = RequestType.asesoria;

  // Step 2
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final Set<String> _selectedTagIds = {};

  // Step 3
  int _difficulty = 3;
  DateTime? _deadline;
  int _participants = 1;
  final _benefitCtrl = TextEditingController();

  static const _totalSteps = 3;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _benefitCtrl.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    setState(() => _step = step);
    _pageCtrl.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  bool _canAdvance() {
    if (_step == 1) {
      if (_titleCtrl.text.trim().length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Titulo: minimo 10 caracteres')),
        );
        return false;
      }
      if (_descCtrl.text.trim().length < 20) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Descripcion: minimo 20 caracteres')),
        );
        return false;
      }
      if (_selectedTagIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona al menos un tag')),
        );
        return false;
      }
    }
    return true;
  }

  void _next() {
    if (!_canAdvance()) return;
    if (_step < _totalSteps - 1) {
      _goTo(_step + 1);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step == 0) {
      context.pop();
    } else {
      _goTo(_step - 1);
    }
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
    final uid = ref.read(currentSessionProvider)?.user.id;
    if (uid == null) return;
    setState(() => _saving = true);
    try {
      final benefit = _benefitCtrl.text.trim();
      await ref.read(requestsRepositoryProvider).createRequest(
            CreateRequestData(
              type: _type,
              title: _titleCtrl.text.trim(),
              description: _descCtrl.text.trim(),
              difficultyLevel: _difficulty,
              tagIds: _selectedTagIds.toList(),
              economicBenefit:
                  benefit.isEmpty ? null : num.tryParse(benefit),
              participantsNeeded: _participants,
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        title: Text('Crear solicitud — paso ${_step + 1} de $_totalSteps'),
      ),
      body: Column(
        children: [
          _StepBar(step: _step, total: _totalSteps),
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _step = i),
              children: [
                _Step1Type(
                  type: _type,
                  onChanged: (t) => setState(() => _type = t),
                ),
                _Step2Details(
                  titleCtrl: _titleCtrl,
                  descCtrl: _descCtrl,
                  selectedTagIds: _selectedTagIds,
                  onTagsChanged: (ids) => setState(() {
                    _selectedTagIds
                      ..clear()
                      ..addAll(ids);
                  }),
                ),
                _Step3Conditions(
                  type: _type,
                  difficulty: _difficulty,
                  onDifficultyChanged: (d) => setState(() => _difficulty = d),
                  deadline: _deadline,
                  onPickDeadline: _pickDeadline,
                  participants: _participants,
                  onParticipantsChanged: (n) =>
                      setState(() => _participants = n),
                  benefitCtrl: _benefitCtrl,
                  title: _titleCtrl.text.trim(),
                  selectedTagIds: _selectedTagIds,
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : _back,
                        child: const Text('Atras'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _next,
                      style: _step == _totalSteps - 1
                          ? FilledButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                            )
                          : null,
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.4),
                            )
                          : Text(
                              _step == _totalSteps - 1
                                  ? 'Publicar solicitud'
                                  : 'Continuar',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Step bar
// ============================================================
class _StepBar extends StatelessWidget {
  const _StepBar({required this.step, required this.total});
  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: List.generate(total, (i) {
          final active = i <= step;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color:
                      active ? scheme.primary : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================
// Step 1: tipo
// ============================================================
class _Step1Type extends StatelessWidget {
  const _Step1Type({required this.type, required this.onChanged});
  final RequestType type;
  final ValueChanged<RequestType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Que tipo de solicitud es?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Esto define como otros estudiantes veran tu publicacion.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          _TypeCard(
            icon: Icons.menu_book_outlined,
            title: 'Asesoria',
            description:
                'Busca ayuda con un curso, revision de trabajo, repaso de examen o retroalimentacion.',
            selected: type == RequestType.asesoria,
            onTap: () => onChanged(RequestType.asesoria),
          ),
          const SizedBox(height: 12),
          _TypeCard(
            icon: Icons.rocket_launch_outlined,
            title: 'Proyecto',
            description:
                'Busca socios para desarrollar un proyecto academico, personal o de emprendimiento.',
            selected: type == RequestType.proyecto,
            onTap: () => onChanged(RequestType.proyecto),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : scheme.surfaceContainer,
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: scheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Step 2: detalles
// ============================================================
class _Step2Details extends ConsumerWidget {
  const _Step2Details({
    required this.titleCtrl,
    required this.descCtrl,
    required this.selectedTagIds,
    required this.onTagsChanged,
  });

  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final Set<String> selectedTagIds;
  final ValueChanged<Set<String>> onTagsChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagCatalogProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cuentanos mas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mientras mas detallado, mejores postulantes atraeras.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titleCtrl,
            maxLength: 80,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Titulo',
              hintText: 'Ej: Ayuda con consultas SQL avanzadas',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descCtrl,
            maxLength: 1000,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Descripcion',
              hintText:
                  'Describe con detalle que necesitas, cuando, y que conocimientos previos tiene quien te ayudara...',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tags requeridos',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          tagsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (tags) => _TagsGrid(
              tags: tags,
              selected: selectedTagIds,
              onChanged: onTagsChanged,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _TagsGrid extends StatelessWidget {
  const _TagsGrid({
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
        final isSel = selected.contains(t.id);
        return FilterChip(
          label: Text(t.name),
          selected: isSel,
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

// ============================================================
// Step 3: condiciones + resumen
// ============================================================
class _Step3Conditions extends ConsumerWidget {
  const _Step3Conditions({
    required this.type,
    required this.difficulty,
    required this.onDifficultyChanged,
    required this.deadline,
    required this.onPickDeadline,
    required this.participants,
    required this.onParticipantsChanged,
    required this.benefitCtrl,
    required this.title,
    required this.selectedTagIds,
  });

  final RequestType type;
  final int difficulty;
  final ValueChanged<int> onDifficultyChanged;
  final DateTime? deadline;
  final VoidCallback onPickDeadline;
  final int participants;
  final ValueChanged<int> onParticipantsChanged;
  final TextEditingController benefitCtrl;
  final String title;
  final Set<String> selectedTagIds;

  static const _difficultyLabels = {
    1: 'Muy facil',
    2: 'Facil',
    3: 'Media',
    4: 'Dificil',
    5: 'Muy dificil',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagCatalogProvider);
    final tagNames = tagsAsync.value
            ?.where((t) => selectedTagIds.contains(t.id))
            .map((t) => t.name)
            .toList() ??
        const <String>[];
    final basePoints = basePointsByLevel[difficulty] ?? 0;
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Condiciones',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Define la dificultad, el plazo y si hay compensacion economica.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nivel de dificultad',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final level = i + 1;
              final sel = level == difficulty;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 4 ? 8 : 0),
                  child: OutlinedButton(
                    onPressed: () => onDifficultyChanged(level),
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          sel ? scheme.primaryContainer : null,
                      side: BorderSide(
                        color: sel
                            ? scheme.primary
                            : scheme.outlineVariant,
                        width: sel ? 2 : 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.bolt,
                          color: sel ? scheme.primary : scheme.outline,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$level',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: sel ? scheme.onPrimaryContainer : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _difficultyLabels[difficulty] ?? '',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              Text(
                '+$basePoints pts base',
                style: const TextStyle(
                  color: AppColors.pointsPositive,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Fecha limite estimada',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onPickDeadline,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              child: Text(
                deadline == null
                    ? 'mm/dd/yyyy'
                    : '${deadline!.day}/${deadline!.month}/${deadline!.year}',
                style: TextStyle(
                  color: deadline == null
                      ? scheme.onSurfaceVariant
                      : scheme.onSurface,
                ),
              ),
            ),
          ),
          if (type == RequestType.proyecto) ...[
            const SizedBox(height: 16),
            Text(
              'Cantidad de participantes',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                  onPressed: participants > 1
                      ? () => onParticipantsChanged(participants - 1)
                      : null,
                  child: const Text('-'),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$participants',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: participants < 10
                      ? () => onParticipantsChanged(participants + 1)
                      : null,
                  child: const Text('+'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Beneficio economico (opcional)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: benefitCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixText: 'S/. ',
              hintText: '0.00',
              helperText:
                  'Si lo dejas vacio se mostrara como "Voluntario / Sin remuneracion".',
            ),
          ),
          const SizedBox(height: 20),
          // Resumen
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  k: 'Tipo',
                  v: type == RequestType.proyecto ? 'Proyecto' : 'Asesoria',
                ),
                _SummaryRow(k: 'Titulo', v: title.isEmpty ? '—' : title),
                _SummaryRow(
                  k: 'Tags',
                  v: tagNames.isEmpty ? '—' : tagNames.join(', '),
                ),
                _SummaryRow(
                  k: 'Dificultad',
                  v: '$difficulty/5 — +$basePoints pts',
                ),
                _SummaryRow(
                  k: 'Fecha limite',
                  v: deadline == null
                      ? 'Sin fecha'
                      : '${deadline!.year}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.day.toString().padLeft(2, '0')}',
                ),
                _SummaryRow(
                  k: 'Compensacion',
                  v: benefitCtrl.text.trim().isEmpty
                      ? 'Voluntario'
                      : 'S/ ${benefitCtrl.text.trim()}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.k, required this.v});
  final String k;
  final String v;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$k:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              v,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
