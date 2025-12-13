import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Picture with Edit Button
        SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF351a1e), width: 4),
                  image: DecorationImage(
                    image: NetworkImage(user.avatar),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFec1337),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF221013),
                      width: 4,
                    ),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // User Name
        Text(user.name, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        // Membership Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber[900]?.withOpacity(0.2),
            border: Border.all(
              color: Colors.amber[700]!.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user, color: Colors.amber[600], size: 16),
              const SizedBox(width: 6),
              Text(
                user.membershipLevel,
                style: TextStyle(
                  color: Colors.amber[600],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
