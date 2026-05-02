import 'scene.dart';

/// Scene indices:
///   0  Hallway intro (single Continue button)
///   1  Door / The Encounter
///   2  Inspiration
///   3  Passion Path
///   4  Logic Path
///   5  Art Club  (turning point)
///   6  Hidden Talent (turning point)
///   7  The Critique (turning point)
///   8  Good Ending
///   9  Neutral Ending
///  10  Bad Ending
class StoryBrain {
  int _sceneNumber = 0;

  final List<Scene> _storyData = [
    // 0 — Hallway intro
    Scene(
      storyText:
          'The neon lights of Tokyo usually felt like a cold, boring grid to '
          'Emi Akimoto. As a top-tier student, her life was a series of '
          'checkboxes: Study. Excel. Repeat. But the night she found the art '
          'room door ajar, the grid shattered.',
      imagePath: 'assets/images/hallwayy.png',
      choiceTexts: ['Continue...', '', ''],
      nextSceneIndices: [1, 1, 1],
    ),
    // 1 — Scene 0: The Encounter (door)
    Scene(
      storyText:
          'Scene 0: The Encounter\n\n'
          'Then, she saw it through the cracked door of the art room: a '
          'canvas drenched in a blue so deep it felt like drowning in a '
          'summer sky. Propped against a dusty easel was a Shibuya morning '
          'glowing in that impossible blue.',
      imagePath: 'assets/images/door.png',
      choiceTexts: [
        'Push the door open, stepping into the scent of turpentine and possibility.',
        'Adjust your glasses, ignore the pull, and walk toward the library.',
        '',
      ],
      nextSceneIndices: [2, 9, 9],
    ),
    // 2 — Scene 1: The Inspiration
    Scene(
      storyText:
          'Scene 1: The Inspiration\n\n'
          'The smell of paint fills her lungs. She feels a pull toward the '
          'brushes she has ignored her whole life.',
      imagePath: 'assets/images/art_room.png',
      choiceTexts: [
        'Paint "The Blue." Ignore form and focus entirely on the feeling of the color.',
        'Paint "Reality." Try to sketch the room exactly as it is—ordered and precise.',
        '',
      ],
      nextSceneIndices: [3, 4, 4],
    ),
    // 3 — Scene 2: Passion Path
    Scene(
      storyText:
          'Scene 2: Passion Path\n\n'
          'Her strokes are messy and chaotic, but for the first time, Emi '
          'feels a spark of life in her chest.',
      imagePath: 'assets/images/passion.jpg',
      choiceTexts: [
        'Join Art Club. She can\'t do this alone—seek out the club members.',
        'Paint in secret. Hide the canvas under the bed, terrified of mother\'s reaction.',
        '',
      ],
      nextSceneIndices: [5, 6, 6],
    ),
    // 4 — Scene 3: Logic Path
    Scene(
      storyText:
          'Scene 3: Logic Path\n\n'
          'She paints a technically perfect, photorealistic apple. It is '
          'flawless, but it feels as cold as her high grades.',
      imagePath: 'assets/images/passed.jpg',
      choiceTexts: [
        'Try harder. Stay late, obsessing over anatomy and light.',
        'Give up. Realize your hands can\'t capture what your eyes can\'t feel.',
        '',
      ],
      nextSceneIndices: [7, 10, 10],
    ),
    // 5 — Scene 4: The Art Club (turning point)
    Scene(
      storyText:
          'Scene 4: The Art Club\n\n'
          'The club president challenges her: "Don\'t paint what you see, '
          'Akimoto. Paint how the world feels."',
      imagePath: 'assets/images/art_room.png',
      choiceTexts: [
        'Paint the city—chase the feeling of Tokyo at midnight.',
        'Paint a friend—try to capture a heart you know.',
        '',
      ],
      nextSceneIndices: [8, 8, 8],
    ),
    // 6 — Scene 5: Hidden Talent (turning point)
    Scene(
      storyText:
          'Scene 5: Hidden Talent\n\n'
          'Emi hides her canvases under her bed. The pile grows. Eventually '
          'she must choose what to do with all that buried color.',
      imagePath: 'assets/images/hidden.png',
      choiceTexts: [
        'Show your work to your mother.',
        'Keep it hidden. Paint only for yourself.',
        '',
      ],
      nextSceneIndices: [8, 9, 9],
    ),
    // 7 — Scene 6: The Critique (turning point)
    Scene(
      storyText:
          'Scene 6: The Critique\n\n'
          'A teacher looks at her "perfect" work and sighs. "There is no '
          '\'Emi\' in this painting. It lacks soul."',
      imagePath: 'assets/images/critique.jpg',
      choiceTexts: [
        'Start over—pour yourself into the next canvas.',
        'Stop art entirely. Pack the brushes away.',
        '',
      ],
      nextSceneIndices: [11, 10, 10],
    ),
    // 8 — Good Ending
    Scene(
      storyText:
          'Scene 7: The Good Ending\n\n'
          'Emi finds her "Blue Period." Her raw, '
          'emotional canvas stuns the judges, and she passes.',
      imagePath: 'assets/images/ending_good.jpg',
      choiceTexts: ['Restart', '', ''],
      nextSceneIndices: [0, 0, 0],
    ),
    // 9 — Neutral Ending
    Scene(
      storyText:
          'Scene 8: The Neutral Ending — The Hobbyist\n\n'
          'Emi chooses to be in the IT field but keeps a sketchbook. Her life is '
          'no longer grayscale, even if it isn\'t her career.',
      imagePath: 'assets/images/ending_neutral.png',
      choiceTexts: ['Restart', '', ''],
      nextSceneIndices: [0, 0, 0],
    ),
    // 10 — Bad Ending
    Scene(
      storyText:
          'Scene 9: The Bad Ending — The Grayscale Life\n\n'
          'Emi puts the brush down forever. She becomes a successful CEO, '
          'but feels nothing at all.',
      imagePath: 'assets/images/ending_bad.png',
      choiceTexts: ['Restart', '', ''],
      nextSceneIndices: [0, 0, 0],
    ),
    // 11 — Mother Approval (intermediate, leads to Good Ending)
    Scene(
      storyText:
          'Emi showed her mother her work. Her mother approves and '
          'encourages her to enter the Tokyo Art Exam.',
      imagePath: 'assets/images/passed.jpg',
      choiceTexts: ['Continue...', '', ''],
      nextSceneIndices: [8, 8, 8],
    ),
  ];

  // Ending scene indices.
  static const int goodEndingIndex = 8;
  static const int neutralEndingIndex = 9;
  static const int badEndingIndex = 10;

  int get sceneNumber => _sceneNumber;

  String getStory() => _storyData[_sceneNumber].storyText;
  String getImage() => _storyData[_sceneNumber].imagePath;
  String getChoice(int index) => _storyData[_sceneNumber].choiceTexts[index];

  /// Number of non-empty choices for the current scene.
  int choiceCount() => _storyData[_sceneNumber]
      .choiceTexts
      .where((t) => t.isNotEmpty)
      .length;

  void nextScene(int choiceIndex) {
    _sceneNumber = _storyData[_sceneNumber].nextSceneIndices[choiceIndex];
  }

  bool isGameOver() =>
      _sceneNumber == goodEndingIndex ||
      _sceneNumber == neutralEndingIndex ||
      _sceneNumber == badEndingIndex;
  bool isGoodEnding() => _sceneNumber == goodEndingIndex;
  bool isNeutralEnding() => _sceneNumber == neutralEndingIndex;

  void reset() {
    _sceneNumber = 0;
  }
}
