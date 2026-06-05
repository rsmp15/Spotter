// Spott MVP domain models – aligned with DATABASE_SCHEMA.md.
//
// These models are additive; the legacy [ride_models.dart] classes remain
// available for screens that have not yet migrated.

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Mirrors the `role` column of the Users table.
enum UserRole { passenger, traveler, parcelSender }

/// Shared verification lifecycle for driver-licence and vehicle checks.
enum VerificationStatus { pending, submitted, verified, rejected }

/// Overall trip lifecycle.
enum TripStatus { draft, active, inProgress, completed, cancelled }

/// Individual seat-request lifecycle.
enum TripRequestStatus { pending, accepted, rejected, cancelled }

/// Parcel hand-off lifecycle.
enum ParcelStatus {
  created,
  accepted,
  pickedUp,
  inTransit,
  delivered,
  cancelled,
}

// ---------------------------------------------------------------------------
// 1. SpottUser
// ---------------------------------------------------------------------------

class SpottUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profileImage;
  final double rating;
  final UserRole role;
  final DateTime createdAt;

  const SpottUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.profileImage,
    this.rating = 5.0,
    this.role = UserRole.passenger,
    required this.createdAt,
  });

  factory SpottUser.fromJson(Map<String, dynamic> json) {
    return SpottUser(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      profileImage: json['profile_image'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.passenger,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'profile_image': profileImage,
    'rating': rating,
    'role': role.name,
    'created_at': createdAt.toIso8601String(),
  };

  SpottUser copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profileImage,
    double? rating,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return SpottUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// ---------------------------------------------------------------------------
// 2. DriverVerification
// ---------------------------------------------------------------------------

class DriverVerification {
  final String id;
  final String userId;
  final String dlNumber;
  final String? dlImage;
  final VerificationStatus verificationStatus;

  const DriverVerification({
    required this.id,
    required this.userId,
    required this.dlNumber,
    this.dlImage,
    this.verificationStatus = VerificationStatus.pending,
  });

  factory DriverVerification.fromJson(Map<String, dynamic> json) {
    return DriverVerification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      dlNumber: json['dl_number'] as String,
      dlImage: json['dl_image'] as String?,
      verificationStatus: VerificationStatus.values.firstWhere(
        (e) => e.name == json['verification_status'],
        orElse: () => VerificationStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'dl_number': dlNumber,
    'dl_image': dlImage,
    'verification_status': verificationStatus.name,
  };

  DriverVerification copyWith({
    String? id,
    String? userId,
    String? dlNumber,
    String? dlImage,
    VerificationStatus? verificationStatus,
  }) {
    return DriverVerification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dlNumber: dlNumber ?? this.dlNumber,
      dlImage: dlImage ?? this.dlImage,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Vehicle
// ---------------------------------------------------------------------------

class Vehicle {
  final String id;
  final String userId;
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleModel;
  final String? rcImage;
  final VerificationStatus verificationStatus;

  const Vehicle({
    required this.id,
    required this.userId,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleModel,
    this.rcImage,
    this.verificationStatus = VerificationStatus.pending,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      vehicleType: json['vehicle_type'] as String,
      vehicleNumber: json['vehicle_number'] as String,
      vehicleModel: json['vehicle_model'] as String,
      rcImage: json['rc_image'] as String?,
      verificationStatus: VerificationStatus.values.firstWhere(
        (e) => e.name == json['verification_status'],
        orElse: () => VerificationStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vehicle_type': vehicleType,
    'vehicle_number': vehicleNumber,
    'vehicle_model': vehicleModel,
    'rc_image': rcImage,
    'verification_status': verificationStatus.name,
  };

  Vehicle copyWith({
    String? id,
    String? userId,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleModel,
    String? rcImage,
    VerificationStatus? verificationStatus,
  }) {
    return Vehicle(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      rcImage: rcImage ?? this.rcImage,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Trip
// ---------------------------------------------------------------------------

class Trip {
  final String id;
  final String travelerId;
  final String source;
  final String destination;
  final DateTime departureTime;
  final int availableSeats;
  final int pricePerSeat;
  final bool parcelAllowed;
  final TripStatus status;

  const Trip({
    required this.id,
    required this.travelerId,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.availableSeats,
    required this.pricePerSeat,
    this.parcelAllowed = false,
    this.status = TripStatus.draft,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      travelerId: json['traveler_id'] as String,
      source: json['source'] as String,
      destination: json['destination'] as String,
      departureTime: DateTime.parse(json['departure_time'] as String),
      availableSeats: json['available_seats'] as int,
      pricePerSeat: json['price_per_seat'] as int,
      parcelAllowed: json['parcel_allowed'] as bool? ?? false,
      status: TripStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TripStatus.draft,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'traveler_id': travelerId,
    'source': source,
    'destination': destination,
    'departure_time': departureTime.toIso8601String(),
    'available_seats': availableSeats,
    'price_per_seat': pricePerSeat,
    'parcel_allowed': parcelAllowed,
    'status': status.name,
  };

  Trip copyWith({
    String? id,
    String? travelerId,
    String? source,
    String? destination,
    DateTime? departureTime,
    int? availableSeats,
    int? pricePerSeat,
    bool? parcelAllowed,
    TripStatus? status,
  }) {
    return Trip(
      id: id ?? this.id,
      travelerId: travelerId ?? this.travelerId,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      departureTime: departureTime ?? this.departureTime,
      availableSeats: availableSeats ?? this.availableSeats,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      parcelAllowed: parcelAllowed ?? this.parcelAllowed,
      status: status ?? this.status,
    );
  }

  String get priceLabel => 'Rs $pricePerSeat';
}

// ---------------------------------------------------------------------------
// 5. TripRequest
// ---------------------------------------------------------------------------

class TripRequest {
  final String id;
  final String tripId;
  final String passengerId;
  final TripRequestStatus status;

  const TripRequest({
    required this.id,
    required this.tripId,
    required this.passengerId,
    this.status = TripRequestStatus.pending,
  });

  factory TripRequest.fromJson(Map<String, dynamic> json) {
    return TripRequest(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      passengerId: json['passenger_id'] as String,
      status: TripRequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TripRequestStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'trip_id': tripId,
    'passenger_id': passengerId,
    'status': status.name,
  };

  TripRequest copyWith({
    String? id,
    String? tripId,
    String? passengerId,
    TripRequestStatus? status,
  }) {
    return TripRequest(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      passengerId: passengerId ?? this.passengerId,
      status: status ?? this.status,
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Parcel
// ---------------------------------------------------------------------------

class Parcel {
  final String id;
  final String senderId;
  final String travelerId;
  final double weight;
  final String description;
  final String? photo;
  final String pickupOtp;
  final String deliveryOtp;
  final ParcelStatus status;

  const Parcel({
    required this.id,
    required this.senderId,
    required this.travelerId,
    required this.weight,
    required this.description,
    this.photo,
    required this.pickupOtp,
    required this.deliveryOtp,
    this.status = ParcelStatus.created,
  });

  factory Parcel.fromJson(Map<String, dynamic> json) {
    return Parcel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      travelerId: json['traveler_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      description: json['description'] as String,
      photo: json['photo'] as String?,
      pickupOtp: json['pickup_otp'] as String,
      deliveryOtp: json['delivery_otp'] as String,
      status: ParcelStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ParcelStatus.created,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender_id': senderId,
    'traveler_id': travelerId,
    'weight': weight,
    'description': description,
    'photo': photo,
    'pickup_otp': pickupOtp,
    'delivery_otp': deliveryOtp,
    'status': status.name,
  };

  Parcel copyWith({
    String? id,
    String? senderId,
    String? travelerId,
    double? weight,
    String? description,
    String? photo,
    String? pickupOtp,
    String? deliveryOtp,
    ParcelStatus? status,
  }) {
    return Parcel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      travelerId: travelerId ?? this.travelerId,
      weight: weight ?? this.weight,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      pickupOtp: pickupOtp ?? this.pickupOtp,
      deliveryOtp: deliveryOtp ?? this.deliveryOtp,
      status: status ?? this.status,
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Review
// ---------------------------------------------------------------------------

class Review {
  final String id;
  final String reviewerId;
  final String reviewedUserId;
  final double rating;
  final String? comment;

  const Review({
    required this.id,
    required this.reviewerId,
    required this.reviewedUserId,
    required this.rating,
    this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      reviewerId: json['reviewer_id'] as String,
      reviewedUserId: json['reviewed_user_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'reviewer_id': reviewerId,
    'reviewed_user_id': reviewedUserId,
    'rating': rating,
    'comment': comment,
  };

  Review copyWith({
    String? id,
    String? reviewerId,
    String? reviewedUserId,
    double? rating,
    String? comment,
  }) {
    return Review(
      id: id ?? this.id,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewedUserId: reviewedUserId ?? this.reviewedUserId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }
}
