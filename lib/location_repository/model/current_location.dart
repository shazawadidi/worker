class CurrentUserLocationEntity {
  const CurrentUserLocationEntity({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });
  final double latitude;
  final double longitude;
  final double? accuracy;

  static const empty = CurrentUserLocationEntity(latitude: 0, longitude: 0,accuracy:0);
}