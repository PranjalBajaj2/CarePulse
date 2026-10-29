import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/chat_controller.dart';

class ChatDetailView extends GetView<ChatController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final conv = controller.selectedConversation.value;
    if (conv == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const Center(child: Text('No conversation selected')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                conv.doctorName.split(' ').length > 1
                    ? '${conv.doctorName.split(' ')[0][0]}${conv.doctorName.split(' ')[1][0]}'
                    : 'Dr',
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark, fontSize: 13),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(conv.doctorName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(
                    conv.isOnline ? 'Online • ${conv.doctorSpecialty}' : conv.doctorSpecialty,
                    style: TextStyle(
                      fontSize: 11,
                      color: conv.isOnline ? AppColors.success : AppColors.textSecondary,
                      fontWeight: conv.isOnline ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_rounded, color: AppColors.primary),
            onPressed: () {
              Get.snackbar(
                'Video Telehealth Call',
                'Initiating secure WebRTC video room with ${conv.doctorName}...',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.teal.shade800,
                colorText: Colors.white,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Security Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: AppColors.surfaceMuted,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded, size: 12, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Text(
                  'Messages are end-to-end encrypted (HIPAA / GDPR compliant)',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // Message Bubbles List
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: controller.activeMessages.length,
                itemBuilder: (context, index) {
                  final msg = controller.activeMessages[index];
                  final isDoctor = msg.isDoctor;
                  final timeStr = DateFormat('h:mm a').format(msg.timestamp);

                  return Align(
                    alignment: isDoctor ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDoctor ? AppColors.surface : AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isDoctor ? const Radius.circular(4) : const Radius.circular(16),
                          bottomRight: isDoctor ? const Radius.circular(16) : const Radius.circular(4),
                        ),
                        border: isDoctor ? Border.all(color: AppColors.border) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: isDoctor ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg.message,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: isDoctor ? AppColors.textPrimary : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                timeStr,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDoctor ? AppColors.textMuted : Colors.white70,
                                ),
                              ),
                              if (!isDoctor) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.done_all_rounded, size: 14, color: Colors.white70),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Quick Replies Carousel
          Container(
            height: 38,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.quickReplies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final reply = controller.quickReplies[index];
                return ActionChip(
                  label: Text(reply, style: const TextStyle(fontSize: 12, color: AppColors.primaryDark)),
                  backgroundColor: AppColors.primaryLight,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onPressed: () => controller.sendMessage(reply),
                );
              },
            ),
          ),

          // Message Input Field Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: AppColors.surface,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: AppColors.textSecondary),
                    onPressed: () {
                      Get.snackbar(
                        'Attach Clinical Document',
                        'Upload lab report, allergy photo, or prior prescription.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.messageInputController,
                      decoration: InputDecoration(
                        hintText: 'Type clinical inquiry...',
                        filled: true,
                        fillColor: AppColors.surfaceMuted,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => controller.sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () => controller.sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
