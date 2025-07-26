class WorkoutModel {
  String? id;
  String? img;
  String? userId;
  String? name;
  String? description;
  String? primaryMuscleGroup;
  String? exerciseType;
  String? weightLifted;
  String? set;
  String? reps;
  String? resetTime;

  WorkoutModel({
    this.id,
    this.img,
    this.userId,
    this.name,
    this.description,
    this.primaryMuscleGroup,
    this.exerciseType,
    this.weightLifted,
    this.set,
    this.reps,
    this.resetTime,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
    id: json["_id"],
    img: json["img"],
    userId: json["user_id"],
    name: json["name"],
    description: json["description"],
    primaryMuscleGroup: json["primaryMuscleGroup"],
    exerciseType: json["exerciseType"],
    weightLifted: json["weightLifted"],
    set: json["set"],
    reps: json["reps"],
    resetTime: json["resetTime"],
  );
}
/*
{
    "success": true,
    "message": "Exercise retrieved successfully.",
    "data": {
        "_id": "68514081f393e163acacaf96",
        "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750155393/barbell%20carl-1750155392659.png",
        "user_id": "684563990c0b9410346f1f5c",
        "name": "barbell carl",
        "description": "great exercise",
        "primaryMuscleGroup": "Calves",
        "exerciseType": "cardio",
        "__v": 0,
        "weightLifted": "false",
        "set": "required",
        "reps": "required",
        "resetTime": "required"
    }
}
{
    "success": true,
    "message": "Exercises retrieved successfully.",
    "data": [
        {
            "_id": "6850e308a5cc720a720ed0fd",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750131464/barbell%20carl-1750131463806.png",
            "user_id": "6847edf9e20c705b82be9e52",
            "name": "barbell carl",
            "description": "great exercise",
            "primaryMuscleGroup": "Calves",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "6850eb9900513ef7cd6c63eb",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750133656/barbell%20carl-1750133655969.jpg",
            "user_id": "6847edf9e20c705b82be9e52",
            "name": "barbell carl",
            "description": "great exercise",
            "primaryMuscleGroup": "Calves",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "6850f1556014e22caebeff49",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750135125/barbell%20carl-1750135124044.jpg",
            "user_id": "6847edf9e20c705b82be9e52",
            "name": "barbell carl",
            "description": "great exercise",
            "primaryMuscleGroup": "Calves",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "6850fd67352713dc71b7325b",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750138214/Test-1750138214128.jpg",
            "user_id": "6847edf9e20c705b82be9e52",
            "name": "Test",
            "description": "Test description",
            "primaryMuscleGroup": "group 1",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "6850fd8d352713dc71b7325e",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750138252/Test%201-1750138252159.jpg",
            "user_id": "6847edf9e20c705b82be9e52",
            "name": "Test 1",
            "description": "Test description",
            "primaryMuscleGroup": "group 1",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "684f969964a105a239b613c9",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750046361/barbell%20carl-1750046360969.png",
            "user_id": null,
            "name": "barbell carl",
            "description": "great exercise",
            "primaryMuscleGroup": "Calves",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "684f988964a105a239b613dd",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750046856/barbell%20carl-1750046856285.png",
            "user_id": null,
            "name": "barbell carl",
            "description": "great exercise",
            "primaryMuscleGroup": "Calves",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "684fda2ac22c5050071bc223",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750063658/barbell%20carl-1750063658264.png",
            "user_id": null,
            "name": "barbell carl",
            "description": "great exercise",
            "primaryMuscleGroup": "Calves",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "684fdb57c22c5050071bc22f",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750063958/barbell%20carl-1750063958461.png",
            "user_id": null,
            "name": "barbell carl",
            "description": "great exercise",
            "primaryMuscleGroup": "Calves",
            "exerciseType": "cardio",
            "__v": 0
        },
        {
            "_id": "684fdbbfc22c5050071bc23d",
            "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750064062/barbell%20carl-1750064062394.png",
            "user_id": null,
            "name": "barbell carl",
            "description": "great exercise",
            "primaryMuscleGroup": "Calves",
            "exerciseType": "cardio",
            "__v": 0
        }
    ]
}
*/