import 'package:flutter/material.dart';

class CinemaBrandSelector extends StatelessWidget {
  final List<CinemaBrand> brands;
  final int selectedIndex;
  final Function(int) onBrandSelected;

  const CinemaBrandSelector({
    super.key,
    required this.brands,
    required this.selectedIndex,
    required this.onBrandSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF221013),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isSelected = index == selectedIndex;
          return CinemaBrandItem(
            brand: brand,
            isSelected: isSelected,
            onTap: () => onBrandSelected(index),
          );
        },
      ),
    );
  }
}

class CinemaBrand {
  final String name;
  final IconData? icon;
  final String? imageUrl;
  final bool isFeatured;

  CinemaBrand({
    required this.name,
    this.icon,
    this.imageUrl,
    this.isFeatured = false,
  });
}

class CinemaBrandItem extends StatelessWidget {
  final CinemaBrand brand;
  final bool isSelected;
  final VoidCallback onTap;

  const CinemaBrandItem({
    super.key,
    required this.brand,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: brand.isFeatured
              ? const Color(0xFFec1337).withOpacity(0.15)
              : const Color(0xFF2f1b1e),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFec1337)
                : brand.isFeatured
                ? const Color(0xFFec1337)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (brand.icon != null)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: brand.isFeatured
                      ? const Color(0xFFec1337)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(brand.icon, color: Colors.white, size: 22),
              )
            else if (brand.imageUrl != null)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.movie, color: Colors.white, size: 32),
              ),
            const SizedBox(height: 4),
            Text(
              brand.name,
              style: TextStyle(
                color: brand.isFeatured
                    ? const Color(0xFFec1337)
                    : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
