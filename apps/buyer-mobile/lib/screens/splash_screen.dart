import 'package:flutter/material.dart';

import '../design_system/generated/color_tokens.dart';
import '../design_system/motion.dart';

/// Continues the native launch screen: the mark keeps the exact size and centre
/// position of the Android/iOS splash, then the wordmark and progress fade in.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  /// Must match the native splash assets (`drawable-xxxhdpi/splash_icon.png`,
  /// `LaunchImage`). Small enough to sit inside the Android 12 icon mask.
  static const Size markSize = Size(112, 101);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

const double _wordmarkGap = 20;
const double _wordmarkHeight = 40;

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 480),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (BuyerMotion.reduced(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reveal = CurvedAnimation(
      parent: _controller,
      curve: BuyerMotion.enter,
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(reveal);

    return Scaffold(
      backgroundColor: const Color(MateryalColorTokens.surfacePrimary),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mirrors the wordmark slot below so the mark stays exactly centred.
                const SizedBox(height: _wordmarkGap + _wordmarkHeight),
                Semantics(
                  label: 'MateryalPH',
                  image: true,
                  child: Image.asset(
                    'assets/branding/materyalph-mark.png',
                    width: SplashScreen.markSize.width,
                    height: SplashScreen.markSize.height,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    gaplessPlayback: true,
                  ),
                ),
                const SizedBox(height: _wordmarkGap),
                SizedBox(
                  height: _wordmarkHeight,
                  child: FadeTransition(
                    opacity: reveal,
                    child: SlideTransition(
                      position: slide,
                      child: const ExcludeSemantics(child: _Wordmark()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: FadeTransition(
                  opacity: reveal,
                  child: const SizedBox(
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        color: Color(MateryalColorTokens.actionPrimary),
                        backgroundColor: Color(
                          MateryalColorTokens.brandOrange100,
                        ),
                        semanticsLabel: 'Opening your account',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      color: const Color(MateryalColorTokens.textStrong),
    );
    return Text.rich(
      TextSpan(
        text: 'Materyal',
        children: const [
          TextSpan(
            text: 'PH',
            style: TextStyle(color: Color(MateryalColorTokens.actionPrimary)),
          ),
        ],
      ),
      style: base,
      textAlign: TextAlign.center,
    );
  }
}
