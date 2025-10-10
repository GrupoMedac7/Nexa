import 'package:flutter/material.dart';
import 'package:nexa/core/theme_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedFileName = 'Photo.png';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: AppTheme.palette["light_purple"],
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: AppTheme.palette["grey"]),
  );

  Widget _shadowedField(Widget field) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: field,
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Por favor ingresa tu nombre';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Por favor ingresa tu correo';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Ingresa un correo válido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Por favor ingresa una contraseña';
    if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
    return null;
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro correcto')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;
    final primary = AppTheme.palette["dark_purple"]!;
    final inputBg = AppTheme.palette["light_purple"]!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Nombre
                Row(
                  children: [
                    Expanded(
                      child: _shadowedField(
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration('Nombre'),
                          validator: _validateName,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('*', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 14),

                // Email
                Row(
                  children: [
                    Expanded(
                      child: _shadowedField(
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration('email@example.com'),
                          validator: _validateEmail,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('*', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 14),

                // Password
                Row(
                  children: [
                    Expanded(
                      child: _shadowedField(
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: _inputDecoration('Contraseña').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: primary,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('*', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 18),

                // File selector row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() => _selectedFileName = 'photo_selected.png');
                        },
                        icon: const Icon(Icons.upload_file, color: Colors.white),
                        label: const Text('Seleccionar archivo', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: _shadowedField(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.image, color: primary.withOpacity(0.9)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_selectedFileName, style: TextStyle(color: primary))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Description
                _shadowedField(
                  TextFormField(
                    decoration: _inputDecoration('Descripción...'),
                    minLines: 3,
                    maxLines: 5,
                  ),
                ),

                const SizedBox(height: 22),

                // Register button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Registrarse', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 12),

                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('¿Ya tienes una cuenta? ', style: TextStyle(color: textColor)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text('Click aquí', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
