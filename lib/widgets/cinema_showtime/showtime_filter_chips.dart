import 'package:flutter/material.dart';

// Location filter options
enum LocationFilter { nearest, hcm, hanoi }

extension LocationFilterExtension on LocationFilter {
  String get label {
    switch (this) {
      case LocationFilter.nearest:
        return 'Gần bạn nhất';
      case LocationFilter.hcm:
        return 'HCM';
      case LocationFilter.hanoi:
        return 'Hà Nội';
    }
  }

  IconData get icon => Icons.location_on;
}

class ShowtimeFilterChips extends StatelessWidget {
  final LocationFilter selectedLocation;
  final Function(LocationFilter) onLocationChanged;

  const ShowtimeFilterChips({
    super.key,
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2f1b1e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Chọn vùng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Location options
              ...LocationFilter.values.map((location) {
                final isSelected = selectedLocation == location;
                return InkWell(
                  onTap: () {
                    onLocationChanged(location);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF482329)
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          location.icon,
                          color: isSelected
                              ? const Color(0xFFec1337)
                              : const Color(0xFFc9929b),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            location.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFFc9929b),
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: Color(0xFFec1337),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          LocationFilterChipItem(
            selectedLocation: selectedLocation,
            onTap: () => _showLocationBottomSheet(context),
          ),
        ],
      ),
    );
  }
}

class LocationFilterChipItem extends StatelessWidget {
  final LocationFilter selectedLocation;
  final VoidCallback onTap;

  const LocationFilterChipItem({
    super.key,
    required this.selectedLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF482329),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, color: Color(0xFFec1337), size: 16),
            const SizedBox(width: 6),
            Text(
              selectedLocation.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

// Keep the old classes for backward compatibility if needed elsewhere
class ShowtimeFilter {
  final IconData icon;
  final String label;

  ShowtimeFilter({required this.icon, required this.label});
}

class ShowtimeFilterChipItem extends StatelessWidget {
  final ShowtimeFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const ShowtimeFilterChipItem({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF482329) : const Color(0xFF2f1b1e),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(isSelected ? 0.1 : 0.05),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              filter.icon,
              color: isSelected
                  ? const Color(0xFFec1337)
                  : const Color(0xFFc9929b),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              filter.label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFc9929b),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
