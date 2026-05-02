import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'story_brain.dart';

void main() {
  runApp(const CanvasOfTheHeartApp());
}

// ── Deep-ocean colour palette ──────────────────────────────────────────────
class _C {
  static const bg         = Color(0xFF030B18);
  static const dialogueBg = Color(0xE00A1628);
  static const nameBg     = Color(0xFF003E5C);
  static const accent     = Color(0xFF00B4D8);
  static const accentDim  = Color(0xFF0077B6);
  static const choiceBg   = Color(0xCC071E3D);
  static const choiceHover= Color(0xCC0E3A6E);
  static const textSub    = Color(0xFFADE8F4);
}

class CanvasOfTheHeartApp extends StatelessWidget {
  const CanvasOfTheHeartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas of the Heart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _C.bg,
        useMaterial3: true,
      ),
      home: const StoryPage(),
    );
  }
}

// ── Story page ──────────────────────────────────────────────────────────────
class StoryPage extends StatefulWidget {
  const StoryPage({super.key});
  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final StoryBrain _storyBrain = StoryBrain();
  final AudioPlayer _bgPlayer  = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _endPlayer = AudioPlayer();

  bool _audioReady = false;
  bool _started    = false; // shows tap-to-start overlay until first click

  // ── audio ──────────────────────────────────────────────────────────────
  Future<void> _initAudio() async {
    if (_audioReady) return;
    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(0.4);
      await _bgPlayer.play(AssetSource('sounds/bgmusic.mp3'));
      _audioReady = true;
    } catch (_) {}
  }

  Future<void> _playClick() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/click.mp3'), volume: 0.8);
    } catch (_) {}
  }

  Future<void> _playEnding() async {
    try {
      await _bgPlayer.stop();
      await _endPlayer.stop();
      final String track;
      if (_storyBrain.isGoodEnding()) {
        track = 'sounds/good_ending.mp3';
      } else if (_storyBrain.isNeutralEnding()) {
        track = 'sounds/neutral_ending.mp3';
      } else {
        track = 'sounds/ending_bad.mp3';
      }
      await _endPlayer.play(AssetSource(track), volume: 0.9);
    } catch (_) {}
  }

  // ── interactions ────────────────────────────────────────────────────────
  void _onStart() async {
    await _playClick();
    await _initAudio();
    setState(() => _started = true);
  }

  void _onChoice(int i) async {
    await _playClick();
    setState(() => _storyBrain.nextScene(i));
    if (_storyBrain.isGameOver()) {
      await _playEnding();
    }
  }

  void _restart() async {
    await _playClick();
    await _endPlayer.stop();
    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(0.4);
      await _bgPlayer.play(AssetSource('sounds/bgmusic.mp3'));
    } catch (_) {}
    setState(() => _storyBrain.reset());
  }

  @override
  void dispose() {
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
    _endPlayer.dispose();
    super.dispose();
  }

  // ── build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1 — Full-screen background image
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: Image.asset(
              _started ? _storyBrain.getImage() : 'assets/images/title.png',
              key: ValueKey(_started ? _storyBrain.getImage() : 'title'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) =>
                  Container(color: _C.bg),
            ),
          ),

          // 2 — Bottom-heavy gradient overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 1.0],
                colors: [
                  Colors.black.withAlpha(30),
                  Colors.transparent,
                  const Color(0xFF030B18).withAlpha(245),
                ],
              ),
            ),
          ),

          // 3 — Game UI (choice ribbons + dialogue box)
          if (_started) _buildGameUI(context),

          // 4 — Tap-to-start overlay (shown on first load)
          if (!_started) _buildStartOverlay(),
        ],
      ),
    );
  }

  // ── tap-to-start overlay ─────────────────────────────────────────────────
  Widget _buildStartOverlay() {
    return ColoredBox(
      color: Colors.black.withAlpha(170),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Canvas of the Heart',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _C.accent,
                letterSpacing: 2,
                shadows: [Shadow(color: _C.accent, blurRadius: 14)],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '— an interactive story —',
              style: TextStyle(
                fontSize: 13,
                color: _C.textSub,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 52),
            GestureDetector(
              onTap: _onStart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                decoration: BoxDecoration(
                  color: _C.choiceBg,
                  border: Border.all(color: _C.accent, width: 1.4),
                ),
                child: const Text(
                  '▶   Click to Begin',
                  style: TextStyle(
                    fontSize: 16,
                    color: _C.accent,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── in-game UI ───────────────────────────────────────────────────────────
  Widget _buildGameUI(BuildContext context) {
    final isOver      = _storyBrain.isGameOver();
    final choiceCount = _storyBrain.choiceCount();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Choice ribbons
          if (isOver)
            _ChoiceRibbon(label: 'Restart', onTap: _restart)
          else
            for (int i = 0; i < choiceCount; i++)
              _ChoiceRibbon(
                label: _storyBrain.getChoice(i),
                onTap: () => _onChoice(i),
              ),

          // Dialogue box
          Container(
            decoration: const BoxDecoration(
              color: _C.dialogueBg,
              border: Border(
                top: BorderSide(color: _C.accent, width: 1.2),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character name plate
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  color: _C.nameBg,
                  child: const Text(
                    '[ EMI ]',
                    style: TextStyle(
                      fontSize: 12,
                      color: _C.accent,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Story text — scrollable so nothing is cut off
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 130),
                  child: SingleChildScrollView(
                    child: Text(
                      _storyBrain.getStory(),
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.65,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── VN-style choice ribbon button ────────────────────────────────────────────
class _ChoiceRibbon extends StatefulWidget {
  const _ChoiceRibbon({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_ChoiceRibbon> createState() => _ChoiceRibbonState();
}

class _ChoiceRibbonState extends State<_ChoiceRibbon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          margin: const EdgeInsets.only(bottom: 1),
          decoration: BoxDecoration(
            color: _hovered ? _C.choiceHover : _C.choiceBg,
            border: Border(
              left: BorderSide(
                color: _hovered ? _C.accent : _C.accentDim,
                width: _hovered ? 3 : 2,
              ),
              bottom: const BorderSide(
                color: Color(0x220077B6),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                '▶  ',
                style: TextStyle(
                  fontSize: 12,
                  color: _hovered ? _C.accent : _C.accentDim,
                ),
              ),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: _hovered ? Colors.white : _C.textSub,
                    letterSpacing: 0.3,
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
