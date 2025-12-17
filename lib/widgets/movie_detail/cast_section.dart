import 'package:flutter/material.dart';
import '../../models/actor.dart';

class CastSection extends StatelessWidget {
  final List<Actor> actors;
  const CastSection({super.key, required this.actors});

  @override
  Widget build(BuildContext context) {
    if (actors.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Text(
          'Chưa có thông tin diễn viên',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Diễn viên',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: EdgeInsets.zero, // bỏ padding
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final member = actors[index];

              return SizedBox(
                width: 80,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage:
                          (member.imageUrl != null &&
                              member.imageUrl!.isNotEmpty)
                          ? NetworkImage(member.imageUrl!)
                          : null,
                      backgroundColor: Colors.grey.shade800,
                      child:
                          (member.imageUrl == null || member.imageUrl!.isEmpty)
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      member.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Diễn viên', // role mặc định
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
