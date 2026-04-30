import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_error_messages.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../requests/presentation/providers/requests_providers.dart';
import '../providers/ratings_providers.dart';

class RatingSheet extends ConsumerStatefulWidget {
  const RatingSheet({
    required this.requestId,
    required this.ratedId,
    required this.ratedName,
    super.key,
  });

  final String requestId;
  final String ratedId;
  final String ratedName;

  static Future<bool?> show(
    BuildContext context, {
    required String requestId,
    required String ratedId,
    required String ratedName,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RatingSheet(
          requestId: requestId,
          ratedId: ratedId,
          ratedName: ratedName,
        ),
      ),
    );
  }

  @override
  ConsumerState<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends ConsumerState<RatingSheet> {
  int _stars = 5;
  final _commentCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final myId = ref.read(currentSessionProvider)?.user.id;
    if (myId == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(ratingsRepositoryProvider).rate(
            requestId: widget.requestId,
            raterId: myId,
            ratedId: widget.ratedId,
            stars: _stars,
            comment: _commentCtrl.text.trim().isEmpty
                ? null
                : _commentCtrl.text.trim(),
          );
      // Invalidar caches afectados
      ref.invalidate(hasRatedProvider(RatingExistsLookup(
        requestId: widget.requestId,
        ratedId: widget.ratedId,
      )));
      ref.invalidate(myRatingsReceivedProvider);
      ref.invalidate(myRankProvider);
      ref.invalidate(myWeeklyDeltaProvider);
      ref.invalidate(currentUserProvider);
      ref.invalidate(myCompletedProvider);
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
            'Calificar a ${widget.ratedName}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tu calificacion afecta los puntos del usuario.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < _stars;
              return IconButton(
                iconSize: 36,
                onPressed: () => setState(() => _stars = i + 1),
                icon: Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: AppColors.medalOro,
                ),
              );
            }),
          ),
          Text(
            _stars == 5
                ? 'Excelente (+50% bonus)'
                : _stars == 4
                    ? 'Muy bueno (+20%)'
                    : _stars == 3
                        ? 'Aceptable (puntos base)'
                        : _stars == 2
                            ? 'Regular (-30 pts)'
                            : 'Mala experiencia (-80 pts)',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentCtrl,
            maxLength: 200,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Comentario (opcional)',
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
                : const Text('Enviar calificacion'),
          ),
        ],
      ),
    );
  }
}
