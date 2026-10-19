import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/profile.dart';
import '../../widgets/cards/glass_card.dart';

/// Contact section providing direct email triggers, copy actions,
/// location verification, and functional inquiry composition.
class ContactSection extends StatefulWidget {
  final Profile profile;

  const ContactSection({super.key, required this.profile});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    final subject = _subjectController.text.trim().isNotEmpty
        ? _subjectController.text.trim()
        : 'Portfolio Inquiry from ${_nameController.text.trim()}';

    final body =
        '''
From: ${_nameController.text.trim()} (${_emailController.text.trim()})

${_messageController.text.trim()}
''';

    final launched = await UrlLauncherUtil.openEmail(
      widget.profile.email,
      subject: subject,
      body: body,
    );

    if (mounted) {
      setState(() => _isSending = false);
      if (launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Opening default email client with your message...'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              'Could not launch mail client. Direct email: ${widget.profile.email}',
            ),
          ),
        );
      }
    }
  }

  void _copyEmailToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.profile.email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.darkCard,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.cyanPrimary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text('Copied "${widget.profile.email}" to clipboard!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 32 : 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Tag & Header
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'GET IN TOUCH',
                style: TextStyle(
                  color: AppColors.cyanPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Let's Build Something Exceptional",
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 26 : 34),
          ),
          const SizedBox(height: 8),
          Text(
            'Whether you have a full-time role, consulting project, or mobile application challenge, reach out directly.',
            style: AppTypography.getBodyLarge(secondaryTextColor),
          ),
          const SizedBox(height: 36),

          isMobile
              ? Column(
                  children: [
                    _buildContactInfo(context, textColor, secondaryTextColor),
                    const SizedBox(height: 24),
                    _buildContactForm(context, textColor, secondaryTextColor),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildContactInfo(
                        context,
                        textColor,
                        secondaryTextColor,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 6,
                      child: _buildContactForm(
                        context,
                        textColor,
                        secondaryTextColor,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Column(
      children: [
        // Email Card with Copy Action
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.violetPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.violetLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cyanPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.profile.email,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Copy Email',
                icon: const Icon(Icons.copy_rounded, size: 18),
                onPressed: () => _copyEmailToClipboard(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Location Card
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cyanPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.cyanLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cyanPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.profile.location,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Social Profiles Card
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Professional Profiles',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => UrlLauncherUtil.openUrl(
                        widget.profile.githubUrl,
                        context: context,
                      ),
                      icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                      label: const Text('GitHub'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => UrlLauncherUtil.openUrl(
                        widget.profile.linkedinUrl,
                        context: context,
                      ),
                      icon: const FaIcon(FontAwesomeIcons.linkedinIn, size: 16),
                      label: const Text('LinkedIn'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Direct Message',
              style: AppTypography.getTitleLarge(textColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Launches your email client directly with prefilled parameters.',
              style: TextStyle(fontSize: 13, color: secondaryTextColor),
            ),
            const SizedBox(height: 20),

            // Name & Email
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Your Name *'),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Enter your name'
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Your Email *',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Enter your email';
                      }
                      if (!val.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Subject
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject (e.g. Flutter Opportunity)',
              ),
            ),
            const SizedBox(height: 16),

            // Message
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message *',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Please write a message'
                  : null,
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _sendEmail,
                icon: _isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  _isSending ? 'Preparing...' : 'Send Message via Email',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.violetPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
