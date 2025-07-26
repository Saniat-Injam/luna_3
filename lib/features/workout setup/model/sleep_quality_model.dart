/*
{
  "quality": "normal",
  "lowerLimit": 5,
  "upperLimit": 6,
  "_id": "68593d00ae46426ed849f8b2"
}
*/

class SleepQualityModel {
  final String quality;
  final int lowerLimit;
  final int upperLimit;
  final String id;

  SleepQualityModel({
    required this.quality,
    required this.lowerLimit,
    required this.upperLimit,
    required this.id,
  });

  factory SleepQualityModel.fromJson(Map<String, dynamic> json) {
    return SleepQualityModel(
      quality: json['quality'],
      lowerLimit: json['lowerLimit'],
      upperLimit: json['upperLimit'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quality'] = quality;
    data['lowerLimit'] = lowerLimit;
    data['upperLimit'] = upperLimit;
    data['_id'] = id;
    return data;
  }
}
