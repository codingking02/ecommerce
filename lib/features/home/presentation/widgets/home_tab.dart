import 'dart:async';

import 'package:ecommerce/core/resources/assets_manager.dart';
import 'package:ecommerce/core/service/service_locator.dart';
import 'package:ecommerce/core/widgets/error_indicator.dart';
import 'package:ecommerce/core/widgets/loading_indicator.dart';
import 'package:ecommerce/features/home/presentation/cubit/categories_cubit.dart';
import 'package:ecommerce/features/home/presentation/cubit/categories_states.dart';
import 'package:ecommerce/features/home/presentation/widgets/announcements_section.dart';
import 'package:ecommerce/features/home/presentation/widgets/category_item.dart';
import 'package:ecommerce/features/home/presentation/widgets/custom_section_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTab extends StatefulWidget {
  const HomeTab();

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentIndex = 0;
  late Timer _timer;
  final List<String> _announcementsImagesPaths = [
    ImageAssets.carouselSlider1,
    ImageAssets.carouselSlider2,
    ImageAssets.carouselSlider3,
  ];

  @override
  void initState() {
    super.initState();
    _startImageSwitching();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoriesCubit>(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AnnouncementsSection(
              imagesPaths: _announcementsImagesPaths,
              currentIndex: _currentIndex,
            ),
            Column(
              children: [
                CustomSectionBar(
                  sectionName: 'Categories',
                  onViewAllClicked: () {},
                ),
                BlocBuilder<CategoriesCubit, CategoriesStates>(
                  builder: (context, state) {
                    if (state is CategoriesLoading) {
                      return const LoadingIndicator();
                    } else if (state is CategoriesError) {
                      return const ErrorIndicator();
                    } else if (state is CategoriesSuccess) {
                      return SizedBox(
                        height: 270.h,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (_, index) =>
                              CategoryItem(state.categories[index]),
                          itemCount: state.categories.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startImageSwitching() {
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (Timer timer) {
      setState(
        () => _currentIndex =
            (_currentIndex + 1) % _announcementsImagesPaths.length,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
