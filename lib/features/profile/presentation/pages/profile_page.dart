import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/whatsapp_editor_sheet.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesion',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Sin sesion'));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 48,
                child: Text(
                  user.fullName.isNotEmpty
                      ? user.fullName.substring(0, 1).toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '${user.career ?? "—"} · Ciclo ${user.cycle ?? "—"}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _StatRow(label: 'Puntos', value: '${user.totalPoints}'),
              _StatRow(label: 'Medalla', value: user.medal.name),
              _StatRow(
                label: 'Calificacion',
                value: user.ratingsCount == 0
                    ? '—'
                    : '${user.avgRating.toStringAsFixed(2)} (${user.ratingsCount})',
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('WhatsApp'),
                  subtitle: Text(
                    user.whatsappNumber ?? 'No configurado',
                  ),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => WhatsappEditorSheet.show(
                    context,
                    user.whatsappNumber,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pantalla completa en Sprint 6',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).hintColor),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
