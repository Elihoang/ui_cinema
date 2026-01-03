import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationLoadingShimmer extends StatelessWidget {
  const NotificationLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon shimmer
              Shimmer.fromColors(
                baseColor: const Color(0xFF3a1c20),
                highlightColor: const Color(0xFF4a2c30),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3a1c20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Content shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title shimmer
                    Shimmer.fromColors(
                      baseColor: const Color(0xFF3a1c20),
                      highlightColor: const Color(0xFF4a2c30),
                      child: Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3a1c20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Message shimmer (2 lines)
                    Shimmer.fromColors(
                      baseColor: const Color(0xFF3a1c20),
                      highlightColor: const Color(0xFF4a2c30),
                      child: Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3a1c20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Shimmer.fromColors(
                      baseColor: const Color(0xFF3a1c20),
                      highlightColor: const Color(0xFF4a2c30),
                      child: Container(
                        height: 14,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3a1c20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Time shimmer
                    Shimmer.fromColors(
                      baseColor: const Color(0xFF3a1c20),
                      highlightColor: const Color(0xFF4a2c30),
                      child: Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3a1c20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
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