import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onFilterChanged;
  final List<String>? filterOptions;
  final String? selectedFilter;
  final bool showFilterButton;
  final EdgeInsetsGeometry? padding;

  const SearchFilter({
    super.key,
    this.hintText = 'Buscar...',
    this.onSearchChanged,
    this.onFilterChanged,
    this.filterOptions,
    this.selectedFilter,
    this.showFilterButton = true,
    this.padding,
  });

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    if (widget.filterOptions == null || widget.filterOptions!.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtros'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.filterOptions!
                  .map((option) => RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: widget.selectedFilter,
                        onChanged: (value) {
                          if (value != null && widget.onFilterChanged != null) {
                            widget.onFilterChanged!(value);
                          }
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            if (widget.selectedFilter != null)
              TextButton(
                onPressed: () {
                  if (widget.onFilterChanged != null) {
                    widget.onFilterChanged!('');
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Limpiar'),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: widget.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              if (widget.onSearchChanged != null) {
                                widget.onSearchChanged!('');
                              }
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              ),
              if (widget.showFilterButton) ...[
                const SizedBox(width: 12.0),
                Material(
                  color: widget.selectedFilter != null && widget.selectedFilter!.isNotEmpty
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: _showFilterDialog,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: widget.selectedFilter != null && widget.selectedFilter!.isNotEmpty
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: widget.selectedFilter != null && widget.selectedFilter!.isNotEmpty
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (widget.selectedFilter != null && widget.selectedFilter!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Filtro activo: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Chip(
                    label: Text(
                      widget.selectedFilter!,
                      style: const TextStyle(fontSize: 12),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      if (widget.onFilterChanged != null) {
                        widget.onFilterChanged!('');
                      }
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}