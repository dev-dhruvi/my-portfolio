import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../models/profile.dart';
import '../../repositories/admin_repository.dart';
import '../../services/auth_service.dart';
import '../../widgets/cards/glass_card.dart';
import '../education/education_edit_dialog.dart';
import '../experience/experience_edit_dialog.dart';
import '../projects/project_edit_dialog.dart';
import '../skills/skill_edit_dialog.dart';

/// Secure administrative dashboard managing all dynamic portfolio entities.
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _confirmDelete({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final adminRepo = context.watch<AdminRepository>();
    final isMobile = AppBreakpoints.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.violetPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: AppColors.violetLight,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Portfolio Admin Console',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
        actions: [
          // Public preview button
          TextButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
            label: isMobile
                ? const SizedBox.shrink()
                : const Text('View Live Portfolio'),
            style: TextButton.styleFrom(foregroundColor: AppColors.cyanPrimary),
          ),
          const SizedBox(width: 8),

          // Admin User Email Pill
          if (!isMobile && authService.currentEmail != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.darkCardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.person_pin_rounded,
                    size: 16,
                    color: AppColors.cyanLight,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    authService.currentEmail!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 8),

          // Sign Out Button
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                context.go('/admin/login');
              }
            },
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.cyanPrimary,
          labelColor: AppColors.cyanPrimary,
          unselectedLabelColor: AppColors.textMutedDark,
          tabs: const [
            Tab(
              icon: Icon(Icons.dashboard_rounded, size: 18),
              text: 'Overview',
            ),
            Tab(
              icon: Icon(Icons.work_outline_rounded, size: 18),
              text: 'Experiences',
            ),
            Tab(icon: Icon(Icons.layers_outlined, size: 18), text: 'Projects'),
            Tab(icon: Icon(Icons.bolt_rounded, size: 18), text: 'Skills'),
            Tab(icon: Icon(Icons.school_outlined, size: 18), text: 'Education'),
            Tab(
              icon: Icon(Icons.badge_outlined, size: 18),
              text: 'Profile & Resume',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, adminRepo),
          _buildExperiencesTab(context, adminRepo),
          _buildProjectsTab(context, adminRepo),
          _buildSkillsTab(context, adminRepo),
          _buildEducationTab(context, adminRepo),
          _buildProfileTab(context, adminRepo),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Overview Tab
  // -------------------------------------------------------------
  Widget _buildOverviewTab(BuildContext context, AdminRepository repo) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Status & Content Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'All updates made here write securely to Cloud Firestore and sync live to the public site without redeploying GitHub Pages.',
            style: TextStyle(color: AppColors.textMutedDark),
          ),
          const SizedBox(height: 24),

          // Metrics
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _MetricCard(
                title: 'Total Experiences',
                value: '${repo.totalExperiences}',
                icon: Icons.work_rounded,
                accentColor: AppColors.violetPrimary,
              ),
              _MetricCard(
                title: 'Total Projects',
                value: '${repo.totalProjects}',
                icon: Icons.layers_rounded,
                accentColor: AppColors.cyanPrimary,
              ),
              _MetricCard(
                title: 'Verified Skills',
                value: '${repo.totalSkills}',
                icon: Icons.bolt_rounded,
                accentColor: AppColors.bluePrimary,
              ),
              _MetricCard(
                title: 'Unpublished Drafts',
                value: '${repo.draftCount}',
                icon: Icons.edit_note_rounded,
                accentColor: repo.draftCount > 0
                    ? AppColors.warning
                    : AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Security & Deployment Info Card
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.security_rounded, color: AppColors.cyanPrimary),
                    SizedBox(width: 10),
                    Text(
                      'Backend Authorization & Security Enforced',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '• Read operations on published content are open to all visitors.\n'
                  '• All write, edit, delete, and draft operations strictly require an authenticated identity verified in the Firestore "admins" collection.\n'
                  '• Client-side flag spoofing is blocked by Firestore Security Rules.',
                  style: TextStyle(
                    height: 1.6,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Experiences Tab
  // -------------------------------------------------------------
  Widget _buildExperiencesTab(BuildContext context, AdminRepository repo) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.violetPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Experience'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) =>
                ExperienceEditDialog(onSave: (exp) => repo.saveExperience(exp)),
          );
        },
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: repo.experiences.length,
        onReorder: (oldIndex, newIndex) =>
            repo.reorderExperiences(oldIndex, newIndex),
        itemBuilder: (context, index) {
          final exp = repo.experiences[index];
          return Card(
            key: ValueKey(exp.id),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.violetPrimary.withOpacity(0.15),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: AppColors.violetLight),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    exp.role,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  if (!exp.isPublished)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'DRAFT',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Text(
                '${exp.company} • ${exp.startDate} – ${exp.endDate} (${exp.location})',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Experience',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ExperienceEditDialog(
                          initial: exp,
                          onSave: (updated) => repo.saveExperience(updated),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    tooltip: 'Delete Experience',
                    onPressed: () {
                      _confirmDelete(
                        context: context,
                        title: 'Delete Experience?',
                        message:
                            'Are you sure you want to remove "${exp.role}" at "${exp.company}"?',
                        onConfirm: () => repo.deleteExperience(exp.id),
                      );
                    },
                  ),
                  const Icon(
                    Icons.drag_handle_rounded,
                    color: AppColors.textMutedDark,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // Projects Tab
  // -------------------------------------------------------------
  Widget _buildProjectsTab(BuildContext context, AdminRepository repo) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.violetPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Project'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) =>
                ProjectEditDialog(onSave: (proj) => repo.saveProject(proj)),
          );
        },
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: repo.projects.length,
        onReorder: (oldIndex, newIndex) =>
            repo.reorderProjects(oldIndex, newIndex),
        itemBuilder: (context, index) {
          final proj = repo.projects[index];
          return Card(
            key: ValueKey(proj.id),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.cyanPrimary.withOpacity(0.15),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: AppColors.cyanPrimary),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    proj.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  if (proj.isFeatured)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: AppColors.violetPrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.violetLight,
                        ),
                      ),
                    ),
                  if (!proj.isPublished)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'DRAFT',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Text('${proj.category} • ${proj.shortDescription}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Project',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ProjectEditDialog(
                          initial: proj,
                          onSave: (updated) => repo.saveProject(updated),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    tooltip: 'Delete Project',
                    onPressed: () {
                      _confirmDelete(
                        context: context,
                        title: 'Delete Project?',
                        message:
                            'Are you sure you want to remove project "${proj.title}"?',
                        onConfirm: () => repo.deleteProject(proj.id),
                      );
                    },
                  ),
                  const Icon(
                    Icons.drag_handle_rounded,
                    color: AppColors.textMutedDark,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // Skills Tab
  // -------------------------------------------------------------
  Widget _buildSkillsTab(BuildContext context, AdminRepository repo) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.violetPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Skill'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => SkillEditDialog(onSave: (s) => repo.saveSkill(s)),
          );
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: repo.skills.length,
        itemBuilder: (context, index) {
          final skill = repo.skills[index];
          return Card(
            key: ValueKey(skill.id),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.bolt_rounded,
                color: AppColors.cyanPrimary,
              ),
              title: Row(
                children: [
                  Text(
                    skill.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  if (skill.isHighlighted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cyanPrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'VERIFIED',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.cyanPrimary,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Text(skill.category),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Skill',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => SkillEditDialog(
                          initial: skill,
                          onSave: (updated) => repo.saveSkill(updated),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    tooltip: 'Delete Skill',
                    onPressed: () {
                      _confirmDelete(
                        context: context,
                        title: 'Delete Skill?',
                        message: 'Remove skill "${skill.name}"?',
                        onConfirm: () => repo.deleteSkill(skill.id),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // Education Tab
  // -------------------------------------------------------------
  Widget _buildEducationTab(BuildContext context, AdminRepository repo) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.violetPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Qualification'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) =>
                EducationEditDialog(onSave: (edu) => repo.saveEducation(edu)),
          );
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: repo.education.length,
        itemBuilder: (context, index) {
          final edu = repo.education[index];
          return Card(
            key: ValueKey(edu.id),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.school_outlined,
                color: AppColors.violetLight,
              ),
              title: Text(
                edu.degree,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '${edu.institution} (${edu.startDate} – ${edu.endDate}) • ${edu.honors}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Education',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => EducationEditDialog(
                          initial: edu,
                          onSave: (updated) => repo.saveEducation(updated),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    tooltip: 'Delete Education',
                    onPressed: () {
                      _confirmDelete(
                        context: context,
                        title: 'Delete Education?',
                        message: 'Remove "${edu.degree}"?',
                        onConfirm: () => repo.deleteEducation(edu.id),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // Profile & Resume Tab
  // -------------------------------------------------------------
  Widget _buildProfileTab(BuildContext context, AdminRepository repo) {
    return _ProfileEditView(profile: repo.profile, onSave: repo.saveProfile);
  }
}

class _ProfileEditView extends StatefulWidget {
  final Profile profile;
  final Function(Profile) onSave;

  const _ProfileEditView({required this.profile, required this.onSave});

  @override
  State<_ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<_ProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _bioController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _githubController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _resumeUrlController;
  late bool _openToWork;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p.name);
    _headlineController = TextEditingController(text: p.headline);
    _bioController = TextEditingController(text: p.bio);
    _emailController = TextEditingController(text: p.email);
    _phoneController = TextEditingController(text: p.phone);
    _locationController = TextEditingController(text: p.location);
    _githubController = TextEditingController(text: p.githubUrl);
    _linkedinController = TextEditingController(text: p.linkedinUrl);
    _resumeUrlController = TextEditingController(text: p.resumeUrl);
    _openToWork = p.openToWork;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _resumeUrlController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      headline: _headlineController.text.trim(),
      bio: _bioController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      githubUrl: _githubController.text.trim(),
      linkedinUrl: _linkedinController.text.trim(),
      resumeUrl: _resumeUrlController.text.trim(),
      openToWork: _openToWork,
    );

    await widget.onSave(updated);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Profile and Resume settings saved successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile & Social Links Configuration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name *',
                          ),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _headlineController,
                          decoration: const InputDecoration(
                            labelText: 'Headline *',
                          ),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Professional Bio *',
                    ),
                    maxLines: 4,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address *',
                          ),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location (e.g. Surat, Gujarat, India)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _githubController,
                          decoration: const InputDecoration(
                            labelText: 'GitHub Profile URL',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _linkedinController,
                          decoration: const InputDecoration(
                            labelText: 'LinkedIn Profile URL',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _resumeUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Configurable Resume File / Download URL',
                      hintText: 'assets/docs/resume.pdf or https://...',
                    ),
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text('Open to New Opportunities'),
                    subtitle: const Text(
                      'Displays the green availability indicator on the Hero section',
                    ),
                    value: _openToWork,
                    onChanged: (val) => setState(() => _openToWork = val),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(
                        _isSaving ? 'Saving...' : 'Save Profile Changes',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.violetPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 28),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }
}
