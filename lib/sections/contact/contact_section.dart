import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/profile.dart';
import '../../widgets/animations/staggered_entrance.dart';

/// Contact section providing dual-channel direct inquiry (Email + WhatsApp)
/// paired with the 3D contact character illustration and a prefilled message form.
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
  final _messageController = TextEditingController();

  static const List<String> _subjectOptions = [
    'Job Opportunity',
    'Freelance Project',
    'Collaboration',
    'Other',
  ];

  String? _selectedSubject = 'Job Opportunity';
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    final subject =
        '${_selectedSubject ?? 'Portfolio Inquiry'}: ${_nameController.text.trim()}';

    final body =
        '''
From: ${_nameController.text.trim()} (${_emailController.text.trim()})
Subject: ${_selectedSubject ?? 'General Inquiry'}

${_messageController.text.trim()}
''';

    final launched = await UrlLauncherUtil.openEmail(
      widget.profile.email.isNotEmpty
          ? widget.profile.email
          : AppConstants.email,
      subject: subject,
      body: body,
    );

    if (mounted) {
      setState(() => _isSending = false);
      if (launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Opening default email app with your message...'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              'Could not launch email app. Direct email: ${widget.profile.email}',
            ),
          ),
        );
      }
    }
  }

  void _openDirectEmail() {
    UrlLauncherUtil.openEmail(
      widget.profile.email.isNotEmpty
          ? widget.profile.email
          : AppConstants.email,
      subject: 'Portfolio Inquiry for ${widget.profile.name}',
    );
  }

  void _openWhatsApp() {
    UrlLauncherUtil.openWhatsApp(
      AppConstants.whatsappNumber,
      text: AppConstants.whatsappDefaultText,
      context: context,
    );
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
        vertical: isDesktop ? 20 : (isMobile ? 24 : 28),
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

          // Main Headline with Gradient
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Let's Build Something ",
                  style: TextStyle(
                    fontSize: isMobile ? 26 : 34,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF8B5CF6), // Violet
                        Color(0xFFD946EF), // Magenta
                        Color(0xFF06B6D4), // Cyan
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Exceptional',
                      style: TextStyle(
                        fontSize: isMobile ? 26 : 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Have a project in mind or want to discuss an opportunity? I\'d love to hear from you.',
            style: AppTypography.getBodyLarge(secondaryTextColor),
          ),
          const SizedBox(height: 32),

          // Responsive Two-Option Content Layout
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: StaggeredEntrance(
                    index: 0,
                    child: _buildLeftOverview(
                      context,
                      isDark: isDark,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      isMobile: false,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 6,
                  child: StaggeredEntrance(
                    index: 1,
                    child: _buildContactFormCard(
                      context,
                      isDark: isDark,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      isMobile: false,
                    ),
                  ),
                ),
              ],
            )
          else if (isTablet)
            Column(
              children: [
                StaggeredEntrance(
                  index: 0,
                  child: _buildLeftOverview(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isMobile: false,
                  ),
                ),
                const SizedBox(height: 28),
                StaggeredEntrance(
                  index: 1,
                  child: _buildContactFormCard(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isMobile: false,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                StaggeredEntrance(
                  index: 0,
                  child: _buildLeftOverview(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isMobile: true,
                  ),
                ),
                const SizedBox(height: 24),
                StaggeredEntrance(
                  index: 1,
                  child: _buildContactFormCard(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isMobile: true,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  /// Left-side (or top on mobile/tablet): Character stage, direct contact action buttons, and availability indicators.
  Widget _buildLeftOverview(
    BuildContext context, {
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // 3D Cartoon Contact Character Stage with "Let's Connect" scribble badge
        Center(
          child: _ContactCharacterStage(isMobile: isMobile, isDark: isDark),
        ),
        const SizedBox(height: 24),

        // Two-Option Direct Contact Buttons: Email Me + Chat on WhatsApp
        if (isMobile)
          Column(
            children: [
              _buildDirectEmailButton(isDark, textColor, secondaryTextColor),
              const SizedBox(height: 12),
              _buildWhatsAppButton(isDark, textColor, secondaryTextColor),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildDirectEmailButton(
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildWhatsAppButton(
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
              ),
            ],
          ),
        const SizedBox(height: 18),

        // Status & Availability Indicators Row
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            // Available for new opportunities
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981), // Emerald green
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF10B981),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Available for new opportunities',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF475569),
                  ),
                ),
              ],
            ),

            // Usually replies within a day
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  'Usually replies within a day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// "Email Me" direct action button with mail app launcher
  Widget _buildDirectEmailButton(
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return _InteractiveContactActionCard(
      onTap: _openDirectEmail,
      isDark: isDark,
      accentColor: const Color(0xFF8B5CF6), // Violet
      backgroundGradient: LinearGradient(
        colors: isDark
            ? [
                const Color(0xFF7C3AED).withOpacity(0.22),
                const Color(0xFF6366F1).withOpacity(0.08),
              ]
            : [const Color(0xFFF5F3FF), Colors.white],
      ),
      iconWidget: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.mail_rounded,
          size: 19,
          color: Color(0xFFA78BFA),
        ),
      ),
      title: 'Email Me',
      subtitle: 'Open your mail app',
    );
  }

  /// "Chat on WhatsApp" direct action button
  Widget _buildWhatsAppButton(
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return _InteractiveContactActionCard(
      onTap: _openWhatsApp,
      isDark: isDark,
      accentColor: const Color(0xFF10B981), // Emerald green
      backgroundGradient: LinearGradient(
        colors: isDark
            ? [
                const Color(0xFF10B981).withOpacity(0.24),
                const Color(0xFF059669).withOpacity(0.10),
              ]
            : [const Color(0xFFECFDF5), Colors.white],
      ),
      iconWidget: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: _WhatsAppIconWidget(size: 20)),
      ),
      title: 'Chat on WhatsApp',
      subtitle: 'Quick response',
      titleColor: isDark ? Colors.white : const Color(0xFF065F46),
      subtitleColor: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857),
    );
  }

  /// Right-side: "Send me a message" Card with Form, Dropdown, Text Area, and CTA
  Widget _buildContactFormCard(
    BuildContext context, {
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isMobile,
  }) {
    final inputBg = isDark
        ? const Color(0xFF0B1020).withOpacity(0.7)
        : const Color(0xFFF8FAFC);
    final borderColor = isDark
        ? const Color(0xFF1E2848)
        : const Color(0xFFE2E8F0);

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 26),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(
          isDark ? 0.78 : 0.95,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.28 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header: Icon + "Send me a message"
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.violetPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.violetPrimary.withOpacity(0.35),
                    ),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 20,
                    color: AppColors.violetLight,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send me a message',
                        style: TextStyle(
                          fontSize: isMobile ? 17 : 18.5,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tell me about your project, opportunity or just say hello!',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: secondaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Name & Email Fields (Side-by-side on desktop/tablet, stacked on mobile)
            if (isMobile) ...[
              _buildTextFormField(
                controller: _nameController,
                hintText: 'Your Name *',
                prefixIcon: Icons.person_outline_rounded,
                isDark: isDark,
                inputBg: inputBg,
                borderColor: borderColor,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Enter your name'
                    : null,
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: _emailController,
                hintText: 'Your Email *',
                prefixIcon: Icons.mail_outline_rounded,
                isDark: isDark,
                inputBg: inputBg,
                borderColor: borderColor,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Enter your email';
                  }
                  if (!val.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      controller: _nameController,
                      hintText: 'Your Name *',
                      prefixIcon: Icons.person_outline_rounded,
                      isDark: isDark,
                      inputBg: inputBg,
                      borderColor: borderColor,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Enter your name'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTextFormField(
                      controller: _emailController,
                      hintText: 'Your Email *',
                      prefixIcon: Icons.mail_outline_rounded,
                      isDark: isDark,
                      inputBg: inputBg,
                      borderColor: borderColor,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Enter your email';
                        }
                        if (!val.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 14),

            // Subject Dropdown
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              items: _subjectOptions.map((opt) {
                return DropdownMenuItem<String>(
                  value: opt,
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedSubject = val),
              dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: secondaryTextColor,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: inputBg,
                prefixIcon: Icon(
                  Icons.format_list_bulleted_rounded,
                  size: 19,
                  color: secondaryTextColor,
                ),
                hintText: 'Select Subject *',
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: secondaryTextColor.withOpacity(0.7),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.cyanPrimary,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Please select a subject' : null,
            ),
            const SizedBox(height: 14),

            // Message Area
            TextFormField(
              controller: _messageController,
              minLines: 4,
              maxLines: 5,
              style: TextStyle(fontSize: 14, color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: inputBg,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: Icon(
                    Icons.chat_outlined,
                    size: 19,
                    color: secondaryTextColor,
                  ),
                ),
                hintText: 'Tell me about your project or opportunity...',
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: secondaryTextColor.withOpacity(0.7),
                ),
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.cyanPrimary,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Please write a message'
                  : null,
            ),
            const SizedBox(height: 20),

            // Submit Button: "Open Email App"
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendEmail,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.violetPrimary.withOpacity(0.4),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8B5CF6), // Violet
                        Color(0xFF6D28D9), // Deep Purple
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Open Email App',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Clarifying Note
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: secondaryTextColor,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Your default email app will open with your message ready to send.',
                    style: TextStyle(fontSize: 12, color: secondaryTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required bool isDark,
    required Color inputBg,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 14, color: textColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: inputBg,
        prefixIcon: Icon(prefixIcon, size: 19, color: secondaryTextColor),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 13.5,
          color: secondaryTextColor.withOpacity(0.7),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.cyanPrimary,
            width: 1.5,
          ),
        ),
      ),
      validator: validator,
    );
  }
}

