import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_outlined,
            color: AppColors.primary,
            size: 28,
          ),
        ),
        flexibleSpace: Image.asset(
          'assets/360_F_466415129_mTSxvYJ6ugmN2UBv6ZYsxTYdQGj0p2YM.jpg',
          fit: BoxFit.cover,
        ),
        title: Material(
          // elevation: 6,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tên Bác sĩ, triệu chứng, v.v...',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              'https://img.freepik.com/free-vector/hospital-building-concept-illustration_114360-8440.jpg?w=1380&t=st=1709620000~exp=1709620600~hmac=abc',
            ),
          ],
        ),
      ),
    );
  }
}
