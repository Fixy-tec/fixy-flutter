-- ============================================================
-- Fixy - Seed de demo (Sprint 3)
-- Crea 5 usuarios ficticios + tags asignados + 8 solicitudes con tags.
-- Tambien le pone tags al usuario real (Carlos Gutierrez).
-- ============================================================

-- ID del usuario real (Carlos)
-- Si necesitas cambiarlo, reemplaza este UUID en todo el archivo:
--   ffee63e2-d04a-4a36-a985-23c74e1f305c

-- ------------------------------------------------------------
-- 1) Crear 5 usuarios ficticios en auth.users
-- (con password 'fixy12345' por si quieres iniciar sesion como ellos)
-- ------------------------------------------------------------
do $$
declare
  v_users uuid[] := array[
    '11111111-1111-1111-1111-111111111111'::uuid,
    '22222222-2222-2222-2222-222222222222'::uuid,
    '33333333-3333-3333-3333-333333333333'::uuid,
    '44444444-4444-4444-4444-444444444444'::uuid,
    '55555555-5555-5555-5555-555555555555'::uuid
  ];
  v_emails text[] := array[
    'sofia.rios@tecsup.edu.pe',
    'luis.mendoza@tecsup.edu.pe',
    'jorge.paredes@tecsup.edu.pe',
    'marco.villanueva@tecsup.edu.pe',
    'ana.castillo@tecsup.edu.pe'
  ];
  v_names text[] := array[
    'Sofia Rios',
    'Luis Mendoza',
    'Jorge Paredes',
    'Marco Villanueva',
    'Ana Castillo'
  ];
  i int;
begin
  for i in 1..5 loop
    if not exists (select 1 from auth.users where id = v_users[i]) then
      insert into auth.users (
        instance_id, id, aud, role, email,
        encrypted_password, email_confirmed_at,
        raw_app_meta_data, raw_user_meta_data,
        created_at, updated_at,
        confirmation_token, email_change, email_change_token_new, recovery_token
      ) values (
        '00000000-0000-0000-0000-000000000000',
        v_users[i],
        'authenticated',
        'authenticated',
        v_emails[i],
        crypt('fixy12345', gen_salt('bf')),
        now(),
        '{"provider":"email","providers":["email"]}'::jsonb,
        jsonb_build_object('full_name', v_names[i]),
        now(), now(),
        '', '', '', ''
      );
    end if;
  end loop;
end $$;

-- ------------------------------------------------------------
-- 2) Completar perfiles (career, cycle, points, medal)
-- ------------------------------------------------------------
update public.profiles set career = 'Desarrollo de Software', cycle = 6, total_points = 4320, medal = 'diamante', avg_rating = 4.9, ratings_count = 23
  where id = '11111111-1111-1111-1111-111111111111';
update public.profiles set career = 'Desarrollo de Software', cycle = 5, total_points = 1240, medal = 'plata', avg_rating = 4.7, ratings_count = 15
  where id = '22222222-2222-2222-2222-222222222222';
update public.profiles set career = 'Redes y Comunicaciones', cycle = 4, total_points = 540, medal = 'bronce', avg_rating = 4.5, ratings_count = 8
  where id = '33333333-3333-3333-3333-333333333333';
update public.profiles set career = 'Diseno y Desarrollo de Software', cycle = 5, total_points = 3890, medal = 'diamante', avg_rating = 4.8, ratings_count = 19
  where id = '44444444-4444-4444-4444-444444444444';
update public.profiles set career = 'Mecatronica Industrial', cycle = 6, total_points = 8240, medal = 'maestro', avg_rating = 5.0, ratings_count = 31
  where id = '55555555-5555-5555-5555-555555555555';

-- Tambien le damos algunos puntos al usuario real para ver mejor el feed
update public.profiles set career = 'Desarrollo de Software', cycle = 5, total_points = 1240, medal = 'plata', avg_rating = 4.8, ratings_count = 15
  where id = 'ffee63e2-d04a-4a36-a985-23c74e1f305c';

