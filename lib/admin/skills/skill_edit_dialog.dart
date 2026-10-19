import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/skill.dart';

/// Modal dialog for creating or editing skills.
class SkillEditDialog extends StatefulWidget {
  final Skill? initial;
  final Function(Skill) onSave;

  const SkillEditDialog({super.key, this.initial, required this.onSave});

  @override
  State<SkillEditDialog> createState() => _SkillEditDialogState();
}

class _SkillEditDialogState extends State<SkillEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descController;
  late bool _isHighlighted;
  late bool _isPublished;

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    _nameController = TextEditingController(text: s?.name ?? '');
    _categoryController = TextEditingController(
      text: s?.category ?? 'Mobile & Frameworks',
    );
    _descController = TextEditingController(text: s?.description ?? '');
    _isHighlighted = s?.isHighlighted ?? false;
    _isPublished = s?.isPublished ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = Skill(
      id: widget.initial?.id ?? '',
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      description: _descController.text.trim(),
      isHighlighted: _isHighlighted,
      isPublished: _isPublished,
      orderIndex: widget.initial?.orderIndex ?? 0,
    );

    widget.onSave(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initial == null ? 'Add Skill' : 'Edit Skill',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Skill Name *'),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category *'),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description / Context',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Highlighted / Production Verified'),
                  value: _isHighlighted,
                  onChanged: (val) => setState(() => _isHighlighted = val),
                ),
                SwitchListTile(
                  title: const Text('Published'),
                  value: _isPublished,
                  onChanged: (val) => setState(() => _isPublished = val),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save Skill'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
