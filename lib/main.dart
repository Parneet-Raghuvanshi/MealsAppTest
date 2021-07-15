import 'package:flutter/material.dart';

import './dummy_data.dart';
import './models/meal.dart';
import './screens/filters_screen.dart';
import './screens/tabs_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/categories_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'vegan': false,
    'lactose': false,
    'vegetarian': false,
  };

  List<Meal> _avaliableMeals = DUMMY_MEALS;
  List<Meal> _favoritedMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _avaliableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] as bool && !meal.isGlutenFree) return false;
        if (_filters['lactose'] as bool && !meal.isLactoseFree) return false;
        if (_filters['vegan'] as bool && !meal.isVegan) return false;
        if (_filters['vegetarian'] as bool && !meal.isVegetarian) return false;
        return true;
      }).toList();
    });
  }

  void _toogleFavorite(String mealId) {
    final _existingIndex =
        _favoritedMeals.indexWhere((element) => element.id == mealId);
    if (_existingIndex >= 0) {
      setState(() {
        _favoritedMeals.removeAt(_existingIndex);
      });
    } else {
      setState(() {
        _favoritedMeals
            .add(DUMMY_MEALS.firstWhere((element) => element.id == mealId));
      });
    }
  }

  bool _isMealFavorite(String mealId) {
    return _favoritedMeals.any((element) => element.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            body1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            body2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            title: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsScreen(_favoritedMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_avaliableMeals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toogleFavorite, _isMealFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GzbMeals'),
      ),
      body: Center(
        child: Text('Navigation Time!'),
      ),
    );
  }
}
