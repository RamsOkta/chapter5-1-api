import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'meal_list.dart';

class MealHomePage extends StatefulWidget {
  @override
  _MealHomePageState createState() => _MealHomePageState();
}

class _MealHomePageState extends State<MealHomePage> {
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categories = List<Category>.from(
            data['categories'].map((category) => Category.fromJson(category)));
        filteredCategories.addAll(categories);
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void filterCategories(String query) {
    List<Category> filteredList = [];
    filteredList.addAll(categories);
    if (query.isNotEmpty) {
      filteredList.retainWhere((category) =>
          category.name.toLowerCase().contains(query.toLowerCase()));
    }
    setState(() {
      filteredCategories.clear();
      filteredCategories.addAll(filteredList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Categories'),
        actions: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: searchController,
                onChanged: filterCategories,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealListPage(
                    category: filteredCategories[index],
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      filteredCategories[index].imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      filteredCategories[index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        filteredCategories[index].description ??
                            'No description available',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Category {
  final String name;
  final String imageURL;
  final String? description;

  Category({required this.name, required this.imageURL, this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['strCategory'],
      imageURL: json['strCategoryThumb'],
      description: json['strCategoryDescription'],
    );
  }
}

class Meal {
  final String name;
  final String imageURL;

  Meal({required this.name, required this.imageURL});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['strMeal'],
      imageURL: json['strMealThumb'],
    );
  }
}
