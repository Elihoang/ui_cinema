// widgets/cast_section.dart
import 'package:flutter/material.dart';

class CastSection extends StatelessWidget {
  const CastSection({super.key});

  final List<Map<String, dynamic>> _cast = const [
    {
      'name': 'Denis V.',
      'role': 'Đạo diễn',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC2BUSdPdka7lPBFq-Ou8KjAkDT9lTSPNqJyUj5W0czhXya08lXwx_9Tb5hRMWHjVdHkewAeDQ8TuZbUG4VwdxYH-e3b75IIKkr_AQqE3ekVEsY-nmy6EXeR76VMO5tiqiE84AzarY715xqkkMCdE8H9NFIhFdIoXBAe3mvSRaHJLP-FGJILE-3_BldImPwz64_OvHmjTz6KnRcuq33IbaBBfxFa-LwKkpu1xvYvHwCJMHUidR84Wo-wP_wnADsJvjIHFMewf4vmf8',
      'isDirector': true,
    },
    {
      'name': 'Timothée C.',
      'role': 'Paul Atreides',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCH1tvBTmKmv489YPAP4hiQyDyL_MXGm6_uumyyF-_Xl92_5vWSqyDTv5VV9pPWvHd4amD3TKp320kRv7aHQwfBZaQubJROOVxJ_xWOHTHLKzdapxEaq5QdLaof6scLEwOY39mxa92PQjDk9L0d2VaWmc-sk3bQAKSy8BXbxuyUrhFEBBYCPPM_nomqlezcqKDfx9RfvCJXr34yWSTz6--AkO45jtg4NLqQFsavZhtwBHJPvcIGzUesstZ2GiORLNq3U5CC87qAnBA',
      'isDirector': false,
    },
    {
      'name': 'Zendaya',
      'role': 'Chani',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBBKyoy-aSibcdcuRUC6JfNQV7eEnGLglCgqueggwa7Rd_xx8R3RzRlgf2lQ1QONKr7pyGgoea9cQc37jy7YDwsU-Wnqyqscm_QEteJIJTYrI7FCu6mFb9HbUQ2SR35O06kvZiz3zwQI9RzJO7e6qL0f0Hm6Uk5D86xzQLzTmPObf_SEzpeQ8MLM8kxYb22qRFPqDOIW5fi7J_DrMP1sGiwgCJbfTB-M5xymU3yr0DpWbLd5LhdEQed_9xzu-ZD6wQppN62ouRPuhc',
      'isDirector': false,
    },
    {
      'name': 'Rebecca F.',
      'role': 'Lady Jessica',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAAiaQ1_oZRa02ZvzYf74tA3eiHUV2UoEncPSCnwbKA17agiJue7yDykTZJY7UNAkuFIdTvb-Wx15C5ZsiVwnUlDCvMM3cgFUj-SpENy_CR2qEbAVtAqMqD30DnN2zjBIUd8mpybXulCqDjcksbYaTcAamkVDWI1fhpps9JfsOBW1yStYfNivC8-OCagm8zDx8dmxFPHhnw3q2g8XzBxeqJLfhmSfUNlr3-n5OVjmxl7-Ids4o44Bb1xpqISiQuIrIblF43r9fDbeE',
      'isDirector': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Diễn viên & Đoàn làm phim',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _cast.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final member = _cast[index];
              return Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(member['image']),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 80,
                    child: Text(
                      member['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    member['role'],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
