import 'package:flutter/material.dart';
import 'widgets/search_filter.dart';
import 'widgets/search_filter_example.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String _selectedFilter = '';

  final List<String> _filterOptions = [
    'Todos',
    'Favoritos',
    'Recientes',
    'Más populares',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchFilterExample(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search filter at the top
          SearchFilter(
            hintText: 'Buscar contenido...',
            filterOptions: _filterOptions,
            selectedFilter: _selectedFilter,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              // Here you would typically filter your data based on the search query
              print('Search query: $query');
            },
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
              // Here you would typically filter your data based on the selected filter
              print('Selected filter: $filter');
            },
          ),
          
          // Main content area
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // This is where you would build your actual content
    // For now, we'll show a simple list
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (context, index) {
        final item = 'Elemento ${index + 1}';
        
        // Simple search filtering
        if (_searchQuery.isNotEmpty && 
            !item.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return const SizedBox.shrink();
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text('${index + 1}'),
            ),
            title: Text(item),
            subtitle: Text('Descripción del $item'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionaste: $item')),
              );
            },
          ),
        );
      },
    );
  }
}