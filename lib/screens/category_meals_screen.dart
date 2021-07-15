import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  final List<Meal> avaliableMeals;

  CategoryMealsScreen(this.avaliableMeals);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String? categoryTitle;
  List<Meal>? categoryMeals;
  var _isDataLoaded = false;

  @override
  void didChangeDependencies() {
    if (!_isDataLoaded) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final categoryId = routeArgs['id'];
      categoryMeals = widget.avaliableMeals.where((element) {
        return element.categories.contains(categoryId);
      }).toList();
      categoryTitle = routeArgs['title'] as String;
      super.didChangeDependencies();
      _isDataLoaded = true;
    }
  }

  void _removeMeal(String mealId) {
    setState(() {
      categoryMeals!.removeWhere((element) => element.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle!),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(
            id: categoryMeals![index].id,
            title: categoryMeals![index].title,
            imageUrl: categoryMeals![index].imageUrl,
            duration: categoryMeals![index].duration,
            complexity: categoryMeals![index].complexity,
            affordability: categoryMeals![index].affordability,
          );
        },
        itemCount: categoryMeals!.length,
      ),
    );
  }
}
