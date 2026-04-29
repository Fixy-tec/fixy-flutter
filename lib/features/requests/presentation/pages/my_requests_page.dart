import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/application_summary.dart';
import '../../../../shared/models/request_summary.dart';
import '../../../../shared/widgets/request_card.dart';
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

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.item});
  final ApplicationSummary item;

  @override
  Widget build(BuildContext context) {
    final isApproved = item.status == ApplicationStatus.aprobada;
    return Card(
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

class _CreatedCard extends StatelessWidget {
  const _CreatedCard({required this.request});
  final RequestSummary request;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    return _SimpleRequestList(
      async: async,
      emptyText: 'Aun no has completado solicitudes',
      onRefresh: () => ref.refresh(myCompletedProvider.future),
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
            itemBuilder: (context, i) => RequestCard(request: items[i]),
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
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(text, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text('Error: $error', textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
