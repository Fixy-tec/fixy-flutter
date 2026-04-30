/// Formato relativo en espanol simple. "hace 2 min", "hace 1 dia", etc.
String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inSeconds < 60) return 'hace un momento';
  if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
  if (diff.inHours < 24) {
    return diff.inHours == 1 ? 'hace 1 hora' : 'hace ${diff.inHours} horas';
  }
  if (diff.inDays == 1) return 'ayer';
  if (diff.inDays < 7) return 'hace ${diff.inDays} dias';
  if (diff.inDays < 30) {
    final w = (diff.inDays / 7).floor();
    return w == 1 ? 'hace 1 semana' : 'hace $w semanas';
  }
  if (diff.inDays < 365) {
    final m = (diff.inDays / 30).floor();
    return m == 1 ? 'hace 1 mes' : 'hace $m meses';
  }
  final y = (diff.inDays / 365).floor();
  return y == 1 ? 'hace 1 ano' : 'hace $y anos';
}
