import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/reputation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_error_messages.dart';
import '../../../../shared/models/request_summary.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../applications/presentation/providers/applications_providers.dart';
import '../../../feed/presentation/providers/feed_providers.dart';
import '../providers/requests_providers.dart';

/// Edicion de una solicitud existente. Pre-llena los campos con los valores
/// actuales y guarda solo lo que cambio.
///
/// Reglas de negocio (validadas en UI; RLS valida que sea el creador):
///   - Solo editable si status es 'abierta' o 'en_revision'.
///   - El tipo (asesoria/proyecto) NO se puede cambiar despues de crear.
class EditRequestPage extends ConsumerStatefulWidget {
  const EditRequestPage({required this.requestId, super.key});
  final String requestId;

  @override
  ConsumerState<EditRequestPage> createState() => _EditRequestPageState();
}

class _EditRequestPageState extends ConsumerState<EditRequestPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _benefitCtrl;
  late TextEditingController _participantsCtrl;

  int _difficulty = 3;
  DateTime? _deadline;
  Set<String> _selectedTagIds = {};
  bool _saving = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _benefitCtrl = TextEditingController();
    _participantsCtrl = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _benefitCtrl.dispose();
    _participantsCtrl.dispose();
    super.dispose();
  }

  void _initFromRequest(RequestSummary r) {
    if (_initialized) return;
    _titleCtrl.text = r.title;
    _descCtrl.text = r.description;
    _benefitCtrl.text = r.economicBenefit?.toString() ?? '';
    _participantsCtrl.text = r.participantsNeeded.toString();
    _difficulty = r.difficultyLevel;
    _deadline = r.deadline;
    _selectedTagIds = r.tags.map((t) => t.id).toSet();
    _initialized = true;
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      locale: const Locale('es'),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save(RequestSummary original) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTagIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un tag')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final benefitText = _benefitCtrl.text.trim();
      final parsedBenefit =
          benefitText.isEmpty ? null : num.tryParse(benefitText);

      await ref.read(requestsRepositoryProvider).updateRequest(
            requestId: widget.requestId,
            title: _titleCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            difficultyLevel: _difficulty,
            economicBenefit: parsedBenefit,
            clearEconomicBenefit:
                parsedBenefit == null && original.economicBenefit != null,
            participantsNeeded:
                int.tryParse(_participantsCtrl.text.trim()) ?? 1,
            deadline: _deadline,
            clearDeadline: _deadline == null && original.deadline != null,
            tagIds: _selectedTagIds.toList(),
          );

      ref.invalidate(feedProvider);
      ref.invalidate(myCreatedRequestsProvider);
      ref.invalidate(requestDetailProvider(widget.requestId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud actualizada')),
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
    final detailAsync = ref.watch(requestDetailProvider(widget.requestId));
    final tagsAsync = ref.watch(tagCatalogProvider);
    final basePoints = basePointsByLevel[_difficulty] ?? 0;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar solicitud'),
        actions: [
          if (detailAsync.value != null)
            TextButton(
              onPressed: _saving
                  ? null
                  : () => _save(detailAsync.value!),
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Guardar'),
            ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorRetry(
          error: e,
          onRetry: () => ref.invalidate(requestDetailProvider(widget.requestId)),
        ),
        data: (request) {
          if (request == null) {
            return const EmptyState(
              icon: Icons.error_outline,
              title: 'Solicitud no encontrada',
            );
          }

          // Verifica que la solicitud sea editable
          final editable = request.status == RequestStatus.abierta ||
              request.status == RequestStatus.enRevision;
          if (!editable) {
            return EmptyState(
              icon: Icons.lock_outline,
              title: 'No se puede editar',
              subtitle:
                  'Esta solicitud ya está ${_statusLabel(request.status)} y no puede modificarse.',
              action: FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Volver'),
              ),
            );
          }

          _initFromRequest(request);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Tipo (read-only)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        request.type == RequestType.proyecto
                            ? Icons.rocket_launch_outlined
                            : Icons.menu_book_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        request.type == RequestType.proyecto
                            ? 'Proyecto'
                            : 'Asesoria',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        'No modificable',
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleCtrl,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Titulo',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length < 10) {
                      return 'Minimo 10 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  maxLength: 1000,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descripcion',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length < 20) {
                      return 'Minimo 20 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Tags',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                tagsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                  data: (tags) => Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: tags.map((t) {
                      final isSel = _selectedTagIds.contains(t.id);
                      return FilterChip(
                        label: Text(t.name),
                        selected: isSel,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _selectedTagIds.add(t.id);
                          } else {
                            _selectedTagIds.remove(t.id);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
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
                    final sel = level == _difficulty;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 4 ? 8 : 0),
                        child: OutlinedButton(
                          onPressed: () =>
                              setState(() => _difficulty = level),
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                sel ? scheme.primaryContainer : null,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            '$level',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: sel ? scheme.onPrimaryContainer : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '+$basePoints pts base',
                  style: const TextStyle(
                    color: AppColors.pointsPositive,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Fecha limite',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
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
                    ),
                    if (_deadline != null)
                      IconButton(
                        tooltip: 'Quitar fecha',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _deadline = null),
                      ),
                  ],
                ),
                if (request.type == RequestType.proyecto) ...[
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
                        onPressed: () {
                          final current =
                              int.tryParse(_participantsCtrl.text) ?? 1;
                          if (current > 1) {
                            setState(() {
                              _participantsCtrl.text = (current - 1).toString();
                            });
                          }
                        },
                        child: const Text('-'),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            _participantsCtrl.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          final current =
                              int.tryParse(_participantsCtrl.text) ?? 1;
                          if (current < 10) {
                            setState(() {
                              _participantsCtrl.text = (current + 1).toString();
                            });
                          }
                        },
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
                  controller: _benefitCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    prefixText: 'S/. ',
                    hintText: '0.00',
                    helperText: 'Deja vacio para "Voluntario"',
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _saving ? null : () => _save(request),
                  icon: const Icon(Icons.save_outlined),
                  label: _saving
                      ? const Text('Guardando...')
                      : const Text('Guardar cambios'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(RequestStatus s) => switch (s) {
        RequestStatus.abierta => 'abierta',
        RequestStatus.enRevision => 'en revision',
        RequestStatus.enProceso => 'en proceso',
        RequestStatus.completada => 'completada',
        RequestStatus.cancelada => 'cancelada',
      };
}
