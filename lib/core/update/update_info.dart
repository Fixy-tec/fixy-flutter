/// Resultado de la verificacion de updates contra GitHub Releases.
class UpdateInfo {
  const UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.apkUrl,
    required this.releaseNotes,
    required this.releaseUrl,
  });

  final String currentVersion;
  final String latestVersion;
  final String apkUrl;
  final String releaseNotes;
  final String releaseUrl;

  /// Compara dos versiones tipo "1.0.0" semanticamente.
  /// Retorna true si latest > current.
  static bool isNewerVersion(String current, String latest) {
    int cmp(List<int> a, List<int> b) {
      final n = a.length > b.length ? a.length : b.length;
      for (var i = 0; i < n; i++) {
        final ai = i < a.length ? a[i] : 0;
        final bi = i < b.length ? b[i] : 0;
        if (ai != bi) return bi.compareTo(ai);
      }
      return 0;
    }

    List<int> parse(String v) {
      final clean = v.startsWith('v') ? v.substring(1) : v;
      return clean
          .split('+')[0]
          .split('-')[0]
          .split('.')
          .map((p) => int.tryParse(p) ?? 0)
          .toList();
    }

    return cmp(parse(current), parse(latest)) > 0;
  }
}
