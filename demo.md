# Canvas of the Heart — Demo Script
**Presenter:** Vargas, Rexie  
**Duration:** 5–7 minutes  

---

## 1. Introduction (30 seconds)

> "Good morning / afternoon. My project is called **Canvas of the Heart** — an interactive story app built with **Flutter**, where you play as Emi Akimoto, a top-student in Tokyo who discovers a passion for art. Every choice you make leads to a different outcome."

- Platform: Flutter (runs on web, mobile, desktop)
- Language: Dart
- Theme: Self-discovery, art, identity

---

## 2. App Structure Overview (1 minute)

> "Before I show the demo, let me quickly explain how the app is structured."

The project has **3 main Dart files:**

| File | Purpose |
|---|---|
| `main.dart` | UI — renders the scene image, dialogue box, and choice buttons |
| `story_brain.dart` | Logic — tracks current scene, processes choices, detects endings |
| `scene.dart` | Data model — holds text, image path, choices, and next scene indices |

> "This follows an **OOP (Object-Oriented Programming)** design. The `Scene` class is a **blueprint** — each scene is an **object** with its own data. The `StoryBrain` class **encapsulates** all the game logic: the player never touches the scene list directly."

---

## 3. OOP Concepts in the Code (1–1.5 minutes)

### Class & Object
```dart
// scene.dart
class Scene {
  String storyText;
  String imagePath;
  List<String> choiceTexts;
  List<int> nextSceneIndices;

  Scene({ required this.storyText, required this.imagePath,
          required this.choiceTexts, required this.nextSceneIndices });
}
```
> "`Scene` is a **class** — a template. Every scene in the story (the hallway, the art room, the endings) is an **instance** of that class stored in a list inside `StoryBrain`."

### Encapsulation
```dart
// story_brain.dart
class StoryBrain {
  int _sceneNumber = 0;          // private — hidden from outside

  String getStory() => _storyData[_sceneNumber].storyText;
  void nextScene(int choiceIndex) {
    _sceneNumber = _storyData[_sceneNumber].nextSceneIndices[choiceIndex];
  }
}
```
> "The current scene number is **private** (`_sceneNumber`). The UI in `main.dart` can only call public methods like `getStory()` or `nextScene()`. It never manipulates the data directly — that's **encapsulation**."

### State Management (StatefulWidget)
```dart
// main.dart
void _onChoice(int i) async {
  await _playClick();
  setState(() => _storyBrain.nextScene(i));   // triggers UI rebuild
  if (_storyBrain.isGameOver()) await _playEnding();
}
```
> "When the player picks a choice, `setState()` tells Flutter to **rebuild the UI** with the new scene — this is how Flutter reacts to changes."

---

## 4. Live Demo — Story Paths (2–2.5 minutes)

### Path A — Good Ending (show this first)
> "Let me show the **Good Ending** path."

1. Click **▶ Click to Begin** — title screen, background music starts
2. **Continue...** — Hallway intro
3. Choose **"Push the door open..."** → Scene 1: The Encounter
4. Choose **"Paint 'The Blue.'"** → Scene 2: Passion Path
5. Choose **"Join Art Club."** → Scene 4: The Art Club
6. Choose either option → **Good Ending** ✅ (good ending music plays, Emi passes the Tokyo Art Exam)

---

### Path B — Bad Ending (show this second)
> "Now let me show the **Bad Ending** path. I'll click Restart."

1. **Continue...** → Hallway intro
2. **"Push the door open..."** → The Encounter
3. **"Paint 'Reality.'"** → Scene 3: Logic Path (apple painting)
4. **"Give up."** → **Bad Ending** ✅ (bad ending music plays, Emi becomes a CEO who feels nothing)

---

### Path C — Neutral Ending (mention or show briefly)
> "There is also a **Neutral Ending** — if Emi walks away from the art room at the start, or hides her paintings and never shares them, she ends up as an IT professional who keeps a private sketchbook. A life that's no longer fully grey — but not the life she could have had."

---

## 5. Requirements Checklist (30 seconds)

| Requirement | Our App |
|---|---|
| At least 10 unique scenes | ✅ 12 scenes (0–11) |
| At least 4 decision points | ✅ 5 decision points (Scenes 0, 1, 2, 3/5/6, 7) |
| At least 3 different endings | ✅ Good, Neutral, Bad |
| At least 2 options per decision | ✅ Every decision has 2 choices |

---

## 6. Extra Features (30 seconds)

> "Beyond the requirements, I also added:"

- 🎵 **Background music** that loops during gameplay
- 🔊 **3 unique ending tracks** — different music for each ending
- 🖼️ **Full-screen scene images** with smooth transitions
- 🎮 **Visual Novel UI** — dialogue box, character name plate, choice ribbons
- 🖥️ **Title screen** with custom artwork
- 🌐 **Web-compatible** audio fix (tap-to-start to bypass browser autoplay block)

---

## 7. Closing (15 seconds)

> "Canvas of the Heart demonstrates core OOP principles — classes, objects, encapsulation, and state management — through an interactive narrative. Thank you!"

---

*End of demo script.*
