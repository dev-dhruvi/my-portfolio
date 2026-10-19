import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/experience.dart';

/// Modal dialog for creating and editing work experience entries.
class ExperienceEditDialog extends StatefulWidget {
  final Experience? initial;
  final Function(Experience) onSave;

  const ExperienceEditDialog({super.key, this.initial, required this.onSave});

  @override
  State<ExperienceEditDialog> createState() => _ExperienceEditDialogState();
}

class _ExperienceEditDialogState extends State<ExperienceEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _companyController;
  late final TextEditingController _roleController;
  late final TextEditingController _locationController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _techController;
  late final TextEditingController _respController;
  late List<String> _responsibilities;
  late bool _isPublished;
  late bool _isCurrent;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    _companyController = TextEditingController(text: init?.company ?? '');
    _roleController = TextEditingController(text: init?.role ?? '');
    _locationController = TextEditingController(
      text: init?.location ?? 'Surat, India',
    );
    _startDateController = TextEditingController(text: init?.startDate ?? '');
    _endDateController = TextEditingController(text: init?.endDate ?? '');
    _techController = TextEditingController(
      text: init?.technologies.join(', ') ?? '',
    );
    _respController = TextEditingController();
    _responsibilities = List.from(init?.responsibilities ?? []);
    _isPublished = init?.isPublished ?? true;
    _isCurrent = init?.isCurrent ?? false;
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _techController.dispose();
    _respController.dispose();
    super.dispose();
  }

  void _addResponsibility() {
    final text = _respController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _responsibilities.add(text);
        _respController.clear();
      });
    }
  }

  void _removeResponsibility(int index) {
    setState(() {
      _responsibilities.removeAt(index);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final techList = _techController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final updated = Experience(
      id: widget.initial?.id ?? '',
      company: _companyController.text.trim(),
      role: _roleController.text.trim(),
      location: _locationController.text.trim(),
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      isCurrent: _isCurrent,
      responsibilities: _responsibilities,
      technologies: techList,
      orderIndex: widget.initial?.orderIndex ?? 0,
      isPublished: _isPublished,
      createdAt: widget.initial?.createdAt ?? DateTime.now(),
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
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initial == null
                        ? 'Add Work Experience'
                        : 'Edit Work Experience',
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
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _companyController,
                              decoration: const InputDecoration(
                                labelText: 'Company / Employer *',
                              ),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _roleController,
                              decoration: const InputDecoration(
                                labelText: 'Job Title / Role *',
                              ),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startDateController,
                              decoration: const InputDecoration(
                                labelText: 'Start Date (e.g. June 2024) *',
                              ),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _endDateController,
                              decoration: const InputDecoration(
                                labelText:
                                    'End Date (e.g. April 2025 or Present) *',
                              ),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _techController,
                        decoration: const InputDecoration(
                          labelText: 'Technologies (comma separated)',
                          hintText: 'Flutter, Dart, GetX, REST API',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Responsibilities Section
                      const Text(
                        'Key Responsibilities / Achievements',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _respController,
                              decoration: const InputDecoration(
                                hintText:
                                    'Add an achievement or responsibility...',
                              ),
                              onSubmitted: (_) => _addResponsibility(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addResponsibility,
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._responsibilities.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final resp = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCardHover
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: AppColors.cyanPrimary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  resp,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: AppColors.error,
                                ),
                                onPressed: () => _removeResponsibility(idx),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      // Status Switches
                      SwitchListTile(
                        title: const Text('Published to Public Portfolio'),
                        subtitle: const Text(
                          'When disabled, remains saved as a draft',
                        ),
                        value: _isPublished,
                        onChanged: (val) => setState(() => _isPublished = val),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Experience'),
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
