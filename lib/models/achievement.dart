class Achievement {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double percent;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.percent
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'],
      percent: double.tryParse(json['percent'].toString()) ?? 0.0,
    );
  }
}