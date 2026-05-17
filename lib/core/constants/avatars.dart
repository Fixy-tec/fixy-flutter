/// Catalogo de avatares disponibles. Cada usuario elige uno al registrarse.
class AvatarChoice {
  const AvatarChoice({required this.slug, required this.label});
  final String slug;
  final String label;

  String get assetPath => 'assets/avatars/$slug.png';
}

const avatarChoices = <AvatarChoice>[
  AvatarChoice(slug: 'arte', label: 'Artista'),
  AvatarChoice(slug: 'cyborg', label: 'Cyborg'),
  AvatarChoice(slug: 'hacker', label: 'Hacker'),
  AvatarChoice(slug: 'karate', label: 'Karateka'),
  AvatarChoice(slug: 'money', label: 'Emprendedor'),
  AvatarChoice(slug: 'pirata', label: 'Pirata'),
];

String? avatarAssetFor(String? slug) {
  if (slug == null) return null;
  for (final a in avatarChoices) {
    if (a.slug == slug) return a.assetPath;
  }
  return null;
}
