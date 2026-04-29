import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/auth_error_messages.dart';
import '../../../../core/utils/validators.dart';
import '../../data/auth_repository.dart';
import '../providers/auth_providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _careerCtrl = TextEditingController();
  final _cycleCtrl = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _careerCtrl.dispose();
    _cycleCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signUp(
            SignUpData(
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text,
              fullName: _fullNameCtrl.text.trim(),
              career: _careerCtrl.text.trim(),
              cycle: int.parse(_cycleCtrl.text.trim()),
            ),
          );
      // signUp ya inicia sesion automaticamente; el router redirige al feed.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _fullNameCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => validateRequired(v, fieldName: 'Nombre'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Correo Tecsup',
                        hintText: 'usuario@tecsup.edu.pe',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: validateTecsupEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _careerCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Carrera',
                        hintText: 'Ej: Desarrollo de Software',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      validator: (v) => validateRequired(v, fieldName: 'Carrera'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cycleCtrl,
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
                        if (n == null || n < 1 || n > 10) return 'Debe ser entre 1 y 10';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: 'Contrasena',
                        helperText: 'Minimo 8 caracteres',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.4),
                            )
                          : const Text('Registrarme'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _loading ? null : () => context.pop(),
                      child: const Text('Ya tengo cuenta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
