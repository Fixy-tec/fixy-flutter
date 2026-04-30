import 'package:flutter/material.dart';

/// Estado vacio reusable.
/// - Por defecto se renderiza dentro de un ListView (para que pull-to-refresh
///   y constraints sin altura infinita funcionen como root).
/// - Si lo embebes dentro de otro ListView/CustomScrollView, pasa
///   `inline: true` para que use un Column en lugar de un scroll propio.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.inline = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final body = <Widget>[
      Icon(icon, size: 64, color: scheme.onSurfaceVariant),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ),
      ],
      if (action != null) ...[
        const SizedBox(height: 24),
        Center(child: action),
      ],
    ];

    if (inline) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: body,
        ),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [const SizedBox(height: 80), ...body],
    );
  }
}

/// Estado de error con boton de reintento.
/// Misma logica de `inline` que [EmptyState].
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({
    required this.error,
    this.onRetry,
    this.inline = false,
    super.key,
  });

  final Object error;
  final VoidCallback? onRetry;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final body = <Widget>[
      Icon(Icons.error_outline, size: 64, color: scheme.error),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          'Algo salio mal',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          '$error',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ),
      if (onRetry != null) ...[
        const SizedBox(height: 24),
        Center(
          child: OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ),
      ],
    ];

    if (inline) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: body,
        ),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [const SizedBox(height: 80), ...body],
    );
  }
}
