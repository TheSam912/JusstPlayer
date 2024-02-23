String DurationConverter(int durationInSeconds) {
  int minutes = (durationInSeconds / 60).truncate();
  int seconds = durationInSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
