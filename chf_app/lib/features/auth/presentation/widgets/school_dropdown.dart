import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Searchable dropdown for selecting a school.
///
/// Opens a bottom sheet with a search field and filtered list.
/// Much better UX than a standard [DropdownButton] for long lists.
class SchoolDropdown extends StatelessWidget {
  final String label;
  final String hintText;
  final String searchHint;
  final String? selectedSchool;
  final List<String> schools;
  final ValueChanged<String> onSelected;
  final String? Function(String?)? validator;

  const SchoolDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.searchHint,
    required this.schools,
    required this.onSelected,
    this.selectedSchool,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        FormField<String>(
          initialValue: selectedSchool,
          validator: validator != null ? (_) => validator!(selectedSchool) : null,
          builder: (fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showSearchSheet(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingMd,
                    ),
                    decoration: BoxDecoration(
                      color: theme.inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: fieldState.hasError
                            ? theme.colorScheme.error
                            : theme.dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.school_rounded,
                          color: colorScheme.onSurfaceVariant,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedSchool ?? hintText,
                            style: selectedSchool != null
                                ? theme.textTheme.bodyLarge
                                : theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                  ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                if (fieldState.hasError) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      fieldState.errorText!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: AppTheme.spacingMd),
      ],
    );
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SchoolSearchSheet(
        searchHint: searchHint,
        schools: schools,
        selectedSchool: selectedSchool,
        onSelected: onSelected,
      ),
    );
  }
}

class _SchoolSearchSheet extends StatefulWidget {
  final String searchHint;
  final List<String> schools;
  final String? selectedSchool;
  final ValueChanged<String> onSelected;

  const _SchoolSearchSheet({
    required this.searchHint,
    required this.schools,
    required this.onSelected,
    this.selectedSchool,
  });

  @override
  State<_SchoolSearchSheet> createState() => _SchoolSearchSheetState();
}

class _SchoolSearchSheetState extends State<_SchoolSearchSheet> {
  late final TextEditingController _searchController;
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filtered = widget.schools;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = widget.schools;
      } else {
        _filtered = widget.schools
            .where((s) => s.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      child: Column(
        children: [
          // ─── Handle ───
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ─── Search field ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _filter('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ─── List ───
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      '—',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filtered.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                    ),
                    itemBuilder: (context, index) {
                      final school = _filtered[index];
                      final isSelected = school == widget.selectedSchool;
                      return ListTile(
                        title: Text(
                          school,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: colorScheme.primary,
                              )
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        onTap: () {
                          widget.onSelected(school);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
