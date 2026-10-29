import '../models/chat_message_model.dart';
import '../mock_data/mock_healthcare_data.dart';

abstract class IChatRepository {
  Future<List<ChatConversationModel>> getConversations();
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<ChatMessageModel> sendMessage(String conversationId, String messageText);
  Future<ChatMessageModel> simulateDoctorReply(String conversationId);
}

class ChatRepository implements IChatRepository {
  final List<ChatConversationModel> _conversations = List.from(MockHealthcareData.conversations);
  final Map<String, List<ChatMessageModel>> _messages = Map.from(MockHealthcareData.chatMessages);

  @override
  Future<List<ChatConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_conversations);
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _messages[conversationId] ?? [];
  }

  @override
  Future<ChatMessageModel> sendMessage(String conversationId, String messageText) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final newMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user_001',
      senderName: 'Pranjal Bajaj',
      message: messageText,
      timestamp: DateTime.now(),
      isDoctor: false,
    );

    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = [];
    }
    _messages[conversationId]!.add(newMsg);

    // Update conversation last message
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
        lastMessage: messageText,
        lastMessageTime: DateTime.now(),
      );
    }

    return newMsg;
  }

  @override
  Future<ChatMessageModel> simulateDoctorReply(String conversationId) async {
    await Future.delayed(const Duration(seconds: 1));
    final doctorMsg = ChatMessageModel(
      id: 'doc_reply_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'doctor',
      senderName: 'Attending Clinician',
      message: 'Thank you for your update. I have reviewed your notes and your clinical progress looks optimal. Please continue taking your prescribed medications on schedule.',
      timestamp: DateTime.now(),
      isDoctor: true,
    );

    if (_messages.containsKey(conversationId)) {
      _messages[conversationId]!.add(doctorMsg);
    }

    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
        lastMessage: doctorMsg.message,
        lastMessageTime: DateTime.now(),
      );
    }

    return doctorMsg;
  }
}
