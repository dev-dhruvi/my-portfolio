import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/education.dart';

/// Modal dialog for creating or editing education records.
class EducationEditDialog extends StatefulWidget {
  final Education? initial;
  final Function(Education) onSave;

  const EducationEditDialog({super.key, this.initial, required this.onSave});

  @override
  State<EducationEditDialog> createState() => _EducationEditDialogState();
}

class _EducationEditDialogState extends State<EducationEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _degreeController;
  late final TextEditingController _institutionController;
  late final TextEditingController _affiliationController;
  late final TextEditingController _locationController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _cgpaController;
  late final TextEditingController _honorsController;
  late final TextEditingController _descController;
  late bool _isPublished;

  @override
  void initState() {
    super.initState();
    final e = widget.initial;
    _degreeController = TextEditingController(text: e?.degree ?? '');
    _institutionController = TextEditingController(text: e?.institution ?? '');
    _affiliationController = TextEditingController(text: e?.affiliation ?? '');
    _locationController = TextEditingController(
      text: e?.location ?? 'Surat, India',
    );
    _startDateController = TextEditingController(text: e?.startDate ?? '');
    _endDateController = TextEditingController(text: e?.endDate ?? '');
    _cgpaController = TextEditingController(text: e?.cgpa ?? '');
    _honorsController = TextEditingController(text: e?.honors ?? '');
    _descController = TextEditingController(text: e?.description ?? '');
    _isPublished = e?.isPublished ?? true;
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _affiliationController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _cgpaController.dispose();
    _honorsController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = Education(
      id: widget.initial?.id ?? '',
      degree: _degreeController.text.trim(),
      institution: _institutionController.text.trim(),
      affiliation: _affiliationController.text.trim(),
      location: _locationController.text.trim(),
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      cgpa: _cgpaController.text.trim(),
      honors: _honorsController.text.trim(),
      description: _descController.text.trim(),
      orderIndex: widget.initial?.orderIndex ?? 0,
      isPublished: _isPublished,
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
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initial == null
                        ? 'Add Qualification'
                        : 'Edit Qualification',
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
                    children: [
                      TextFormField(
                        controller: _degreeController,
                        decoration: const InputDecoration(
                          labelText: 'Degree / Program *',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _institutionController,
                        decoration: const InputDecoration(
                          labelText: 'Institution / College *',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _affiliationController,
                        decoration: const InputDecoration(
                          labelText: 'Affiliated University',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startDateController,
                              decoration: const InputDecoration(
                                labelText: 'Start Date (e.g. Dec 2020) *',
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
                                labelText: 'End Date (e.g. May 2022) *',
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
                              controller: _cgpaController,
                              decoration: const InputDecoration(
                                labelText: 'CGPA (e.g. 7.61)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _honorsController,
                              decoration: const InputDecoration(
                                labelText: 'Honors / Distinction Notes',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          labelText: 'Description / Curriculum Overview',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Published to Public Portfolio'),
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
                    child: const Text('Save Education'),
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
