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
      height: 110,
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
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image/Icon with border
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF2f1b1e),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFec1337)
                      : Colors.white.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Center(child: _buildImageOrIcon()),
            ),
            const SizedBox(height: 6),
            // Brand name outside the border
            Text(
              brand.name,
              style: TextStyle(
                color: isSelected ? const Color(0xFFec1337) : Colors.white,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOrIcon() {
    // Display image or icon
    if (brand.imageUrl != null && brand.imageUrl!.isNotEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            brand.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF482329),
                child: const Icon(
                  Icons.movie,
                  color: Color(0xFFc9929b),
                  size: 24,
                ),
              );
            },
          ),
        ),
      );
    } else if (brand.icon != null) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: brand.isFeatured
              ? const Color(0xFFec1337)
              : const Color(0xFF482329),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(brand.icon, color: Colors.white, size: 28),
      );
    }
    return const SizedBox.shrink();
  }
}
