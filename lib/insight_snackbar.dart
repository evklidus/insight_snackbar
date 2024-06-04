library insight_snackbar;

import 'dart:io';

import 'package:flutter/material.dart';

final isNeedCupertino = Platform.isIOS || Platform.isMacOS;

class InsightSnackBar {
  InsightSnackBar._();

  static final List<OverlayEntry> _entries = [];

  static bool hideIcon = false;

  static void showSuccessful(
    BuildContext context, {
    IconData? icon = Icons.done_rounded,
    // Пример: "Вы успешно авторизировались"
    String text = 'Успешно',
  }) =>
      _show(
        context: context,
        text: text,
        icon: icon,
      );

  static void showError(
    BuildContext context, {
    IconData? icon = Icons.error_rounded,
    // Пример: "Произошли проблемы с загрузкой фото, попробуйте позже"
    String text = 'Произошли проблемы с загрузкой фото, попробуйте позже',
  }) =>
      _show(
        context: context,
        text: text,
        icon: icon,
        iconColor: Theme.of(context).colorScheme.error,
      );

  static void showInfo(
    BuildContext context, {
    IconData? icon = Icons.info_rounded,
    String text = 'Информация',
  }) =>
      _show(
        context: context,
        text: text,
        icon: icon,
      );

  static void _show({
    required BuildContext context,
    required String text,
    required IconData? icon,
    Color? iconColor,
  }) {
    late OverlayEntry entry;
    final overlay = Overlay.of(context);
    entry = OverlayEntry(
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewPadding.bottom;
        return Positioned(
          bottom: bottomInset,
          right: 16,
          left: 16,
          child: Material(
            color: Colors.transparent,
            child: _CustomSnackBarWidget(
              text: text,
              icon: icon,
              iconColor: iconColor,
              removeOverlayEntry: () {
                _entries.remove(entry);
                entry.remove();
                if (_entries.isNotEmpty) {
                  overlay.insert(_entries.last);
                }
              },
            ),
          ),
        );
      },
    );
    if (_entries.isEmpty) {
      overlay.insert(entry);
    }
    _entries.insert(0, entry);
  }
}

/// {@template toast_notification}
/// CustomSnackBar widget.
/// {@endtemplate}
class _CustomSnackBarWidget extends StatefulWidget {
  /// {@macro toast_notification}
  const _CustomSnackBarWidget({
    required this.text,
    required this.icon,
    this.iconColor,
    required this.removeOverlayEntry,
  });

  final IconData? icon;
  final Color? iconColor;
  final String text;
  final VoidCallback removeOverlayEntry;

  @override
  State<_CustomSnackBarWidget> createState() => __CustomSnackBarWidgetState();
}

class __CustomSnackBarWidgetState extends State<_CustomSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    _controller.addStatusListener(_statusListener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(
        const Duration(seconds: 2),
        close,
      );
    }
  }

  Future<void> close() async {
    await _controller.reverse(from: 0.25);
    widget.removeOverlayEntry();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _animation,
        child: Container(
          height: MediaQuery.sizeOf(context).height / 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 12,
          ),
          child: Row(
            children: [
              if (widget.icon != null && !InsightSnackBar.hideIcon)
                Icon(
                  widget.icon,
                  size: 32,
                  color: widget.iconColor,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
}
