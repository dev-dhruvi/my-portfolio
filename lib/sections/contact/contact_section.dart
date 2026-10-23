import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/profile.dart';
import '../../widgets/animations/staggered_entrance.dart';
import '../../widgets/cards/glass_card.dart';

/// Contact section providing direct inquiry composition paired with
/// the 3D contact character illustration.
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

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = !isMobile && !isTablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 16 : (isMobile ? 20 : 24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 10),
          Text(
            "Let's Build Something Exceptional",
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 24 : 28),
          ),
          const SizedBox(height: 6),
          Text(
            'Whether you have a full-time role, consulting project, or mobile application challenge, reach out directly.',
            style: AppTypography.getBodyLarge(secondaryTextColor),
          ),
          const SizedBox(height: 30),

          // 3D Character Stage & Message Form
          if (isMobile)
            Column(
              children: [
                const StaggeredEntrance(
                  index: 0,
                  child: _ContactCharacterStage(isMobile: true),
                ),
                const SizedBox(height: 18),
                StaggeredEntrance(
                  index: 1,
                  child: _buildContactForm(
                    context,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 5,
                  child: StaggeredEntrance(
                    index: 0,
                    child: _ContactCharacterStage(isMobile: false),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 7,
                  child: StaggeredEntrance(
                    index: 1,
                    child: _buildContactForm(
                      context,
                      textColor,
                      secondaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildContactForm(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 480;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Direct Message',
                  style: AppTypography.getTitleMedium(textColor)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Launches your email client directly with prefilled parameters.',
                  style: TextStyle(fontSize: 12.5, color: secondaryTextColor),
                ),
                const SizedBox(height: 12),

                // Name & Email (stacked on narrow viewports, side-by-side on wider)
                if (isNarrow) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Your Name *'),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Enter your name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
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
                ] else
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Your Name *'),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Enter your name'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
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
                const SizedBox(height: 12),

                // Subject
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject (Optional)',
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message *',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please write a message'
                      : null,
                ),
                const SizedBox(height: 14),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
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
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _isSending ? 'Preparing...' : 'Send Message via Email',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.violetPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ContactCharacterStage extends StatelessWidget {
  final bool isMobile;

  const _ContactCharacterStage({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? 250 : 280,
            maxHeight: isMobile ? 250 : 290,
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Ambient glowing circular backdrop
              Container(
                width: isMobile ? 190 : 230,
                height: isMobile ? 190 : 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyanPrimary.withOpacity(isDark ? 0.35 : 0.22),
                      AppColors.violetPrimary.withOpacity(isDark ? 0.25 : 0.12),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.65, 1.0],
                  ),
                ),
              ),
              // Outer subtle glass ring
              Container(
                width: isMobile ? 205 : 245,
                height: isMobile ? 205 : 245,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.12)
                        : AppColors.cyanPrimary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
              ),
              // 3D Cartoon Contact character
              Image.asset(
                'assets/images/developer_character_contact.png',
                height: isMobile ? 230 : 270,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
              // Bottom Floating Response pill
              Positioned(
                bottom: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkCard : Colors.white)
                        .withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : AppColors.lightCardBorder,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.cyanPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Quick Response Guaranteed',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color:
                              isDark ? Colors.white : AppColors.darkBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
