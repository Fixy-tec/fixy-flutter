/// Reglas de reputacion (espejo de las funciones SQL en supabase/migrations/02_functions.sql).
/// El calculo final ocurre en Postgres - estos valores son solo para mostrar en UI.
library;

enum Medal { hierro, bronce, plata, oro, diamante, maestro, challenger }

class MedalRange {
  const MedalRange(this.medal, this.minPoints, this.maxPoints);
  final Medal medal;
  final int minPoints;
  final int? maxPoints;
}

const medalLadder = <MedalRange>[
  MedalRange(Medal.hierro, 0, 299),
  MedalRange(Medal.bronce, 300, 799),
  MedalRange(Medal.plata, 800, 1799),
  MedalRange(Medal.oro, 1800, 3499),
  MedalRange(Medal.diamante, 3500, 5999),
  MedalRange(Medal.maestro, 6000, 9999),
  MedalRange(Medal.challenger, 10000, null),
];

Medal medalFromPoints(int points) {
  for (final r in medalLadder) {
    if (points >= r.minPoints && (r.maxPoints == null || points <= r.maxPoints!)) {
      return r.medal;
    }
  }
  return Medal.hierro;
}

/// Puntos base por nivel de dificultad.
const basePointsByLevel = <int, int>{
  1: 50,
  2: 100,
  3: 180,
  4: 280,
  5: 400,
};
