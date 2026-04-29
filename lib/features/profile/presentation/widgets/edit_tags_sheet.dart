import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/auth_error_messages.dart';
import '../../../../shared/models/tag.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../requests/presentation/providers/requests_providers.dart';
import '../providers/profile_providers.dart';

class EditTagsSheet extends ConsumerStatefulWidget {
  const EditTagsSheet({required this.currentTags, super.key});
  final List<Tag> currentTags;

  static Future<void> show(BuildContext context, List<Tag> currentTags) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scroll) => EditTagsSheet(currentTags: currentTags),
      ),
    );
  }

  @override
  ConsumerState<EditTagsSheet> createState() => _EditTagsSheetState();
}

class _EditTagsSheetState extends ConsumerState<EditTagsSheet> {
  late Set<String> _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentTags.map((t) => t.id).toSet();
  }

  Future<void> _save() async {
    final uid = ref.read(currentSessionProvider)?.user.id;
    if (uid == null) return;

    final repo = ref.read(profileRepositoryProvider);
    final initial = widget.currentTags.map((t) => t.id).toSet();
    final toAdd = _selected.difference(initial);
    final toRemove = initial.difference(_selected);

    setState(() => _saving = true);
    try {
      for (final id in toAdd) {
        await repo.addTag(uid, id);
      }
      for (final id in toRemove) {
        await repo.removeTag(uid, id);
      }
      ref.invalidate(myTagsProvider);
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
    final allTagsAsync = ref.watch(tagCatalogProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mis especialidades',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: allTagsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (tags) {
                return SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((t) {
                      final isSelected = _selected.contains(t.id);
                      return FilterChip(
                        label: Text(t.name),
                        selected: isSelected,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _selected.add(t.id);
                          } else {
                            _selected.remove(t.id);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Text('Guardar especialidades'),
          ),
        ],
      ),
    );
  }
}
