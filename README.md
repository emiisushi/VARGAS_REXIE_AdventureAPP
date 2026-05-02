# Canvas of the Heart
### A Choose Your Own Adventure Flutter App
**By Vargas, Rexie** | St. Paul University Philippines — School of Information Technology and Engineering
*Inspired by the manga "Blue Period" by Tsubasa Yamaguchi*

---

## Table of Contents

1. [Overview](#1-overview)
2. [Story Summary](#2-story-summary)
3. [Scene Map & Story Tree](#3-scene-map--story-tree)
4. [Features](#4-features)
5. [Technical Requirements Mapping](#5-technical-requirements-mapping)
6. [Project Structure](#6-project-structure)
7. [Dependencies](#7-dependencies)
8. [Asset Manifest](#8-asset-manifest)
9. [How to Run](#9-how-to-run)
10. [AI Image Declaration](#10-ai-image-declaration)

---

## 1. Overview

**Canvas of the Heart** is an interactive, branching-narrative Flutter app following Emi Akimoto — a high-achieving Tokyo student who stumbles upon an art room and must choose between the life she was programmed to live and the one she secretly wants.

The app was built as the Term-End Requirement for the Mobile Application Development course. It demonstrates OOP architecture, state management, asset handling, and audio integration — all inside a fully themed visual-novel-style interface.

> *"I didn't know what blue meant until I started painting it."*
> — Inspired by *Blue Period* by Tsubasa Yamaguchi

---

## 2. Story Summary

Emi Akimoto is a model student in Tokyo. One night, she finds the art room door ajar and sees a canvas soaked in an impossible shade of blue. That single moment cracks her perfectly ordered life open.

The story follows Emi across **12 scenes** through two major paths:

- **The Passion Path** — Emi follows feeling, joins the Art Club, or paints in secret.
- **The Logic Path** — Emi tries to master art through technique alone, facing criticism that cuts to the bone.

Every choice the player makes determines whether Emi finds her voice, settles for a quiet life, or abandons art forever.

---

## 3. Scene Map & Story Tree

```
[Scene 0] Hallway Intro
      │
      ▼
[Scene 1] The Encounter ──────────────────────────────────────────┐
      │  Push the door open                  Ignore the pull       │
      ▼                                                            │
[Scene 2] The Inspiration                                         │
      │  Paint "The Blue"    Paint "Reality"                      │
      ▼                          ▼                                │
[Scene 3] Passion Path    [Scene 4] Logic Path                   │
      │  Join Art Club  /         │  Try harder / Give up         │
      │  Paint in secret          ▼                               │
      │                    [Scene 7] The Critique                 │
      ▼                          │  Start over / Stop art         │
[Scene 5] Art Club          ─────┘                                │
      │  Paint city / friend       ▼                              ▼
      ▼                    [Scene 10] BAD ENDING       [Scene 9] NEUTRAL ENDING
[Scene 6] Hidden Talent   (The Grayscale Life)         (The Hobbyist)
      │  Show mother /
      │  Keep hidden
      ▼
[Scene 11] Mother Approval  ◄──── also reached from:
      │                            Scene 3 (Passion Path → Art Club → ...)
      ▼                            Scene 7 (Critique → Start over)
[Scene 8] GOOD ENDING
(The Blue Period)
```

### Endings at a Glance

| Ending | Scene | How to reach it |
|---|---|---|
| **Good** — The Blue Period | 8 | Open the door → Paint "The Blue" → Join Art Club or Show mother → Continue |
| **Neutral** — The Hobbyist | 9 | Ignore the door **or** Paint in secret → Keep it hidden |
| **Bad** — The Grayscale Life | 10 | Paint "Reality" → Give up **or** Start over fails → Stop art |

---

## 4. Features

| Feature | Detail |
|---|---|
| Visual-novel layout | Full-screen scene image with a bottom dialogue box and choice ribbons |
| Deep-ocean colour palette | Dark navy `#030B18`, cyan accent `#00B4D8`, translucent overlays |
| Title screen | `title.png` displayed clean with only a "Click to Begin" button |
| Animated scene transitions | `AnimatedSwitcher` with 700 ms crossfade on every scene change |
| Dialogue box | Character name plate `[ EMI ]` + scrollable story text |
| Choice ribbons | Hover-sensitive, left-accent-bordered choice buttons |
| Per-ending music | Good → `good_ending.mp3`, Neutral → `neutral_ending.mp3`, Bad → `ending_bad.mp3` |
| Click SFX | `click.mp3` plays on every button press including "Click to Begin" |
| Background music | Looping `bgmusic.mp3` starts on first user interaction (browser autoplay-safe) |
| Restart | Resets scene index to 0 and resumes background music |

---

## 5. Technical Requirements Mapping

### R1 — OOP Structure

The story data lives in two dedicated classes:

**`Scene`** (`lib/scene.dart`)
```dart
class Scene {
  String storyText;        // narrative text shown in the dialogue box
  String imagePath;        // path to the scene's background image
  List<String> choiceTexts;     // up to 3 choice labels (empty = unused)
  List<int> nextSceneIndices;   // maps each choice to its destination scene
}
```

**`StoryBrain`** (`lib/story_brain.dart`)
- Holds `_storyData` — a **private** `List<Scene>` (encapsulation ✓)
- Tracks `_sceneNumber` — also private
- Exposes public API:
  - `getStory()` — returns current scene's narrative text
  - `getImage()` — returns current scene's image path
  - `getChoice(int index)` — returns choice label at index
  - `choiceCount()` — number of non-empty choices
  - `nextScene(int choiceIndex)` — advances the scene
  - `isGameOver()` — true when any ending is reached
  - `isGoodEnding()` / `isNeutralEnding()` — identify which ending
  - `reset()` — returns scene index to 0

### R2 — State Management

- `StoryPage` is a `StatefulWidget`
- Every scene advance, restart, and overlay toggle is wrapped in `setState()`

### R3 — Layout & Widgets

| Widget | Where used |
|---|---|
| `Scaffold` | Root of `StoryPage` |
| `SafeArea` | Wraps the start overlay and game UI |
| `Column` | Choice ribbon stack + dialogue box contents |
| `Expanded` / `ConstrainedBox` | Responsive story text area |
| `Padding` | Dialogue box internal spacing |
| `Text` | Story text, name plate, choice labels |
| `ElevatedButton` / `GestureDetector` | Choice ribbons and Begin button |
| `Card` / `Container` with decoration | Dialogue box, name plate, choice ribbons |
| `AnimatedSwitcher` | Scene image crossfade |
| `Stack` | Layering image, gradient, game UI |

### R4 — Assets

- Every scene has a dedicated background image (12 images total)
- All images registered in `pubspec.yaml`
- Images change on every scene transition via `AnimatedSwitcher`
- AI-generated images are declared in [Section 10](#10-ai-image-declaration)

### R5 — Audio

- `audioplayers ^6.1.0` package
- `bgmusic.mp3` — loops throughout gameplay
- `click.mp3` — plays on every choice press
- `good_ending.mp3` — plays when the Good Ending is reached
- `neutral_ending.mp3` — plays when the Neutral Ending is reached
- `ending_bad.mp3` — plays when the Bad Ending is reached
- Background music is started on first user interaction to comply with browser autoplay policy

### R6 — Alert / End Screen

When `isGameOver()` returns `true`, the game UI switches the choice ribbons to a single **Restart** button and the dialogue box displays which ending was reached — clearly labelled "The Good Ending", "The Neutral Ending — The Hobbyist", or "The Bad Ending — The Grayscale Life". Pressing Restart calls `reset()` via `setState()` and resumes background music.

### R7 — Git Repository

- Hosted at: `https://github.com/emiisushi/VARGAS_REXIE_AdventureAPP`
- Multiple incremental commits throughout development (assets, audio, UI, bug fixes, new scenes)

---

## 6. Project Structure

```
canvas-of-the-heart/
├── lib/
│   ├── main.dart          # App entry, UI, audio logic, VN layout
│   ├── story_brain.dart   # StoryBrain class — scene navigation & game state
│   └── scene.dart         # Scene data class
├── assets/
│   ├── images/
│   │   ├── title.png          # Title screen
│   │   ├── hallwayy.png       # Scene 0 — Hallway Intro
│   │   ├── door.png           # Scene 1 — The Encounter
│   │   ├── art_room.png       # Scene 2 & 4 — Inspiration / Art Club
│   │   ├── passion.jpg        # Scene 3 — Passion Path
│   │   ├── logic.jpg          # Scene 4 — Logic Path
│   │   ├── hidden.png         # Scene 5 — Hidden Talent
│   │   ├── critique.jpg       # Scene 6 — The Critique
│   │   ├── passed.jpg         # Scene 11 — Mother Approval
│   │   ├── ending_good.jpg    # Scene 8 — Good Ending
│   │   ├── ending_neutral.png # Scene 9 — Neutral Ending
│   │   └── ending_bad.png     # Scene 10 — Bad Ending
│   └── sounds/
│       ├── bgmusic.mp3        # Looping background music
│       ├── click.mp3          # Button click SFX
│       ├── good_ending.mp3    # Good ending music
│       ├── neutral_ending.mp3 # Neutral ending music
│       └── ending_bad.mp3     # Bad ending music
├── pubspec.yaml
└── README.md
```

---

## 7. Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  audioplayers: ^6.1.0
```

| Package | Purpose |
|---|---|
| `flutter` | Core UI framework |
| `cupertino_icons` | iOS-style icons |
| `audioplayers ^6.1.0` | Background music and sound effects |

---

## 8. Asset Manifest

### Images

| File | Scene | Description |
|---|---|---|
| `title.png` | Title Screen | App title screen background |
| `hallwayy.png` | Scene 0 | Tokyo school hallway at night |
| `door.png` | Scene 1 — The Encounter | Cracked art room door |
| `art_room.png` | Scene 2, 4 | Inside the art room / Art Club |
| `passion.jpg` | Scene 3 — Passion Path | Abstract emotional brushstrokes |
| `logic.jpg` | Scene 4 — Logic Path | Oil painting of a photorealistic apple |
| `hidden.png` | Scene 5 — Hidden Talent | Canvases hidden under the bed |
| `critique.jpg` | Scene 6 — The Critique | Teacher reviewing Emi's work |
| `passed.jpg` | Scene 11 — Mother Approval | Emi showing her work to her mother |
| `ending_good.jpg` | Scene 8 — Good Ending | Emi passing the Tokyo Art Exam |
| `ending_neutral.png` | Scene 9 — Neutral Ending | Emi with a sketchbook at her IT desk |
| `ending_bad.png` | Scene 10 — Bad Ending | Emi as a CEO, empty-eyed |

### Sounds

| File | Trigger |
|---|---|
| `bgmusic.mp3` | Loops from first interaction through all gameplay |
| `click.mp3` | Every button press |
| `good_ending.mp3` | Good Ending reached |
| `neutral_ending.mp3` | Neutral Ending reached |
| `ending_bad.mp3` | Bad Ending reached |

---

## 9. How to Run

**Prerequisites:** Flutter SDK installed, a browser or device connected.

```bash
# 1. Clone the repository
git clone https://github.com/emiisushi/VARGAS_REXIE_AdventureAPP.git
cd VARGAS_REXIE_AdventureAPP

# 2. Install dependencies
flutter pub get

# 3. Run on Chrome (web)
flutter run -d chrome

# 4. Or run on a connected device / emulator
flutter run
```

The title screen will appear. Click **"▶ Click to Begin"** to start the story and enable audio.

---

## 10. AI Image Declaration

The following images used in this project were **generated using AI tools** (Canva AI / similar):

| Image File | Scene | Declaration |
|---|---|---|
| `hallwayy.png` | Scene 0 — Hallway Intro | AI-generated |
| `door.png` | Scene 1 — The Encounter | AI-generated |
| `art_room.png` | Scene 2, 4 — Art Room / Art Club | AI-generated |
| `passion.jpg` | Scene 3 — Passion Path | AI-generated |
| `hidden.png` | Scene 5 — Hidden Talent | AI-generated |
| `ending_good.jpg` | Scene 8 — Good Ending | AI-generated |
| `ending_neutral.png` | Scene 9 — Neutral Ending | AI-generated |
| `ending_bad.png` | Scene 10 — Bad Ending | AI-generated |
| `title.png` | Title Screen | AI-generated |
| `passed.jpg` | Scene 11 — Mother Approval | AI-generated |

The following images are **sourced from the internet** (used for academic/non-commercial purposes):

| Image File | Scene | Source |
|---|---|---|
| `logic.jpg` | Scene 4 — Logic Path | Oil painting of an apple, artist S.A. (Pinterest) |
| `critique.jpg` | Scene 6 — The Critique | Referenced from internet |

---

*Canvas of the Heart is a student project submitted in partial fulfillment of the Term-End Requirement for Mobile Application Development, S.Y. 2025–2026.*
*Inspired by the manga "Blue Period" (青の時代) by Tsubasa Yamaguchi, published by Kodansha.*
