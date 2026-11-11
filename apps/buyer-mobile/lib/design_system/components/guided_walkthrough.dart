import 'package:flutter/material.dart';
import '../theme.dart';

class WalkthroughStep {
  const WalkthroughStep({
    required this.target,
    required this.title,
    required this.description,
    required this.icon,
    required this.destination,
  });
  final GlobalKey target;
  final String title;
  final String description;
  final IconData icon;
  final int destination;
}

/// A modal, read-only spotlight. The underlying interface remains mounted and is
/// never tapped by the tutorial. Platform back and the close button both skip.
Future<bool> showGuidedWalkthrough(
  BuildContext context, {
  required List<WalkthroughStep> steps,
  required void Function(int) selectDestination,
}) async =>
    await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Skip tutorial',
      barrierColor: Colors.transparent,
      transitionDuration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 160),
      pageBuilder: (context, _, _) =>
          _Walkthrough(steps: steps, selectDestination: selectDestination),
      transitionBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ) ??
    false;

class _Walkthrough extends StatefulWidget {
  const _Walkthrough({required this.steps, required this.selectDestination});
  final List<WalkthroughStep> steps;
  final void Function(int) selectDestination;
  @override
  State<_Walkthrough> createState() => _WalkthroughState();
}

class _WalkthroughState extends State<_Walkthrough>
    with WidgetsBindingObserver {
  int _index = 0;
  Rect? _target;
  final _heading = FocusNode();
  int _layoutRevision = 0;
  WalkthroughStep get _step => widget.steps[_index];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locate();
  }

  @override
  void didChangeMetrics() => _measureAfterLayout();
  void _locate() {
    widget.selectDestination(_step.destination);
    _measureAfterLayout();
  }

  void _measureAfterLayout() {
    final revision = ++_layoutRevision;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      var targetContext = _step.target.currentContext;
      for (var attempt = 0; targetContext == null && attempt < 10; attempt++) {
        await Future<void>.delayed(const Duration(milliseconds: 80));
        if (!mounted || revision != _layoutRevision) return;
        targetContext = _step.target.currentContext;
      }
      if (targetContext != null && targetContext.mounted) {
        await Scrollable.ensureVisible(targetContext, alignment: .35);
      }
      if (!mounted || revision != _layoutRevision) return;
      final box = _step.target.currentContext?.findRenderObject();
      if (box is RenderBox && box.hasSize && box.attached) {
        final offset = box.localToGlobal(Offset.zero);
        setState(() => _target = offset & box.size);
      } else {
        setState(() => _target = null);
      }
      _heading.requestFocus();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _move(int index) {
    setState(() {
      _index = index;
      _target = null;
    });
    _locate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _heading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    final hole = _target?.inflate(4).intersect(Offset.zero & size);
    // Bottom navigation targets keep the card directly above them. Upper-page
    // targets put it below, with a scrolling fallback for large text/landscape.
    final bottomTarget = hole != null && hole.top > size.height / 2;
    final top = bottomTarget
        ? padding.top + 16
        : (hole?.bottom ?? padding.top) + 16;
    final bottom = bottomTarget
        ? size.height - hole.top + 16
        : padding.bottom + 16;
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      namesRoute: true,
      label: 'Guided tutorial',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: CustomPaint(painter: _SpotlightPainter(hole)),
              ),
            ),
            if (hole != null)
              AnimatedPositioned(
                duration: reduce
                    ? Duration.zero
                    : const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                left: hole.left,
                top: hole.top,
                width: hole.width,
                height: hole.height,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: BuyerTheme.action, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: top,
              bottom: bottom,
              left: 16,
              right: 16,
              child: Align(
                alignment: bottomTarget
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'QUICK TOUR · ${_index + 1} OF ${widget.steps.length}',
                                  style: const TextStyle(
                                    color: BuyerTheme.muted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Close tutorial',
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                icon: const Icon(Icons.close, size: 20),
                              ),
                            ],
                          ),
                          Semantics(
                            label: 'Tutorial progress',
                            value: '${_index + 1} of ${widget.steps.length}',
                            child: LinearProgressIndicator(
                              value: (_index + 1) / widget.steps.length,
                              minHeight: 3,
                              color: BuyerTheme.action,
                              backgroundColor: BuyerTheme.border,
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedSwitcher(
                            duration: reduce
                                ? Duration.zero
                                : const Duration(milliseconds: 160),
                            child: Column(
                              key: ValueKey(_index),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: BuyerTheme.canvas,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _step.icon,
                                    color: BuyerTheme.action,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Focus(
                                  focusNode: _heading,
                                  child: Semantics(
                                    header: true,
                                    liveRegion: true,
                                    child: Text(
                                      _step.title,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: BuyerTheme.ink,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _step.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: BuyerTheme.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(44, 44),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Skip'),
                              ),
                              Wrap(
                                spacing: 8,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(64, 44),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                    ),
                                    onPressed: _index == 0
                                        ? null
                                        : () => _move(_index - 1),
                                    child: const Text('Back'),
                                  ),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size(64, 44),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                    ),
                                    onPressed: () =>
                                        _index == widget.steps.length - 1
                                        ? Navigator.of(context).pop(true)
                                        : _move(_index + 1),
                                    child: Text(
                                      _index == widget.steps.length - 1
                                          ? 'Finish'
                                          : 'Next',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter(this.hole);
  final Rect? hole;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size);
    if (hole != null && !hole!.isEmpty) {
      path.addRRect(RRect.fromRectAndRadius(hole!, const Radius.circular(12)));
    }
    canvas.drawPath(
      path,
      Paint()..color = BuyerTheme.ink.withValues(alpha: .56),
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) => oldDelegate.hole != hole;
}
