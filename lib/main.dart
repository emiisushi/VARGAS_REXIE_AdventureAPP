import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'story_brain.dart';

void main() {
  runApp(const CanvasOfTheHeartApp());
}

class CanvasOfTheHeartApp extends StatelessWidget {
  const CanvasOfTheHeartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas of the Heart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E40AF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
      home: const StoryPage(),
    );
  }
}

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final StoryBrain _storyBrain = StoryBrain();
  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _endingPlayer = AudioPlayer();

  bool _bgStarted = false;

  @override
  void initState() {
    super.initState();
    _startBackgroundMusic();
  }

  Future<void> _startBackgroundMusic() async {
    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(0.4);
      await _bgPlayer.play(AssetSource('sounds/bgmusic.mp3'));
      _bgStarted = true;
    } catch (_) {
      // Audio failure shouldn't block gameplay.
    }
  }

  Future<void> _playClick() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/click.mp3'), volume: 0.8);
    } catch (_) {}
  }

  Future<void> _playEnding(bool good) async {
    try {
      await _endingPlayer.stop();
      await _endingPlayer.play(
        AssetSource(good ? 'sounds/good_ending.mp3' : 'sounds/bad_ending.mp3'),
        volume: 0.9,
      );
    } catch (_) {}
  }

  void _onChoice(int choiceIndex) async {
    await _playClick();
    setState(() {
      _storyBrain.nextScene(choiceIndex);
    });
    if (_storyBrain.isGameOver()) {
      await _playEnding(_storyBrain.isGoodEnding());
    }
  }

  void _restart() async {
    await _playClick();
    await _endingPlayer.stop();
    if (!_bgStarted) {
      _startBackgroundMusic();
    }
    setState(() {
      _storyBrain.reset();
    });
  }

  @override
  void dispose() {
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
    _endingPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOver = _storyBrain.isGameOver();
    final choiceCount = _storyBrain.choiceCount();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: Image.asset(
                      _storyBrain.getImage(),
                      key: ValueKey(_storyBrain.getImage()),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.blueGrey.shade900,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported,
                            size: 64, color: Colors.white24),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Text(
                    _storyBrain.getStory(),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (isOver)
                ElevatedButton(
                  onPressed: _restart,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Restart',
                      style: TextStyle(fontSize: 16)),
                )
              else ...[
                for (int i = 0; i < choiceCount; i++) ...[
                  ElevatedButton(
                    onPressed: () => _onChoice(i),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      _storyBrain.getChoice(i),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
