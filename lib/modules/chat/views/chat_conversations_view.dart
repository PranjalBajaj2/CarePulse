import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../controllers/chat_controller.dart';
import 'chat_detail_view.dart';

class ChatConversationsView extends GetView<ChatController> {
  const ChatConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Clinical Messages'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Security disclaimer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primaryLight,
            child: const Row(
              children: [
                Icon(Icons.lock_rounded, size: 14, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Direct doctor communications are HIPAA-encrypted & private.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),

          // Conversation threads
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.conversations.isEmpty) {
                return const EmptyState(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'No Active Chats',
                  description: 'Once you book an appointment, your direct doctor chat will appear here.',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.conversations.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 76),
                itemBuilder: (context, index) {
                  final conv = controller.conversations[index];
                  final timeFormat = DateFormat('h:mm a');
                  final timeStr = timeFormat.format(conv.lastMessageTime);

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            conv.doctorName.split(' ').length > 1
                                ? '${conv.doctorName.split(' ')[0][0]}${conv.doctorName.split(' ')[1][0]}'
                                : 'Dr',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                          ),
                        ),
                        if (conv.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conv.doctorName,
                            style: AppTextStyles.h3.copyWith(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(timeStr, style: AppTextStyles.caption),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          conv.doctorSpecialty,
                          style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                conv.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: conv.unreadCount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                                  fontWeight: conv.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                            if (conv.unreadCount > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${conv.unreadCount}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      controller.openConversation(conv);
                      Get.to(() => const ChatDetailView());
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
