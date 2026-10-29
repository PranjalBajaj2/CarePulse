import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../data/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final IChatRepository _chatRepo = Get.find<IChatRepository>();

  final RxList<ChatConversationModel> conversations = <ChatConversationModel>[].obs;
  final RxList<ChatMessageModel> activeMessages = <ChatMessageModel>[].obs;
  final Rx<ChatConversationModel?> selectedConversation = Rx<ChatConversationModel?>(null);

  final TextEditingController messageInputController = TextEditingController();
  final RxBool isLoading = true.obs;
  final RxBool isSending = false.obs;

  final List<String> quickReplies = [
    'My symptoms have significantly improved.',
    'I took my prescribed medication on time.',
    'Could you clarify my dosage instructions?',
    'Here are my latest blood pressure vitals: 118/76 mmHg.',
  ];

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final list = await _chatRepo.getConversations();
      conversations.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openConversation(ChatConversationModel conv) async {
    selectedConversation.value = conv;
    final msgs = await _chatRepo.getMessages(conv.id);
    activeMessages.assignAll(msgs);

    // Clear unread count locally
    final index = conversations.indexWhere((c) => c.id == conv.id);
    if (index != -1) {
      conversations[index] = conversations[index].copyWith(unreadCount: 0);
    }
  }

  Future<void> sendMessage([String? prefilledText]) async {
    final text = prefilledText ?? messageInputController.text.trim();
    if (text.isEmpty || selectedConversation.value == null) return;

    final convId = selectedConversation.value!.id;
    messageInputController.clear();

    // Append user message immediately
    final userMsg = await _chatRepo.sendMessage(convId, text);
    activeMessages.add(userMsg);
    await loadConversations();

    // Trigger clinician automated response after 1 second
    _chatRepo.simulateDoctorReply(convId).then((replyMsg) {
      if (selectedConversation.value?.id == convId) {
        activeMessages.add(replyMsg);
      }
      loadConversations();
    });
  }

  @override
  void onClose() {
    messageInputController.dispose();
    super.onClose();
  }
}
