class Category {

  int id;
  String name;
  String description;
  bool? deleted;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.deleted
  });

  factory Category.fromCategoriesJson(Map<String, dynamic> json) => Category(
    id: json['id'], 
    name: json['name'], 
    description: json['description']
  );

}