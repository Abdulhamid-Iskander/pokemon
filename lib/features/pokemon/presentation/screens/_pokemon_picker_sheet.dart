import 'dart:ui';
import 'package:flutter/material.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/debouncer.dart';

class PokemonPickerSheet extends StatefulWidget {
  const PokemonPickerSheet({super.key});

  @override
  State<PokemonPickerSheet> createState() => _PokemonPickerSheetState();
}

class _PokemonPickerSheetState extends State<PokemonPickerSheet> {
  final _local = LocalDataSource();
  final _debouncer = Debouncer();
  final _controller = TextEditingController();
  List<PokemonListItemModel> _results = [];

  @override
  void initState() {
    super.initState();
    _results = _local.getAllPokemon().take(50).toList();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    _debouncer.run(() {
      setState(() {
        _results = _local.search(q).take(50).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xE6121218),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              const Text(
                'SELECT FIGHTER',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.glassBg,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.glassBorder),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      const Icon(Icons.search, color: AppTheme.textMuted, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: _onSearch,
                          autofocus: true,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Search by name...',
                            hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _results.length,
                  itemBuilder: (_, i) {
                    final p = _results[i];
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: Text(
                        '#${p.id.toString().padLeft(4, '0')}',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      ),
                      title: Text(p.capitalizedName, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
                      onTap: () => Navigator.pop(context, p.name),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
