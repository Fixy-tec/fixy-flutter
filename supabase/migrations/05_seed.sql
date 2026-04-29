-- ============================================================
-- Fixy - Seed inicial de tags
-- ============================================================

insert into public.tags (name, slug, is_custom) values
  -- Lenguajes
  ('Python',      'python',      false),
  ('Dart',        'dart',        false),
  ('Java',        'java',        false),
  ('JavaScript',  'javascript',  false),
  ('TypeScript',  'typescript',  false),
  ('C++',         'cpp',         false),
  ('C#',          'csharp',      false),
  ('Go',          'go',          false),
  ('Rust',        'rust',        false),
  ('SQL',         'sql',         false),
  -- Frameworks / Plataformas
  ('Flutter',     'flutter',     false),
  ('React',       'react',       false),
  ('Next.js',     'nextjs',      false),
  ('Node.js',     'nodejs',      false),
  ('Spring Boot', 'spring-boot', false),
  ('Django',      'django',      false),
  ('Firebase',    'firebase',    false),
  ('Supabase',    'supabase',    false),
  -- Areas
  ('Algoritmos',     'algoritmos',     false),
  ('Estructuras',    'estructuras',    false),
  ('Bases de datos', 'bases-datos',    false),
  ('Redes',          'redes',          false),
  ('Linux',          'linux',          false),
  ('Cloud',          'cloud',          false),
  ('DevOps',         'devops',         false),
  ('Seguridad',      'seguridad',      false),
  ('Machine Learning','machine-learning', false),
  ('Diseño UX',      'diseno-ux',      false),
  ('Diseño UI',      'diseno-ui',      false),
  -- Hardware / IoT
  ('Arduino',     'arduino',     false),
  ('Raspberry Pi','raspberry-pi',false),
  ('Electronica', 'electronica', false),
  ('Domotica',    'domotica',    false),
  -- Cursos clasicos
  ('Matematicas',         'matematicas',         false),
  ('Calculo',             'calculo',             false),
  ('Algebra',             'algebra',             false),
  ('Estadistica',         'estadistica',         false),
  ('Fisica',              'fisica',              false),
  ('Logica de programacion','logica-programacion',false)
on conflict (slug) do nothing;
