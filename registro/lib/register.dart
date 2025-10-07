import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
	@override
	_RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
	final _formKey = GlobalKey<FormState>();
	final _nameController = TextEditingController();
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();

	bool _isLoading = false;
	bool _obscurePassword = true;
	bool _isDark = false;
	String _selectedFileName = 'Photo.png';

	// Palette (from the Figma look)
	final Color _mintBg = const Color(0xFFDAF0EE);
	final Color _inputPink = const Color(0xFFEFE1EE);
	final Color _accentPurple = const Color(0xFF6E1FD6);
	final Color _darkBg = const Color(0xFF160F29);

	@override
	void dispose() {
		_nameController.dispose();
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	String? _validateName(String? value) {
		if (value == null || value.trim().isEmpty) return 'Por favor ingresa tu nombre';
		return null;
	}

	String? _validateEmail(String? value) {
		if (value == null || value.trim().isEmpty) return 'Por favor ingresa tu correo';
		final email = value.trim();
		final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
		if (!emailRegex.hasMatch(email)) return 'Ingresa un correo válido';
		return null;
	}

	String? _validatePassword(String? value) {
		if (value == null || value.isEmpty) return 'Por favor ingresa una contraseña';
		if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
		return null;
	}

	Future<void> _submit() async {
		final form = _formKey.currentState;
		if (form == null) return;
		if (!form.validate()) return;

		setState(() {
			_isLoading = true;
		});

		// Simulate an API call or registration processing
		await Future.delayed(Duration(seconds: 1));

		setState(() {
			_isLoading = false;
		});

		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(content: Text('Registro correcto')),
		);

		Navigator.of(context).pop();
	}

	InputDecoration _inputDecoration(String hint) => InputDecoration(
				hintText: hint,
				filled: true,
				fillColor: _inputPink,
				contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
				border: OutlineInputBorder(
					borderRadius: BorderRadius.circular(30),
					borderSide: BorderSide.none,
				),
			);

	Widget _shadowedField(Widget field) {
		return Container(
			decoration: BoxDecoration(
				boxShadow: [
					BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 6)),
				],
				borderRadius: BorderRadius.circular(30),
			),
			child: field,
		);
	}

	ThemeData get _lightTheme => ThemeData(
				scaffoldBackgroundColor: _mintBg,
				colorScheme: ColorScheme.light(primary: _accentPurple),
				appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: Colors.black87)),
			textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
			);

	ThemeData get _darkTheme => ThemeData(
				scaffoldBackgroundColor: _darkBg,
				colorScheme: ColorScheme.dark(primary: _accentPurple),
				appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: const Color.fromARGB(255, 162, 162, 162))),
			textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
			);

	@override
	Widget build(BuildContext context) {
		final theme = _isDark ? _darkTheme : _lightTheme;

		return Theme(
			data: theme,
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							// Dark mode toggle top-left (as requested)
							IconButton(
								icon: Icon(_isDark ? Icons.dark_mode : Icons.light_mode, color: _isDark ? Colors.white : _accentPurple),
								onPressed: () => setState(() => _isDark = !_isDark),
							),
							// Empty space - keeps title centered below
							SizedBox(width: 8),
							// optional placeholder to balance row
							CircleAvatar(backgroundColor: Colors.transparent, radius: 0),
						],
					),
				),
				body: SafeArea(
					child: SingleChildScrollView(
						padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
						child: Form(
							key: _formKey,
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									SizedBox(height: 18),
														Center(
															child: Text('Registrarse', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textTheme.bodyMedium!.color)),
														),
									SizedBox(height: 28),

									// Nombre
									Row(children: [
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
										SizedBox(width: 10),
										Text('*', style: TextStyle(color: _accentPurple, fontWeight: FontWeight.bold)),
									]),

									SizedBox(height: 14),

									// Email
									Row(children: [
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
										SizedBox(width: 10),
										Text('*', style: TextStyle(color: _accentPurple, fontWeight: FontWeight.bold)),
									]),

									SizedBox(height: 14),

									// Password
									Row(children: [
										Expanded(
											child: _shadowedField(
												TextFormField(
													controller: _passwordController,
													obscureText: _obscurePassword,
													textInputAction: TextInputAction.next,
													decoration: _inputDecoration('Contraseña').copyWith(suffixIcon: IconButton(
														icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: _accentPurple),
														onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
													)),
													validator: _validatePassword,
												),
											),
										),
										SizedBox(width: 10),
										Text('*', style: TextStyle(color: _accentPurple, fontWeight: FontWeight.bold)),
									]),

									SizedBox(height: 18),

									// File selector row
									Row(children: [
										Expanded(
											flex: 2,
											child: ElevatedButton.icon(
												onPressed: () {
													// Placeholder: implement file picker integration
													setState(() => _selectedFileName = 'photo_selected.png');
												},
												icon: Icon(Icons.upload_file, color: Colors.white),
												label: Text('Select File', style: TextStyle(color: Colors.white)),
												style: ElevatedButton.styleFrom(
													backgroundColor: _accentPurple,
													shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
													padding: EdgeInsets.symmetric(vertical: 14),
												),
											),
										),
										SizedBox(width: 12),
										Expanded(
											flex: 1,
											child: _shadowedField(
												Container(
													padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
													decoration: BoxDecoration(
														color: _inputPink,
														borderRadius: BorderRadius.circular(30),
													),
													child: Row(
														children: [
															Icon(Icons.image, color: _accentPurple.withOpacity(0.9)),
															SizedBox(width: 8),
															Expanded(child: Text(_selectedFileName, style: TextStyle(color: _accentPurple))),
														],
													),
												),
											),
										),
									]),

									SizedBox(height: 18),

									// Description
									_shadowedField(
										TextFormField(
											decoration: _inputDecoration('Descripción...'),
											minLines: 3,
											maxLines: 5,
										),
									),

									SizedBox(height: 22),

									// Register button
									ElevatedButton(
										onPressed: _isLoading ? null : _submit,
										style: ElevatedButton.styleFrom(
											backgroundColor: _accentPurple,
											shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
											padding: EdgeInsets.symmetric(vertical: 14),
										),
										child: _isLoading
												? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
												: Text('Registrarse', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
									),

									SizedBox(height: 12),

									Center(
										child: Row(
											mainAxisSize: MainAxisSize.min,
											children: [
												Text('¿Ya tienes una cuenta? ', style: TextStyle(color: theme.textTheme.bodyMedium!.color)),
												GestureDetector(
													onTap: () => Navigator.of(context).pop(),
													child: Text('Click aquí', style: TextStyle(color: _accentPurple, fontWeight: FontWeight.bold)),
												),
											],
										),
									),

									SizedBox(height: 18),
								],
							),
						),
					),
				),
			),
		);
	}
}