/// Interactive direct action card for Email Me & Chat on WhatsApp
class _InteractiveContactActionCard extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDark;
  final Color accentColor;
  final Gradient backgroundGradient;
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final Color? subtitleColor;

  const _InteractiveContactActionCard({
    required this.onTap,
    required this.isDark,
    required this.accentColor,
    required this.backgroundGradient,
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  State<_InteractiveContactActionCard> createState() =>
      _InteractiveContactActionCardState();
}

class _InteractiveContactActionCardState
    extends State<_InteractiveContactActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isHovered && mounted) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (_isHovered && mounted) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -3.0 : 0.0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.backgroundGradient,
            color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor
                  : widget.accentColor.withOpacity(widget.isDark ? 0.35 : 0.25),
              width: _isHovered ? 1.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withOpacity(
                  _isHovered ? 0.25 : (widget.isDark ? 0.08 : 0.04),
                ),
                blurRadius: _isHovered ? 14 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              widget.iconWidget,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color:
                            widget.titleColor ??
                            (widget.isDark
                                ? Colors.white
                                : AppColors.darkBackground),
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color:
                            widget.subtitleColor ??
                            (widget.isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: widget.accentColor.withOpacity(_isHovered ? 1.0 : 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Character illustration stage with glowing circular backdrop and "Let's Connect" scribble badge
class _ContactCharacterStage extends StatelessWidget {
  final bool isMobile;
  final bool isDark;

  const _ContactCharacterStage({required this.isMobile, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final double stageWidth = isMobile ? 220 : 250;
    final double stageHeight = isMobile ? 220 : 250;

    return SizedBox(
      width: stageWidth,
      height: stageHeight,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ambient glowing circular backdrop
          Container(
            width: stageWidth * 0.88,
            height: stageHeight * 0.88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withOpacity(isDark ? 0.40 : 0.25),
                  const Color(0xFF06B6D4).withOpacity(isDark ? 0.22 : 0.12),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // Outer glass ring
          Container(
            width: stageWidth * 0.94,
            height: stageHeight * 0.94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? const Color(0xFF8B5CF6).withOpacity(0.35)
                    : const Color(0xFF8B5CF6).withOpacity(0.25),
                width: 1.5,
              ),
            ),
          ),

          // 3D Cartoon Contact Character
          Image.asset(
            'assets/images/developer_character_contact.png',
            height: isMobile ? 200 : 230,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),

          // "Let's Connect" Scribble badge (top right of character)
          Positioned(
            top: isMobile ? 12 : 16,
            right: isMobile ? 4 : 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF131B34) : Colors.white)
                    .withOpacity(0.92),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cyanPrimary.withOpacity(0.55),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyanPrimary.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Let's Connect",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: AppColors.cyanLight,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.call_made_rounded,
                    size: 12,
                    color: AppColors.cyanLight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pixel-perfect WhatsApp circular logo icon
class _WhatsAppIconWidget extends StatelessWidget {
  final double size;

  const _WhatsAppIconWidget({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF25D366), // WhatsApp Brand Green
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.call_rounded, size: size * 0.60, color: Colors.white),
    );
  }
}