-- ------------------------------------------------------------
-- 3) user_tags - especialidades de cada usuario
-- ------------------------------------------------------------
-- Helper inline para resolver slug -> id
-- Sofia: full-stack
insert into public.user_tags (user_id, tag_id)
select '11111111-1111-1111-1111-111111111111', id from public.tags where slug in ('flutter','dart','firebase','python','supabase')
on conflict do nothing;

-- Luis: algoritmos C++
insert into public.user_tags (user_id, tag_id)
select '22222222-2222-2222-2222-222222222222', id from public.tags where slug in ('cpp','algoritmos','estructuras','python')
on conflict do nothing;

-- Jorge: matematicas
insert into public.user_tags (user_id, tag_id)
select '33333333-3333-3333-3333-333333333333', id from public.tags where slug in ('matematicas','calculo','algebra','estadistica')
on conflict do nothing;

-- Marco: redes y linux
insert into public.user_tags (user_id, tag_id)
select '44444444-4444-4444-4444-444444444444', id from public.tags where slug in ('redes','linux','seguridad','cloud')
on conflict do nothing;

-- Ana: dev senior
insert into public.user_tags (user_id, tag_id)
select '55555555-5555-5555-5555-555555555555', id from public.tags where slug in ('javascript','typescript','react','nextjs','nodejs')
on conflict do nothing;

-- Carlos (usuario real): Flutter dev
insert into public.user_tags (user_id, tag_id)
select 'ffee63e2-d04a-4a36-a985-23c74e1f305c', id from public.tags where slug in ('flutter','dart','firebase','supabase','python')
on conflict do nothing;

-- ------------------------------------------------------------
-- 4) Crear 8 requests de demo
-- ------------------------------------------------------------
-- Limpiamos cualquier request previo de demo (re-ejecutable)
delete from public.requests where id in (
  '00000000-0000-0000-0000-00000000aaa1',
  '00000000-0000-0000-0000-00000000aaa2',
  '00000000-0000-0000-0000-00000000aaa3',
  '00000000-0000-0000-0000-00000000aaa4',
  '00000000-0000-0000-0000-00000000aaa5',
  '00000000-0000-0000-0000-00000000aaa6',
  '00000000-0000-0000-0000-00000000aaa7',
  '00000000-0000-0000-0000-00000000aaa8'
);

insert into public.requests
  (id, creator_id, type, title, description, difficulty_level, economic_benefit, participants_needed, status, deadline, published_at)
