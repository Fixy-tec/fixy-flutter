import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/avatars.dart';
import '../../../../core/utils/auth_error_messages.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/models/tag.dart';
import '../../../requests/presentation/providers/requests_providers.dart';
import '../../data/auth_repository.dart';
import '../providers/auth_providers.dart';

/// Registro en 4 pasos:
/// 0. Correo + password + nombre + carrera + ciclo (obligatorio)
/// 1. Tags (opcional)
/// 2. Avatar (opcional)
/// 3. WhatsApp + bio (opcional)
/// 4. Links GitHub/LinkedIn/Portfolio (opcional)
///
/// El primer paso es obligatorio porque sin password no hay cuenta;
/// los demas pueden saltarse y completarse despues desde el perfil.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _pageCtrl = PageController();
  int _step = 0;
  bool _saving = false;

  // Paso 0
  final _formStep0 = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _careerCtrl = TextEditingController();
  final _cycleCtrl = TextEditingController();
  bool _obscure = true;

  // Paso 1: tags
  final Set<String> _selectedTagIds = {};

  // Paso 2: avatar
  String? _avatarSlug;

  // Paso 3
  final _whatsappCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  // Paso 4
  final _githubCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  final _portfolioCtrl = TextEditingController();

  static const _totalSteps = 5;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    _careerCtrl.dispose();
    _cycleCtrl.dispose();
    _whatsappCtrl.dispose();
    _bioCtrl.dispose();
    _githubCtrl.dispose();
    _linkedinCtrl.dispose();
    _portfolioCtrl.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    setState(() => _step = step);
    _pageCtrl.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (_step == 0) {
      if (!_formStep0.currentState!.validate()) return;
    }
    if (_step < _totalSteps - 1) {
      _goTo(_step + 1);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step == 0) {
      context.pop();
    } else {
      _goTo(_step - 1);
    }
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      await ref.read(authRepositoryProvider).signUp(
            SignUpData(
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text,
              fullName: _fullNameCtrl.text.trim(),
              career: _careerCtrl.text.trim().isEmpty
                  ? null
                  : _careerCtrl.text.trim(),
              cycle: int.tryParse(_cycleCtrl.text.trim()),
              avatarSlug: _avatarSlug,
              whatsappNumber: _whatsappCtrl.text.trim().isEmpty
                  ? null
                  : _whatsappCtrl.text.trim(),
              bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
              githubUrl: _githubCtrl.text.trim().isEmpty
                  ? null
                  : _githubCtrl.text.trim(),
              linkedinUrl: _linkedinCtrl.text.trim().isEmpty
                  ? null
                  : _linkedinCtrl.text.trim(),
              portfolioUrl: _portfolioCtrl.text.trim().isEmpty
                  ? null
                  : _portfolioCtrl.text.trim(),
              tagIds: _selectedTagIds.toList(),
            ),
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        title: Text('Paso ${_step + 1} de $_totalSteps'),
      ),
      body: Column(
        children: [
          _StepBar(step: _step, total: _totalSteps),
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _step = i),
              children: [
                _Step0Basic(
                  formKey: _formStep0,
                  emailCtrl: _emailCtrl,
                  passwordCtrl: _passwordCtrl,
                  fullNameCtrl: _fullNameCtrl,
                  careerCtrl: _careerCtrl,
                  cycleCtrl: _cycleCtrl,
                  obscure: _obscure,
                  onToggleObscure: () => setState(() => _obscure = !_obscure),
                ),
                _Step1Tags(
                  selected: _selectedTagIds,
                  onChanged: (ids) => setState(() {
                    _selectedTagIds
                      ..clear()
                      ..addAll(ids);
                  }),
                ),
                _Step2Avatar(
                  selected: _avatarSlug,
                  onChanged: (s) => setState(() => _avatarSlug = s),
                ),
                _Step3About(
                  whatsappCtrl: _whatsappCtrl,
                  bioCtrl: _bioCtrl,
                ),
                _Step4Links(
                  githubCtrl: _githubCtrl,
                  linkedinCtrl: _linkedinCtrl,
                  portfolioCtrl: _portfolioCtrl,
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : _back,
                        child: const Text('Atras'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _next,
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.4),
                            )
                          : Text(
                              _step == _totalSteps - 1
                                  ? 'Crear cuenta'
                                  : 'Continuar',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Step bar
// ============================================================
class _StepBar extends StatelessWidget {
  const _StepBar({required this.step, required this.total});
  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: List.generate(total, (i) {
          final active = i <= step;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: active ? scheme.primary : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================
// Step 0: cuenta basica
// ============================================================
class _Step0Basic extends StatelessWidget {
  const _Step0Basic({
    required this.formKey,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.fullNameCtrl,
    required this.careerCtrl,
    required this.cycleCtrl,
    required this.obscure,
    required this.onToggleObscure,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController fullNameCtrl;
  final TextEditingController careerCtrl;
  final TextEditingController cycleCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Crea tu cuenta',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Solo necesitas tu correo institucional.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: fullNameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => validateRequired(v, fieldName: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Correo Tecsup',
                hintText: 'tunombre@tecsup.edu.pe',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: validateTecsupEmail,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: careerCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Carrera',
                hintText: 'Ej: Desarrollo de Software',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              validator: (v) => validateRequired(v, fieldName: 'Carrera'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: cycleCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: const InputDecoration(
                labelText: 'Ciclo (1-10)',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Ingresa el ciclo';
                final n = int.tryParse(v);
                if (n == null || n < 1 || n > 10) return 'Entre 1 y 10';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: passwordCtrl,
              obscureText: obscure,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: 'Contrasena',
                helperText: 'Minimo 8 caracteres',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: onToggleObscure,
                ),
              ),
              validator: validatePassword,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Step 1: tags
// ============================================================
class _Step1Tags extends ConsumerWidget {
  const _Step1Tags({required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagCatalogProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cuales son tus tecnologias?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Esto nos ayuda a mostrarte solicitudes relevantes. Puedes saltar este paso.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          tagsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (tags) => _TagsGrid(
              tags: tags,
              selected: selected,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _TagsGrid extends StatelessWidget {
  const _TagsGrid({
    required this.tags,
    required this.selected,
    required this.onChanged,
  });
  final List<Tag> tags;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((t) {
        final isSel = selected.contains(t.id);
        return FilterChip(
          label: Text(t.name),
          selected: isSel,
          onSelected: (v) {
            final next = {...selected};
            if (v) {
              next.add(t.id);
            } else {
              next.remove(t.id);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}

// ============================================================
// Step 2: avatar
// ============================================================
class _Step2Avatar extends StatelessWidget {
  const _Step2Avatar({required this.selected, required this.onChanged});
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elige tu avatar',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sera tu imagen de perfil dentro de Fixy. Puedes cambiarlo despues.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: avatarChoices.map((a) {
              final isSel = selected == a.slug;
              return InkWell(
                onTap: () => onChanged(isSel ? null : a.slug),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSel
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: isSel ? 2.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(a.assetPath, fit: BoxFit.contain),
                      ),
                      if (isSel)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 22,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Step 3: about
// ============================================================
class _Step3About extends StatelessWidget {
  const _Step3About({required this.whatsappCtrl, required this.bioCtrl});
  final TextEditingController whatsappCtrl;
  final TextEditingController bioCtrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cuentanos sobre ti',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Esta info aparecera en tu perfil publico. Puedes editarla despues.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: whatsappCtrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]')),
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: const InputDecoration(
              labelText: 'WhatsApp (opcional)',
              hintText: '999 999 999',
              prefixIcon: Icon(Icons.phone),
              helperText: 'Solo visible cuando aprueben tu postulacion.',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: bioCtrl,
            maxLength: 200,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Descripcion personal (opcional)',
              hintText: 'Ej: Estudiante de DDS apasionado por el backend...',
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Step 4: links
// ============================================================
class _Step4Links extends StatelessWidget {
  const _Step4Links({
    required this.githubCtrl,
    required this.linkedinCtrl,
    required this.portfolioCtrl,
  });
  final TextEditingController githubCtrl;
  final TextEditingController linkedinCtrl;
  final TextEditingController portfolioCtrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tus links',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Agrega tu portafolio o redes. Completamente opcional.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: githubCtrl,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'GitHub (opcional)',
              hintText: 'https://github.com/tuusuario',
              prefixIcon: Icon(Icons.code),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: linkedinCtrl,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'LinkedIn (opcional)',
              hintText: 'https://linkedin.com/in/tuusuario',
              prefixIcon: Icon(Icons.business_center_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: portfolioCtrl,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Portafolio (opcional)',
              hintText: 'https://tuportafolio.com',
              prefixIcon: Icon(Icons.public),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ya casi terminas! Tu perfil estara listo para conectar '
                    'con otros estudiantes de Tecsup.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
