class Doctor {
  final int id;
  final String name;
  final String specialty;
  final String imageUrl;
  final String crm;
  final double rating;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.crm,
    required this.rating,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      imageUrl: json['image_url'] as String,
      crm: json['crm'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }
} 