import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonBase extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBase({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Slider
          const SkeletonBase(
            width: double.infinity,
            height: 250,
            borderRadius: BorderRadius.zero,
          ),
          const SizedBox(height: 20),

          // Horizontal List Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBase(width: 150, height: 20),
          ),
          const SizedBox(height: 10),
          // Horizontal List
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBase(
                      width: 140,
                      height: 100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    const SizedBox(height: 8),
                    const SkeletonBase(width: 100, height: 16),
                    const SizedBox(height: 4),
                    const SkeletonBase(width: 80, height: 12),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Another Horizontal List (Best Tour)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBase(width: 150, height: 20),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(
                2,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SkeletonBase(
                    width: double.infinity,
                    height: 100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          // Vertical List (Articles)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBase(width: 150, height: 20),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      SkeletonBase(
                        width: 80,
                        height: 80,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonBase(width: double.infinity, height: 16),
                            SizedBox(height: 8),
                            SkeletonBase(width: 100, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ListSkeleton({Key? key, this.shrinkWrap = false, this.physics})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              SkeletonBase(
                width: 60,
                height: 60,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBase(width: double.infinity, height: 16),
                    SizedBox(height: 8),
                    SkeletonBase(width: 100, height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBase(
            width: double.infinity,
            height: 250,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBase(width: 200, height: 24),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SkeletonBase(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    const SizedBox(width: 10),
                    const SkeletonBase(width: 100, height: 14),
                  ],
                ),
                const SizedBox(height: 24),
                // Paragraph lines
                const SkeletonBase(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                const SkeletonBase(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                const SkeletonBase(width: 200, height: 14),
                const SizedBox(height: 6),
                const SkeletonBase(width: double.infinity, height: 14),
                const SizedBox(height: 16),
                const SkeletonBase(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                const SkeletonBase(width: 150, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
