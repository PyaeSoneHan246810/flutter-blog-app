int calculateReadingTime(String content) {
  const wordsPerMinute = 225;
  final words = content.split(RegExp(r'\s+')).length;
  final readingTime = words / wordsPerMinute;
  return readingTime.ceil();
}
