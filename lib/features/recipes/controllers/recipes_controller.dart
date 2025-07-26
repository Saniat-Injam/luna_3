import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/image_path.dart';
import 'package:barbell/features/recipes/models/recipe_model.dart';

class RecipesController extends GetxController {
  final RxList<Recipe> allRecipes = <Recipe>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDemoRecipes();
  }

  void loadDemoRecipes() {
    // Regular recipes
    final regularRecipes = [
      Recipe(
        id: '1',
        name: 'Vegan Chili',
        imageUrl: ImagePath.veganchili,
        calories: 300,
        ingredients: [
          '2 cans black beans',
          '1 onion, diced',
          '2 bell peppers',
          'Chili powder',
          'Cumin',
        ],
        instructions: [
          'Dice vegetables',
          'Sauté onions and peppers',
          'Add beans and spices',
          'Simmer for 20 minutes',
        ],
      ),
      Recipe(
        id: '2',
        name: 'Beef Stew',
        imageUrl: ImagePath.beefstew,
        calories: 170,
        ingredients: [
          'Beef chunks',
          'Carrots',
          'Potatoes',
          'Beef broth',
          'Herbs',
        ],
        instructions: [
          'Brown the beef',
          'Add vegetables',
          'Pour in broth',
          'Simmer for 2 hours',
        ],
      ),
    ];

    // My Recipes (matching the image)
    final myRecipes = [
      Recipe(
        id: 'my1',
        name: 'Chicken',
        imageUrl: ImagePath.chickenProvencal,
        calories: 780,
        ingredients: [
          'Whole chicken',
          'Herbs and spices',
          'Garlic',
          'Olive oil',
        ],
        instructions: [
          'Preheat oven',
          'Season chicken',
          'Roast until golden',
          'Rest before serving',
        ],
        isMyRecipe: true,
      ),
      Recipe(
        id: 'my2',
        name: 'Lemon Pasta',
        imageUrl: ImagePath.lemonpasta,
        calories: 90,
        ingredients: ['Pasta', 'Lemon', 'Parmesan', 'Olive oil', 'Garlic'],
        instructions: [
          'Cook pasta',
          'Make lemon sauce',
          'Combine and toss',
          'Garnish and serve',
        ],
        isMyRecipe: true,
      ),
      Recipe(
        id: 'my3',
        name: 'Avocado Toast',
        imageUrl: ImagePath.avocadoToast,
        calories: 400,
        ingredients: [
          'Chicken breast',
          'Bell peppers',
          'Onions',
          'Fajita seasoning',
        ],
        instructions: [
          'Slice chicken and vegetables',
          'Cook chicken',
          'Sauté vegetables',
          'Combine and serve',
        ],
        isMyRecipe: true,
      ),
      Recipe(
        id: 'my4',
        name: 'Baked Salmon',
        imageUrl: ImagePath.bakedSalmon,
        calories: 600,
        ingredients: ['Salmon', 'Lemon', 'Garlic', 'Olive oil'],
        instructions: [
          'Preheat oven',
          'Season salmon',
          'Bake until cooked',
          'Garnish and serve',
        ],
        isMyRecipe: true,
      ),
      Recipe(
        id: 'my4',
        name: 'Grilled Salmon',
        imageUrl: ImagePath.grilledSalmon,
        calories: 600,
        ingredients: ['Salmon', 'Lemon', 'Garlic', 'Olive oil'],
        instructions: [
          'Preheat oven',
          'Season salmon',
          'Bake until cooked',
          'Garnish and serve',
        ],
        isMyRecipe: true,
      ),
    ];

    allRecipes.value = [...regularRecipes, ...myRecipes];
  }

  List<Recipe> get filteredRecipes {
    if (searchQuery.value.isEmpty) return allRecipes;
    return allRecipes
        .where(
          (recipe) => recipe.name.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleFavorite(String recipeId) {
    final index = allRecipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index != -1) {
      final recipe = allRecipes[index];
      allRecipes[index] = recipe.copyWith(isFavorite: !recipe.isFavorite);
    }
  }
}
