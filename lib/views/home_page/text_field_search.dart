import 'package:flutter/material.dart';

class ProductSearchField extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final VoidCallback? onClearSearch;
  
  const ProductSearchField({
    super.key,
    this.onSearchChanged,
    this.onClearSearch,
  });

  @override
  State<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends State<ProductSearchField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    
    // Llamar al callback de búsqueda
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(_controller.text);
    }
  }

  void _clearSearch() {
    _controller.clear();
    if (widget.onClearSearch != null) {
      widget.onClearSearch!();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 22,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          // Acción cuando se presiona Enter/Buscar
          if (widget.onSearchChanged != null) {
            widget.onSearchChanged!(value);
          }
        },
      ),
    );
  }
}