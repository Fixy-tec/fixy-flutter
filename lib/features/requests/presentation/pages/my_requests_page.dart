import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_error_messages.dart';
import '../../../../shared/models/application_summary.dart';
import '../../../../shared/models/request_summary.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/request_card.dart';
import '../../../applications/presentation/providers/applications_providers.dart';
import '../../../feed/presentation/providers/feed_providers.dart';
import '../../../ratings/presentation/providers/ratings_providers.dart';
import '../providers/requests_providers.dart';
import '../widgets/status_chip.dart';

class MyRequestsPage extends ConsumerStatefulWidget {
  const MyRequestsPage({super.key});

  @override
  ConsumerState<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends ConsumerState<MyRequestsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis solicitudes'),
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Postulaciones'),
            Tab(text: 'Creadas'),
            Tab(text: 'En proceso'),
            Tab(text: 'Completadas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          _ApplicationsTab(),
          _CreatedTab(),
          _InProcessTab(),
          _CompletedTab(),
        ],
      ),
    );
  }
}

// ---------------- Postulaciones ----------------

class _ApplicationsTab extends ConsumerWidget {
  const _ApplicationsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myApplicationsProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(myApplicationsProvider.future),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(error: e),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyView(text: 'Aun no te has postulado a nada');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _ApplicationCard(item: items[i]),
          );
        },
      ),
    );
  }
}

class _ApplicationCard extends ConsumerWidget {
  const _ApplicationCard({required this.item});
  final ApplicationSummary item;

  Future<void> _withdraw(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Retirar postulacion'),
        content: const Text('Tu postulacion sera eliminada. ¿Continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Retirar'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(applicationsRepositoryProvider).withdraw(item.id);
      ref.invalidate(myApplicationsProvider);
      ref.invalidate(applicantsForRequestProvider(item.requestId));
      ref.invalidate(myApplicationOnRequestProvider(item.requestId));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Postulacion retirada')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApproved = item.status == ApplicationStatus.aprobada;
    final isPending = item.status == ApplicationStatus.pendiente;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/requests/${item.requestId}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.request.type == RequestType.proyecto
                        ? 'Proyecto'
                        : 'Asesoria',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                StatusChip.application(item.status),
                if (isPending)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (v) {
                      if (v == 'withdraw') _withdraw(context, ref);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'withdraw',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Retirar postulacion'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.request.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (isApproved) ...[
              const SizedBox(height: 6),
              Text(
                'Contacto desbloqueado · ver WhatsApp',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }
}

// ---------------- Creadas ----------------

class _CreatedTab extends ConsumerWidget {
  const _CreatedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myCreatedRequestsProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(myCreatedRequestsProvider.future),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(error: e),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyView(text: 'Aun no has creado ninguna solicitud');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _CreatedCard(request: items[i]),
          );
        },
      ),
    );
  }
}

class _CreatedCard extends ConsumerWidget {
  const _CreatedCard({required this.request});
  final RequestSummary request;

  bool get _canCancel =>
      request.status == RequestStatus.abierta ||
      request.status == RequestStatus.enRevision;
  bool get _canDelete => _canCancel && request.applicationsCount == 0;

