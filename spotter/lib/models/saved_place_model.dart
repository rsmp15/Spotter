class SavedPlace {
  final String id;
  final String label; // e.g., 'Home', 'Office', or custom name
  final String address;
  final double lat;
  final double lng;
  final String iconType; // 'home', 'work', 'star'

  const SavedPlace({
    required this.id,
    required this.label,
    required this.address,
    required this.lat,
    required this.lng,
    required this.iconType,
  });

  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      id: json['id'] as String,
      label: json['label'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      iconType: json['iconType'] as String? ?? 'star',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'address': address,
        'lat': lat,
        'lng': lng,
        'iconType': iconType,
      };

  SavedPlace copyWith({
    String? id,
    String? label,
    String? address,
    double? lat,
    double? lng,
    String? iconType,
  }) {
    return SavedPlace(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      iconType: iconType ?? this.iconType,
    );
  }
}

