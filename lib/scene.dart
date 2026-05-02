class Scene {
  String storyText;
  String imagePath;
  List<String> choiceTexts;
  List<int> nextSceneIndices;
  // Optional: Add a field for sound effects if you implement audio

  Scene({
    required this.storyText,
    required this.imagePath,
    required this.choiceTexts,
    required this.nextSceneIndices,
  });
}