  Future<void> _onCancel(BuildContext context, WidgetRef ref) async {
    final ok = await _confirm(context,
        title: 'Cancelar solicitud',
        message:
            'La solicitud quedara cancelada. Los postulantes ya no podran aceptar.',
        action: 'Cancelar solicitud');
    if (!ok) return;
    try {
      await ref.read(requestsRepositoryProvider).cancelRequest(request.id);
      ref.invalidate(myCreatedRequestsProvider);
      ref.invalidate(feedProvider);
      if (!context.mounted) return;
      _toast(context, 'Solicitud cancelada');
    } catch (e) {
      if (!context.mounted) return;
      _toast(context, authErrorMessage(e));
    }
  }

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    final ok = await _confirm(context,
        title: 'Eliminar solicitud',
        message: 'Esta accion es permanente y no se puede deshacer.',
        action: 'Eliminar');
    if (!ok) return;
    try {
      await ref.read(requestsRepositoryProvider).deleteRequest(request.id);
      ref.invalidate(myCreatedRequestsProvider);
      ref.invalidate(feedProvider);
      if (!context.mounted) return;
      _toast(context, 'Solicitud eliminada');
    } catch (e) {
      if (!context.mounted) return;
      _toast(context, authErrorMessage(e));
    }
  }

  void _toast(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<bool> _confirm(BuildContext context,
      {required String title,
      required String message,
      required String action}) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(action),
          ),
        ],
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/requests/${request.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.type == RequestType.proyecto
                        ? 'Proyecto'
                        : 'Asesoria',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                StatusChip.request(request.status),
                if (_canCancel)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (v) {
                      if (v == 'cancel') _onCancel(context, ref);
                      if (v == 'delete') _onDelete(context, ref);
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'cancel',
                        child: ListTile(
                          leading: Icon(Icons.block_outlined),
                          title: Text('Cancelar'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      if (_canDelete)
                        const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline,
                                color: AppColors.statusRejected),
                            title: Text('Eliminar',
                                style: TextStyle(
                                    color: AppColors.statusRejected)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              request.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '${request.applicationsCount} ${request.applicationsCount == 1 ? "postulante" : "postulantes"}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

// ---------------- En proceso ----------------

class _InProcessTab extends ConsumerWidget {
  const _InProcessTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myInProcessProvider);
    return _SimpleRequestList(
      async: async,
      emptyText: 'No tienes solicitudes en proceso',
      onRefresh: () => ref.refresh(myInProcessProvider.future),
    );
  }
}

// ---------------- Completadas ----------------

class _CompletedTab extends ConsumerWidget {
  const _CompletedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myCompletedProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(myCompletedProvider.future),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => _ErrorView(error: e),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyView(text: 'Aun no has completado solicitudes');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _CompletedCard(request: items[i]),
          );
        },
      ),
    );
  }
}

class _CompletedCard extends ConsumerWidget {
  const _CompletedCard({required this.request});
  final RequestSummary request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookup = CounterpartLookup(
      requestId: request.id,
      creatorId: request.creator.id,
    );
    final counterpartAsync = ref.watch(counterpartIdProvider(lookup));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/requests/${request.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.type == RequestType.proyecto
                          ? 'Proyecto'
                          : 'Asesoria',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  StatusChip.request(request.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              counterpartAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, st) => const SizedBox.shrink(),
                data: (counterpartId) {
                  if (counterpartId == null) return const SizedBox.shrink();
                  final hasRatedAsync = ref.watch(hasRatedProvider(
                    RatingExistsLookup(
                      requestId: request.id,
                      ratedId: counterpartId,
                    ),
                  ));
                  return hasRatedAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (e, st) => const SizedBox.shrink(),
                    data: (rated) => Row(
                      children: [
                        Icon(
                          rated
                              ? Icons.check_circle_outline
                              : Icons.star_outline,
                          size: 16,
                          color: rated
                              ? Theme.of(context).colorScheme.primary
                              : AppColors.warning,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          rated ? 'Ya calificaste' : 'Pendiente de calificar',
                          style: TextStyle(
                            color: rated
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : AppColors.warning,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleRequestList extends StatelessWidget {
  const _SimpleRequestList({
    required this.async,
    required this.emptyText,
    required this.onRefresh,
  });

  final AsyncValue<List<RequestSummary>> async;
  final String emptyText;
  final Future<List<RequestSummary>> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(error: e),
        data: (items) {
          if (items.isEmpty) return _EmptyView(text: emptyText);
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) => RequestCard(
              request: items[i],
              onTap: () => context.push('/requests/${items[i].id}'),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.assignment_outlined,
      title: text,
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) {
    return ErrorRetry(error: error);
  }
}
