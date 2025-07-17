import 'package:flutter/material.dart';

class TodoSearchBar extends StatefulWidget {
  const TodoSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  final String searchQuery;
  final void Function(String query) onSearchChanged;
  final VoidCallback onClearSearch;

  @override
  State<TodoSearchBar> createState() => _TodoSearchBarState();
}

class _TodoSearchBarState extends State<TodoSearchBar> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(TodoSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focusNode.hasFocus 
              ? theme.colorScheme.primary.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Todoを検索...',
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: widget.searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onClearSearch();
                    _focusNode.unfocus();
                  },
                  tooltip: '検索をクリア',
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
        style: theme.textTheme.bodyLarge,
        textInputAction: TextInputAction.search,
        onChanged: widget.onSearchChanged,
        onSubmitted: (_) => _focusNode.unfocus(),
      ),
    );
  }
}