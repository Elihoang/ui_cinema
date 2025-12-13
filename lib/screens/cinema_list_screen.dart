import 'package:flutter/material.dart';
import '../widgets/cinemalist/cinema_header.dart';
import '../widgets/cinemalist/cinema_search_bar.dart';
import '../widgets/cinemalist/cinema_filter_chips.dart';
import '../widgets/cinemalist/cinema_card.dart';
import '../models/cinema.dart';

class CinemaListScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;
  const CinemaListScreen({super.key, this.onNavigateToHome});

  @override
  State<CinemaListScreen> createState() => _CinemaListScreenState();
}

class _CinemaListScreenState extends State<CinemaListScreen> {
  final List<Map<String, dynamic>> cinemas = [
    {
      'cinema': Cinema(
        name: 'CGV Vincom Center',
        address: '72 Lê Thánh Tôn, Q.1, TP. HCM',
        distance: 1.2,
        formats: [],
      ),
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDMv2wcEcNRbsVyr2H_oTciBRD4_SJtObz-1gvXoKEG5xoxiKTfkE3QsU2qK9pY39XKjS15HcJ0H7ea8m78EooB5ZfuV798UWaccV3JFdddI5r6c8ksEiIw9fu2eH8k8kCXQg9ODLMrEY1NPlQ8Lz9pPrABoG_rN8IRC2NaP7T3a_CLowqvhGyNIUeDX0j_rj9fEgZhWvZRY7eg-7Odvc18XnlP6OmvYz3cPn_LKcr7yN83VUfYvyX0d6K8uF7gKtZI4GSAGT1n7wo',
      'rating': 4.8,
      'isAvailable': true,
      'movies': [
        {
          'title': 'Dune: Part Two',
          'image':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDR4y_5z7ATLmK-SgbvWX2zeBebOE0zU-m2lIIsOt-gzmd9XQ2QyTcxqMRbL7UJwSmLeZpyN-snmFUQlFZ5ptpndnrYo15iD57l17B57HQ0RtD-0aCij5VCd0f_bk32LiISQeCAgwwDTJSNviJOGmy_BdwPH5DZLPdKOlV1f4ZPiQLTCTUVgCSL7DoQSdSpJZdVu2JDo62wSMtg6iE_J38uB9G8dgNhOe2lEMwYui6JGr-bmfxCPY-vORHXmmIjYyqA7Fu813WTdAE',
        },
        {
          'title': 'Civil War',
          'image':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDY3cXFrs7GDJL7-e6KeWUaikKKiiQNTh-Kgei-LUmfovFwPh2T6nAcxbXPuF_AJ56q2LXd8Rgrf2OfLa23u5Rs8cgNHVElkmXCpAq48MBD_Tec49UphpeRw1XUOtvl1d0-5YoiND0X1GuPoYmIvzjFlE0N0Ahp18HqHHrohgelHawPmpw7RsOVIcXj_ZEFnSfskJQ0oGk_4EU24Brmu1Wc4KISXXQU6zeipxRDrKydfDhR3OAWj-WY88bC8uNMnT9a37yBzVaZims',
        },
        {
          'title': 'Kung Fu Panda 4',
          'image':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDSOdYo7NgyfpTMAgs42iX1JQDO42Xpmuyw4wzxyBKUyIcV_QbdSuRgAfSgGPg25AqqATmOkNGKQs8WzgemXq7Vr8zuEdkFaKc2OUHXgevDqA_1Pl_23YLRJ8nxDfPNl8Q6Bjfs5Z4-HipP0BrrL7xVVIyk-aqRtUxWX_Fh-4H95-7NX8mOoXVUCEoqL3tDBHMKlYNu6OirDSCi0LLQXEuqGN4m2AdkdX0zaOrGIZ95c2xpS4zjrFEuCdKrNlWWFj59MfpPzq9gywM',
        },
        {
          'title': 'Exhuma',
          'image':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDNfAp2jTykFDvbU3mgnsHzfTlF7rJty4SvM_WlNIe5uZ7Pmi4N6tONGJrqJf7lSO1NFEQrUxekw-0dF3r0zpXmBXtH1lF5Bg5QVUD1NMMoLojr9bCdP7B_w8moxpafwvfp1Lb90XFs1UWarOftn_vII1-FBCoOJcfuV_8ZBtqxoOWUf5sLAM7Tr8OacN5XWeWW00wyc9_NwOQap4TNvMlM1tS7BDKLDwxCRenfH6uey5f_MybWXdhpUJ4wQMaCMcHS3k7R__GrPvg',
        },
      ],
    },
    {
      'cinema': Cinema(
        name: 'Lotte Cinema Nowzone',
        address: '235 Nguyễn Văn Cừ, Q.1, TP. HCM',
        distance: 2.4,
        formats: [],
      ),
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDW8ZQZV6KNK8SV2vM7IhIQeipK4AOFUGWpVglI5D2zvV3ujhqcxzYhKdy7550m57cBSn4cc7S40vcIeHkWJyxWtZVccM6flNt1CvtWNOgjrOnYgBd0VK12Vlx3AU-oFgWtea35_WsJAXM7_oPDfgX661OzOs6GBuOXzfDIvs9t2_z8hYsjkjqGvb-pZ8VqomLjaTUAPyAs1Zk3P_VS4WChIbOdGiPlZJucrAXRaltw4rJJYMVvVh2zEdVEIOZawvRd4JA-484sIJs',
      'rating': 4.5,
      'isAvailable': true,
      'movies': [
        {
          'title': 'Dune: Part Two',
          'image':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDR4y_5z7ATLmK-SgbvWX2zeBebOE0zU-m2lIIsOt-gzmd9XQ2QyTcxqMRbL7UJwSmLeZpyN-snmFUQlFZ5ptpndnrYo15iD57l17B57HQ0RtD-0aCij5VCd0f_bk32LiISQeCAgwwDTJSNviJOGmy_BdwPH5DZLPdKOlV1f4ZPiQLTCTUVgCSL7DoQSdSpJZdVu2JDo62wSMtg6iE_J38uB9G8dgNhOe2lEMwYui6JGr-bmfxCPY-vORHXmmIjYyqA7Fu813WTdAE',
        },
      ],
    },
    {
      'cinema': Cinema(
        name: 'Galaxy Nguyễn Du',
        address: '116 Nguyễn Du, Q.1, TP. HCM',
        distance: 3.1,
        formats: [],
      ),
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCa9gBUxHnllZE_Mobs315A-gBceyv6CljRBqkI39tGdgRyy2jQKm6whY3f26MEe5IErq_IDZQOGRvy9ktwptyha0qUEq9xDC4-pKuvkLBEocpTl2g9qN5QkRR0qnTnzn9IpwPkubPpKKfMARJidAmKr-TcEbL7N-l8yb2lBV5KibQaJf3INacKNrsW7onPhFTzh7wVUMP8YtckNdmUVQ-wKax2IkYOowXSrnmGTUpChkFlW0RFL8kmWPW1uCIp_5Tg4V3UH7-eJKw',
      'rating': 4.2,
      'isAvailable': true,
      'movies': [
        {
          'title': 'Civil War',
          'image':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDY3cXFrs7GDJL7-e6KeWUaikKKiiQNTh-Kgei-LUmfovFwPh2T6nAcxbXPuF_AJ56q2LXd8Rgrf2OfLa23u5Rs8cgNHVElkmXCpAq48MBD_Tec49UphpeRw1XUOtvl1d0-5YoiND0X1GuPoYmIvzjFlE0N0Ahp18HqHHrohgelHawPmpw7RsOVIcXj_ZEFnSfskJQ0oGk_4EU24Brmu1Wc4KISXXQU6zeipxRDrKydfDhR3OAWj-WY88bC8uNMnT9a37yBzVaZims',
        },
      ],
    },
    {
      'cinema': Cinema(
        name: 'BHD Star Bitexco',
        address: 'Lầu 3, Bitexco Icon 68, Q.1, TP. HCM',
        distance: 3.5,
        formats: [],
      ),
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDy4tq6UrmCzEfOmCG4Wts8zNlzuDBHD6jiWz58owjlTJFc1E3DoKKshwn_pLEN5IHxrVcQEhrFl8pHeqFBKfKq8O8bPMPHCcH8msbOj1XAGv_MW2MByWJAM9xX4E_xF9L-2WeJruo03Sgn5yu7Nwk6tR20iouaYjFjMqjbck2eUX0KK-tUTh-TJa3kKlnU9OmJgUZ0ca2vrze7S3oRF3s9cUiZIc6FdmA9es50szFQWnfsOqg53x39LRbeZo35M3BQgH9l3f7P3d8',
      'rating': 0.0,
      'isAvailable': false,
      'movies': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      body: Column(
        children: [
          CinemaHeader(
            onBackPressed: () => Navigator.pop(context),
            onMapPressed: () {},
            onNavigateToHome: widget.onNavigateToHome,
          ),
          CinemaSearchBar(onSearchChanged: (value) {}),
          CinemaFilterChips(onFilterSelected: (index) {}),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: cinemas.length,
              itemBuilder: (context, index) {
                final cinemaData = cinemas[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CinemaCard(
                    cinema: cinemaData['cinema'],
                    imageUrl: cinemaData['imageUrl'],
                    rating: cinemaData['rating'],
                    moviesNowShowing: List<Map<String, String>>.from(
                      cinemaData['movies'] ?? [],
                    ),
                    isAvailable: cinemaData['isAvailable'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
