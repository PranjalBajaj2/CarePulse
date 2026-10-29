import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../appointments/views/appointments_list_view.dart';
import '../../chat/views/chat_conversations_view.dart';
import '../../doctors/views/doctor_list_view.dart';
import '../../home/views/home_view.dart';
import '../../prescriptions/views/prescriptions_list_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/nav_controller.dart';

class MainNavigationView extends GetView<NavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const DoctorListView(),
      const AppointmentsListView(),
      const PrescriptionsListView(),
      const ChatConversationsView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          )),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => Get.to(() => const ProfileView()),
        backgroundColor: AppColors.surface,
        elevation: 3,
        tooltip: 'My Medical Profile',
        child: const Icon(Icons.account_circle_outlined, color: AppColors.primary, size: 24),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeTab,
          backgroundColor: AppColors.surface,
          elevation: 8,
          indicatorColor: AppColors.primaryLight,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_search_outlined),
              selectedIcon: Icon(Icons.person_search_rounded, color: AppColors.primary),
              label: 'Doctors',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              label: 'Visits',
            ),
            NavigationDestination(
              icon: Icon(Icons.medication_outlined),
              selectedIcon: Icon(Icons.medication_rounded, color: AppColors.primary),
              label: 'Rx Refill',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
              label: 'Messages',
            ),
          ],
        ),
      ),
    );
  }
}
