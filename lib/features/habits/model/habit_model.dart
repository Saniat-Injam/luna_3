/*
        {
            "_id": "685b95be7bb065adf3d9e4c7",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750832572/Eat%20more%20vegetables-1750832572180.svg",
            "name": "Eat more vegetables",
            "description": "Add natural sweetness and essential vitamins to your diet.",
            "__v": 0
        }
*/

class HabitModel {
  final String id;
  final String img;
  final String name;
  final String description;

  HabitModel({
    required this.id,
    required this.img,
    required this.name,
    required this.description,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['_id'],
      img: json['img'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'img': img, 'name': name, 'description': description};
  }
}
