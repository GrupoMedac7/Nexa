import 'package:flutter/material.dart';

class AdvancedSearchFilter extends StatefulWidget {
  final String? hintText;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;
  final List<FilterOption>? filterOptions;
  final Map<String, dynamic>? initialFilters;
  final bool showSortOptions;
  final List<SortOption>? sortOptions;
  final ValueChanged<SortOption?>? onSortChanged;
  final SortOption? selectedSort;

  const AdvancedSearchFilter({
    super.key,
    this.hintText = 'Buscar...',
    this.onFiltersChanged,
    this.filterOptions,
    this.initialFilters,
    this.showSortOptions = false,
    this.sortOptions,
    this.onSortChanged,
    this.selectedSort,
  });

  @override
  State<AdvancedSearchFilter> createState() => _AdvancedSearchFilterState();
}

class _AdvancedSearchFilterState extends State<AdvancedSearchFilter> {
  late TextEditingController _searchController;
  late Map<String, dynamic> _filters;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filters = Map.from(widget.initialFilters ?? {});
    if (_filters.isNotEmpty) {
      _filters['searchQuery'] = '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilters() {
    _filters['searchQuery'] = _searchController.text;
    if (widget.onFiltersChanged != null) {
      widget.onFiltersChanged!(_filters);
    }
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _filters['searchQuery'] = '';
      _searchController.clear();
    });
    _updateFilters();
  }

  void _showSortDialog() {
    if (widget.sortOptions == null || widget.sortOptions!.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ordenar por'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.sortOptions!
                  .map((option) => RadioListTile<SortOption>(
                        title: Text(option.label),
                        subtitle: option.description != null
                            ? Text(option.description!)
                            : null,
                        value: option,
                        groupValue: widget.selectedSort,
                        onChanged: (value) {
                          if (widget.onSortChanged != null) {
                            widget.onSortChanged!(value);
                          }
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            if (widget.selectedSort != null)
              TextButton(
                onPressed: () {
                  if (widget.onSortChanged != null) {
                    widget.onSortChanged!(null);
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

  Widget _buildFilterOption(FilterOption option) {
    switch (option.type) {
      case FilterType.dropdown:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: option.label,
            border: const OutlineInputBorder(),
          ),
          value: _filters[option.key],
          items: option.options
              ?.map((opt) => DropdownMenuItem(
                    value: opt,
                    child: Text(opt),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              if (value == null || value.isEmpty) {
                _filters.remove(option.key);
              } else {
                _filters[option.key] = value;
              }
            });
            _updateFilters();
          },
        );
      case FilterType.range:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(option.label),
            RangeSlider(
              values: RangeValues(
                (_filters['${option.key}_min'] ?? option.min ?? 0.0).toDouble(),
                (_filters['${option.key}_max'] ?? option.max ?? 100.0).toDouble(),
              ),
              min: option.min ?? 0.0,
              max: option.max ?? 100.0,
              divisions: option.divisions,
              labels: RangeLabels(
                (_filters['${option.key}_min'] ?? option.min ?? 0.0).toString(),
                (_filters['${option.key}_max'] ?? option.max ?? 100.0).toString(),
              ),
              onChanged: (values) {
                setState(() {
                  _filters['${option.key}_min'] = values.start;
                  _filters['${option.key}_max'] = values.end;
                });
                _updateFilters();
              },
            ),
          ],
        );
      case FilterType.checkbox:
        return CheckboxListTile(
          title: Text(option.label),
          value: _filters[option.key] ?? false,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _filters[option.key] = true;
              } else {
                _filters.remove(option.key);
              }
            });
            _updateFilters();
          },
        );
      case FilterType.multiSelect:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(option.label),
            Wrap(
              children: option.options?.map((opt) {
                    final selectedList = _filters[option.key] as List? ?? [];
                    final isSelected = selectedList.contains(opt);
                    return FilterChip(
                      label: Text(opt),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          final currentList =
                              List<String>.from(_filters[option.key] ?? []);
                          if (selected) {
                            currentList.add(opt);
                          } else {
                            currentList.remove(opt);
                          }
                          if (currentList.isEmpty) {
                            _filters.remove(option.key);
                          } else {
                            _filters[option.key] = currentList;
                          }
                        });
                        _updateFilters();
                      },
                    );
                  }).toList() ??
                  [],
            ),
          ],
        );
    }
  }

  int get _activeFiltersCount {
    return _filters.entries
        .where((entry) => entry.key != 'searchQuery' && entry.value != null)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar with action buttons
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _updateFilters(),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _updateFilters();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              // Filter button
              if (widget.filterOptions != null && widget.filterOptions!.isNotEmpty)
                Stack(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                      },
                      icon: const Icon(Icons.tune),
                    ),
                    if (_activeFiltersCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            _activeFiltersCount.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onError,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              // Sort button
              if (widget.showSortOptions)
                IconButton.filledTonal(
                  onPressed: _showSortDialog,
                  icon: Icon(
                    widget.selectedSort?.isAscending == false
                        ? Icons.sort_by_alpha
                        : Icons.sort,
                  ),
                ),
            ],
          ),
          
          // Active filters chips
          if (_activeFiltersCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      children: [
                        ..._filters.entries
                            .where((entry) =>
                                entry.key != 'searchQuery' && entry.value != null)
                            .map((entry) => Chip(
                                  label: Text('${entry.key}: ${entry.value}'),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  onDeleted: () {
                                    setState(() {
                                      _filters.remove(entry.key);
                                    });
                                    _updateFilters();
                                  },
                                )),
                        if (_activeFiltersCount > 1)
                          ActionChip(
                            label: const Text('Limpiar todo'),
                            onPressed: _clearAllFilters,
                            avatar: const Icon(Icons.clear_all, size: 16),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Expandable filters section
          if (_showFilters &&
              widget.filterOptions != null &&
              widget.filterOptions!.isNotEmpty)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtros',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showFilters = false;
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_up),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...widget.filterOptions!
                      .map((option) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildFilterOption(option),
                          ))
                      .toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Supporting classes
enum FilterType {
  dropdown,
  range,
  checkbox,
  multiSelect,
}

class FilterOption {
  final String key;
  final String label;
  final FilterType type;
  final List<String>? options;
  final double? min;
  final double? max;
  final int? divisions;

  const FilterOption({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.divisions,
  });
}

class SortOption {
  final String key;
  final String label;
  final String? description;
  final bool isAscending;

  const SortOption({
    required this.key,
    required this.label,
    this.description,
    this.isAscending = true,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SortOption &&
        other.key == key &&
        other.isAscending == isAscending;
  }

  @override
  int get hashCode => key.hashCode ^ isAscending.hashCode;
}