import 'package:flutter/material.dart';
import 'package:nexa/core/theme_provider.dart';
import 'package:nexa/views/home_page/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO + ICONOS DERECHA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo "NeXa"
                  RichText(
                    text: TextSpan(
                      text: 'Ne',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.palette["black"],
                      ),
                      children: [
                        TextSpan(
                          text: 'Xa',
                          style: TextStyle(
                            color: AppTheme.palette["dark_purple"],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Icono de perfil + Switch de tema
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.account_circle_outlined),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                      Switch(
                        value: AppTheme.isDarkMode.value,
                        onChanged: (value) {
                          AppTheme.isDarkMode.value = value;
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // BARRA DE BÚSQUEDA
              SearchBarWidget(
                controller: _searchController,
                onChanged: (value) {
                  // Lógica de búsqueda si quieres en el futuro
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
