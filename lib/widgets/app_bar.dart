import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Custom AppBar Widget - Varınca (Geliştirilmiş)
class VarincaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;

  const VarincaAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.showBackButton = false,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 14),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.softPink, width: 1)),
      ),
      child: Row(
        children: [
          // Leading / Back Button / Logo
          if (showBackButton)
            _buildBackButton(context)
          else if (leading != null)
            leading!
          else if (showLogo)
            _buildLogo(),

          if (showLogo || showBackButton || leading != null)
            const SizedBox(width: 14),

          // Title
          if (centerTitle) const Spacer(),

          if (title != null)
            Expanded(
              flex: centerTitle ? 0 : 1,
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkText,
                  letterSpacing: -0.8,
                ),
              ),
            ),

          if (centerTitle) const Spacer(),

          // Actions
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.lightPink,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.softPink, width: 1),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primaryRed,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/varincalogo.png',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Varınca',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.darkText,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}

/// AppBar Action Button - Modern & Professional
class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final int? badgeCount;
  final Color? iconColor;
  final Color? backgroundColor;

  const AppBarActionButton({
    super.key,
    required this.icon,
    this.onTap,
    this.badgeCount,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: iconColor ?? AppColors.darkText, size: 20),
            if (badgeCount != null && badgeCount! > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    badgeCount! > 9 ? '9+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
