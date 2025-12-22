import 'package:flutter/material.dart';

import '../models/eticket.dart';
import '../services/ticket_service.dart';
import '../widgets/my_ticket/history_tab.dart';
import '../widgets/my_ticket/upcoming_tab.dart';

const kPrimary = Color(0xFFEC1337);
const kSurfaceDark = Color(0xFF33191E);
const kSurfaceBorder = Color(0xFF482329);
const kTextSecondary = Color(0xFFC9929B);

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  int tabIndex = 0;

  List<ETicket> allTickets = [];
  List<ETicket> upcoming = [];
  List<ETicket> history = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final tickets = await TicketService.fetchMyTickets();

      setState(() {
        allTickets = tickets;
        upcoming = tickets
            .where((t) => t.status == ETicketStatus.upcoming)
            .toList();
        history = tickets
            .where((t) => t.status == ETicketStatus.history)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Không thể tải vé\n$e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Tiêu đề
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 44, 16, 8),
              child: Text(
                'Vé của tôi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Tab switcher: Sắp tới / Lịch sử
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: kSurfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kSurfaceBorder),
                ),
                child: Row(
                  children: [
                    _tabItem('Sắp tới', 0),
                    _tabItem('Lịch sử', 1),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nội dung chính: Loading / Error / Tabs
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: kPrimary,
                        strokeWidth: 3,
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wifi_off,
                                  size: 64,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: _loadTickets,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Thử lại'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : upcoming.isEmpty && history.isEmpty
                          ? const Center(
                              child: Text(
                                'Bạn chưa có vé nào',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          : IndexedStack(
                              index: tabIndex,
                              children: [
                                // Tab Sắp tới
                                UpcomingTab(
                                  tickets: upcoming,
                                  recentHistory: history.take(3).toList(),
                                ),
                                // Tab Lịch sử
                                HistoryTab(tickets: history),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final bool active = tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: active ? kPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: active ? Colors.white : kTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}