values
  ('00000000-0000-0000-0000-00000000aaa1', '22222222-2222-2222-2222-222222222222', 'asesoria',
   'Ayuda con algoritmos de ordenamiento en C++',
   'Necesito que me expliquen quicksort y mergesort con complejidad. Tengo examen el viernes.',
   3, null, 1, 'abierta', now()::date + 3, now() - interval '2 hours'),

  ('00000000-0000-0000-0000-00000000aaa2', '11111111-1111-1111-1111-111111111111', 'proyecto',
   'Socio para app de gestion de tareas en Flutter',
   'Estoy desarrollando una app tipo Todoist con Flutter + Firebase. Busco un socio frontend.',
   4, 50.00, 1, 'abierta', now()::date + 7, now() - interval '5 hours'),

  ('00000000-0000-0000-0000-00000000aaa3', '33333333-3333-3333-3333-333333333333', 'asesoria',
   'Repaso de calculo diferencial antes del parcial',
   'Necesito repasar derivadas, regla de la cadena y aplicaciones. 2 horas como maximo.',
   2, null, 1, 'abierta', now()::date + 1, now() - interval '1 day'),

  ('00000000-0000-0000-0000-00000000aaa4', '44444444-4444-4444-4444-444444444444', 'proyecto',
   'Socios para proyecto de domotica con Arduino',
   'Sistema de control de iluminacion y climatizacion via app. Necesito 2 socios: uno mobile y uno hardware.',
   5, null, 2, 'abierta', now()::date + 14, now() - interval '6 hours'),

  ('00000000-0000-0000-0000-00000000aaa5', '55555555-5555-5555-5555-555555555555', 'asesoria',
   'Revision de proyecto en Next.js con autenticacion',
   'Tengo el proyecto casi listo pero falla el SSR con cookies. Busco a alguien con experiencia en Next 14.',
   4, 30.00, 1, 'abierta', now()::date + 5, now() - interval '12 hours'),

  ('00000000-0000-0000-0000-00000000aaa6', '11111111-1111-1111-1111-111111111111', 'asesoria',
   'Configuracion de Supabase + RLS para mi proyecto',
   'Soy nuevo en Supabase y necesito ayuda con Row Level Security y policies.',
   3, null, 1, 'abierta', now()::date + 4, now() - interval '3 hours'),

  ('00000000-0000-0000-0000-00000000aaa7', '44444444-4444-4444-4444-444444444444', 'asesoria',
   'Configurar servidor Linux para clase de redes',
   'Necesito ayuda configurando un servidor con Ubuntu Server, OpenSSH y un firewall basico.',
   2, null, 1, 'abierta', now()::date + 2, now() - interval '4 hours'),

  ('00000000-0000-0000-0000-00000000aaa8', '22222222-2222-2222-2222-222222222222', 'proyecto',
   'App de inventario para bodega - busco backend',
   'Tengo el frontend en Flutter, necesito alguien que arme el backend con Supabase.',
   4, 80.00, 1, 'abierta', now()::date + 10, now() - interval '8 hours');

-- ------------------------------------------------------------
-- 5) request_tags
-- ------------------------------------------------------------
-- aaa1: C++, Algoritmos, Estructuras
insert into public.request_tags (request_id, tag_id)
select '00000000-0000-0000-0000-00000000aaa1', id from public.tags where slug in ('cpp','algoritmos','estructuras')
on conflict do nothing;

-- aaa2: Flutter, Dart, Firebase
insert into public.request_tags (request_id, tag_id)
select '00000000-0000-0000-0000-00000000aaa2', id from public.tags where slug in ('flutter','dart','firebase')
on conflict do nothing;

-- aaa3: Matematicas, Calculo
insert into public.request_tags (request_id, tag_id)
select '00000000-0000-0000-0000-00000000aaa3', id from public.tags where slug in ('matematicas','calculo')
on conflict do nothing;

-- aaa4: Arduino, Domotica, Flutter
insert into public.request_tags (request_id, tag_id)
select '00000000-0000-0000-0000-00000000aaa4', id from public.tags where slug in ('arduino','domotica','flutter','electronica')
on conflict do nothing;

-- aaa5: Next.js, TypeScript, React
insert into public.request_tags (request_id, tag_id)
select '00000000-0000-0000-0000-00000000aaa5', id from public.tags where slug in ('nextjs','typescript','react')
on conflict do nothing;

-- aaa6: Supabase, Bases de datos, SQL
insert into public.request_tags (request_id, tag_id)
select '00000000-0000-0000-0000-00000000aaa6', id from public.tags where slug in ('supabase','bases-datos','sql')
on conflict do nothing;

-- aaa7: Linux, Redes
insert into public.request_tags (request_id, tag_id)
select '00000000-0000-0000-0000-00000000aaa7', id from public.tags where slug in ('linux','redes')
on conflict do nothing;

-- aaa8: Flutter, Supabase, Dart
insert into public.request_tags (request_id, tag_id)
select '00000000-0000-0000-0000-00000000aaa8', id from public.tags where slug in ('flutter','supabase','dart')
on conflict do nothing;

-- Listo! Ya tienes 8 solicitudes con creadores variados, tags y dificultades.
