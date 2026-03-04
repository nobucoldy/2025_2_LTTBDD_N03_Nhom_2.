import 'package:flutter/material.dart';
import '../models/category_model.dart';

final List<CategoryModel> sampleCategories = [
  CategoryModel(
    id: 'personal',
    name: 'Cá nhân',
    icon: Icons.person,
    color: Colors.blue,
  ),
  CategoryModel(
    id: 'work',
    name: 'Công việc',
    icon: Icons.work,
    color: Colors.orange,
  ),
  CategoryModel(
    id: 'study',
    name: 'Học tập',
    icon: Icons.school,
    color: Colors.purple,
  ),
  CategoryModel(
    id: 'health',
    name: 'Sức khỏe',
    icon: Icons.favorite,
    color: Colors.red,
  ),
  CategoryModel(
    id: 'finance',
    name: 'Tài chính',
    icon: Icons.attach_money,
    color: Colors.green,
  ),
];
