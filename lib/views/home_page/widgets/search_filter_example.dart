import 'package:flutter/material.dart';
import 'search_filter.dart';
import 'advanced_search_filter.dart';

class SearchFilterExample extends StatefulWidget {
  const SearchFilterExample({super.key});

  @override
  State<SearchFilterExample> createState() => _SearchFilterExampleState();
}

class _SearchFilterExampleState extends State<SearchFilterExample> {
  String _searchQuery = '';
  String _selectedFilter = '';
  Map<String, dynamic> _advancedFilters = {};
  SortOption? _selectedSort;

  // Example data
  final List<String> _filterOptions = [
    'Todos',
    'Activos',
    'Inactivos',
    'Recientes',
    'Antiguos',
  ];

  final List<FilterOption> _advancedFilterOptions = [
    FilterOption(
      key: 'categoria',
      label: 'Categoría',
      type: FilterType.dropdown,
      options: ['Tecnología', 'Negocios', 'Salud', 'Educación'],
    ),
    FilterOption(
      key: 'precio',
      label: 'Rango de Precio',
      type: FilterType.range,
      min: 0.0,
      max: 1000.0,
      divisions: 20,
    ),
    FilterOption(
      key: 'disponible',
      label: 'Disponible',
      type: FilterType.checkbox,
    ),
    FilterOption(
      key: 'etiquetas',
      label: 'Etiquetas',
      type: FilterType.multiSelect,
      options: ['Nuevo', 'Popular', 'Descuento', 'Premium'],
    ),
  ];

  final List<SortOption> _sortOptions = [
    SortOption(
      key: 'nombre',
      label: 'Nombre (A-Z)',
      description: 'Ordenar por nombre alfabéticamente',
      isAscending: true,
    ),
    SortOption(
      key: 'nombre',
      label: 'Nombre (Z-A)',
      description: 'Ordenar por nombre inversamente',
      isAscending: false,
    ),
    SortOption(
      key: 'fecha',
      label: 'Fecha (Más reciente)',
      description: 'Ordenar por fecha de creación',
      isAscending: false,
    ),
    SortOption(
      key: 'precio',
      label: 'Precio (Menor a Mayor)',
      description: 'Ordenar por precio ascendente',
      isAscending: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros de Búsqueda'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Basic Search Filter
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Filtro Básico',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SearchFilter(
                    hintText: 'Buscar productos...',
                    filterOptions: _filterOptions,
                    selectedFilter: _selectedFilter,
                    onSearchChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Advanced Search Filter
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Filtro Avanzado',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  AdvancedSearchFilter(
                    hintText: 'Buscar con filtros avanzados...',
                    filterOptions: _advancedFilterOptions,
                    showSortOptions: true,
                    sortOptions: _sortOptions,
                    selectedSort: _selectedSort,
                    onFiltersChanged: (filters) {
                      setState(() {
                        _advancedFilters = filters;
                      });
                    },
                    onSortChanged: (sort) {
                      setState(() {
                        _selectedSort = sort;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Results Display
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado Actual',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text('Búsqueda básica: "$_searchQuery"'),
                    Text('Filtro seleccionado: "$_selectedFilter"'),
                    const SizedBox(height: 8),
                    Text('Filtros avanzados: ${_advancedFilters.toString()}'),
                    if (_selectedSort != null)
                      Text(
                        'Ordenamiento: ${_selectedSort!.label}',
                      ),
                  ],
                ),
              ),
            ),

            // Sample list with search results
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Resultados de Búsqueda',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Elemento ${index + 1}'),
                        subtitle: Text('Descripción del elemento ${index + 1}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}