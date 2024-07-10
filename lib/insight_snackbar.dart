library insight_snackbar;

import 'package:flutter/material.dart';

class InsightSnackBarConfiguration {
  const InsightSnackBarConfiguration({
    this.hideIcon = false,
    this.customBackgroundColor,
    this.allowIdenticals = false,
    this.entriesLimit = 3,
  });

  /// Need for hide/show [Icon] in snackbar near text
  final bool hideIcon;

  /// By default is [surfaceContainerHighest]
  final Color? customBackgroundColor;

  /// Does not allow the same snackbars
  final bool allowIdenticals;

  /// Limiting number of snackbars
  final int entriesLimit;
}

class InsightSnackBar {
  InsightSnackBar._();

  static final Set<OverlayEntry> _entries = {};

  /// Variable for hide/show icon in snackbar near text
  static InsightSnackBarConfiguration config =
      const InsightSnackBarConfiguration();

  static void showSuccessful(
    BuildContext context, {
    IconData? icon = Icons.done_rounded,
    // Example: "You have successfully logged in"
    String text = 'Successful',
    int? bottomPadding,
  }) =>
      _show(
        context: context,
        text: text,
        icon: icon,
        bottomPadding: bottomPadding,
      );

  static void showError(
    BuildContext context, {
    IconData? icon = Icons.error_rounded,
    // Example: "There were problems with loading photos, please try again later"
    String text =
        'There were problems with loading photos, please try again later',
    int? bottomPadding,
  }) =>
      _show(
        context: context,
        text: text,
        icon: icon,
        iconColor: Theme.of(context).colorScheme.error,
        bottomPadding: bottomPadding,
      );

  static void showInfo(
    BuildContext context, {
    IconData? icon = Icons.info_rounded,
    String text = 'Information',
    int? bottomPadding,
  }) =>
      _show(
        context: context,
        text: text,
        icon: icon,
        bottomPadding: bottomPadding,
      );

  static void _show({
    required BuildContext context,
    required String text,
    required IconData? icon,
    required int? bottomPadding,
    Color? iconColor,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    final overlayHash = Object.hash(
      text,
      icon,
      bottomPadding,
      iconColor,
    );

    final mediaQuery = MediaQuery.of(context);
    final bottomPosition =
        mediaQuery.viewPadding.bottom + (bottomPadding ?? 0) + 8;

    entry = _CustomOverlayEntry(
      customHash: config.allowIdenticals ? null : overlayHash,
      builder: (context) {
        return Positioned(
          bottom: bottomPosition,
          right: 16,
          left: 16,
          child: ColoredBox(
            color: Colors.transparent,
            child: _CustomSnackBarWidget(
              text: text,
              icon: icon,
              iconColor: iconColor,
              backgroundColor: config.customBackgroundColor,
              removeOverlayEntry: () {
                _entries.remove(entry);
                entry.remove();
                if (_entries.isNotEmpty) {
                  overlay.insert(_entries.first);
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
    if (_entries.length < config.entriesLimit) {
      _entries.add(entry);
    }
  }
}

class _CustomOverlayEntry extends OverlayEntry {
  _CustomOverlayEntry({
    required this.customHash,
    required super.builder,
  });

  final int? customHash;

  @override
  bool operator ==(Object other) =>
      other.hashCode == hashCode && other is _CustomOverlayEntry;

  @override
  int get hashCode => customHash ?? super.hashCode;
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
    required this.backgroundColor,
    required this.removeOverlayEntry,
  });

  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
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
          height: MediaQuery.sizeOf(context).shortestSide / 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.backgroundColor ??
                Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 12,
          ),
          child: Row(
            children: [
              if (widget.icon != null && !InsightSnackBar.config.hideIcon)
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
