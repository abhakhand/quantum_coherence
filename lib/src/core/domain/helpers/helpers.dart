String sessionName() {
  final date = DateTime.now();
  if (date.hour < 12) {
    return 'Morning';
  } else if (date.hour < 15) {
    return 'Afternoon';
  } else {
    return 'Evening';
  }
}
