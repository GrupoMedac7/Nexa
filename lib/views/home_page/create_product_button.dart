import 'package:flutter/material.dart';

class CreateProductButton extends StatelessWidget {
  const CreateProductButton({super.key});

  void _navigateToCreateProduct(BuildContext context) {
    // TODO: Navegar a la página de creación de productos
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const CreateProductPage(),
    //   ),
    // );
    
    // Por ahora, mostrar un mensaje temporal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navegando a crear producto... (página pendiente)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () => _navigateToCreateProduct(context),
        icon: const Icon(
          Icons.add_circle_outline,
          size: 24,
        ),
        label: const Text(
          'Añadir Producto',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: Colors.blue.withOpacity(0.3),
        ),
      ),
    );
  }
}

// Versión alternativa: Botón flotante circular
class CreateProductFloatingButton extends StatelessWidget {
  const CreateProductFloatingButton({super.key});

  void _navigateToCreateProduct(BuildContext context) {
    // TODO: Navegar a la página de creación de productos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navegando a crear producto... (página pendiente)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToCreateProduct(context),
      icon: const Icon(Icons.add),
      label: const Text('Nuevo Producto'),
      backgroundColor: Colors.blue[600],
      foregroundColor: Colors.white,
      elevation: 6,
    );
  }
}
