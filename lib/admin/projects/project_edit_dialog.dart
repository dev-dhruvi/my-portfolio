import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/project.dart';

/// Modal dialog for creating and modifying portfolio projects.
class ProjectEditDialog extends StatefulWidget {
  final Project? initial;
  final Function(Project) onSave;

  const ProjectEditDialog({super.key, this.initial, required this.onSave});

  @override
  State<ProjectEditDialog> createState() => _ProjectEditDialogState();
}

class _ProjectEditDialogState extends State<ProjectEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _slugController;
  late final TextEditingController _categoryController;
  late final TextEditingController _shortDescController;
  late final TextEditingController _fullDescController;
  late final TextEditingController _techController;
  late final TextEditingController _personalContribController;
  late final TextEditingController _challengesController;
  late final TextEditingController _outcomesController;
  late final TextEditingController _thumbnailController;
  late final TextEditingController _playStoreController;
  late final TextEditingController _appStoreController;
  late final TextEditingController _githubController;
  late final TextEditingController _demoController;
  late bool _isFeatured;
  late bool _isPublished;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _titleController = TextEditingController(text: p?.title ?? '');
    _slugController = TextEditingController(text: p?.slug ?? '');
    _categoryController = TextEditingController(
      text: p?.category ?? 'Mobile App',
    );
    _shortDescController = TextEditingController(
      text: p?.shortDescription ?? '',
    );
    _fullDescController = TextEditingController(text: p?.fullDescription ?? '');
    _techController = TextEditingController(
      text: p?.technologies.join(', ') ?? '',
    );
    _personalContribController = TextEditingController(
      text: p?.personalContribution ?? '',
    );
    _challengesController = TextEditingController(
      text: p?.challengesAndSolutions ?? '',
    );
    _outcomesController = TextEditingController(
      text: p?.verifiedOutcomes ?? '',
    );
    _thumbnailController = TextEditingController(text: p?.thumbnailUrl ?? '');
    _playStoreController = TextEditingController(text: p?.playStoreUrl ?? '');
    _appStoreController = TextEditingController(text: p?.appStoreUrl ?? '');
    _githubController = TextEditingController(text: p?.githubUrl ?? '');
    _demoController = TextEditingController(text: p?.demoUrl ?? '');
    _isFeatured = p?.isFeatured ?? false;
    _isPublished = p?.isPublished ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _slugController.dispose();
    _categoryController.dispose();
    _shortDescController.dispose();
    _fullDescController.dispose();
    _techController.dispose();
    _personalContribController.dispose();
    _challengesController.dispose();
    _outcomesController.dispose();
    _thumbnailController.dispose();
    _playStoreController.dispose();
    _appStoreController.dispose();
    _githubController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final techList = _techController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    var slug = _slugController.text.trim();
    if (slug.isEmpty) {
      slug = _titleController.text.trim().toLowerCase().replaceAll(
        RegExp(r'[^a-z0-9]+'),
        '-',
      );
    }

    final updated = Project(
      id: widget.initial?.id ?? '',
      slug: slug,
      title: _titleController.text.trim(),
      shortDescription: _shortDescController.text.trim(),
      fullDescription: _fullDescController.text.trim(),
      category: _categoryController.text.trim(),
      technologies: techList,
      personalContribution: _personalContribController.text.trim(),
      challengesAndSolutions: _challengesController.text.trim(),
      verifiedOutcomes: _outcomesController.text.trim(),
      thumbnailUrl: _thumbnailController.text.trim(),
      playStoreUrl: _playStoreController.text.trim(),
      appStoreUrl: _appStoreController.text.trim(),
      githubUrl: _githubController.text.trim(),
      demoUrl: _demoController.text.trim(),
      isFeatured: _isFeatured,
      isPublished: _isPublished,
      orderIndex: widget.initial?.orderIndex ?? 0,
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
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 760),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initial == null
                        ? 'Create New Project'
                        : 'Edit Project',
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
                            flex: 6,
                            child: TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Project Title *',
                              ),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: _categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Category *',
                                hintText: 'Mobile App, FinTech, etc.',
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
                        controller: _shortDescController,
                        decoration: const InputDecoration(
                          labelText: 'Short Summary / Hook *',
                        ),
                        maxLines: 2,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _fullDescController,
                        decoration: const InputDecoration(
                          labelText: 'Full Description *',
                        ),
                        maxLines: 4,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _techController,
                        decoration: const InputDecoration(
                          labelText: 'Technologies (comma separated) *',
                          hintText: 'Flutter, GetX, REST API, Firebase',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _personalContribController,
                        decoration: const InputDecoration(
                          labelText: 'Personal Contribution',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _challengesController,
                        decoration: const InputDecoration(
                          labelText: 'Challenges & Technical Solutions',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _outcomesController,
                        decoration: const InputDecoration(
                          labelText: 'Verified Outcomes',
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _playStoreController,
                              decoration: const InputDecoration(
                                labelText: 'Google Play URL',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _appStoreController,
                              decoration: const InputDecoration(
                                labelText: 'App Store URL',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _githubController,
                              decoration: const InputDecoration(
                                labelText: 'GitHub / Repo URL',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _demoController,
                              decoration: const InputDecoration(
                                labelText: 'Live Demo URL',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _thumbnailController,
                        decoration: const InputDecoration(
                          labelText: 'Thumbnail Image URL',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Switches
                      SwitchListTile(
                        title: const Text('Featured Project'),
                        subtitle: const Text(
                          'Prominently display in hero and portfolio badges',
                        ),
                        value: _isFeatured,
                        onChanged: (val) => setState(() => _isFeatured = val),
                      ),
                      SwitchListTile(
                        title: const Text('Published to Public Portfolio'),
                        subtitle: const Text(
                          'When disabled, remains stored as an admin draft',
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
                    child: const Text('Save Project'),
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
