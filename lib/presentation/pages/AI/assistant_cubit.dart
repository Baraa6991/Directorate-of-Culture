import 'package:bloc/bloc.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:directorateofculture/presentation/pages/AI/assistant_state.dart';
import 'package:directorateofculture/presentation/pages/AI/chat_message_model.dart';


class AssistantCubit extends Cubit<AssistantState> {
  final MiscRepository repository;
  final List<ChatMessageModel> _messages = [];

  AssistantCubit({required this.repository}) : super(AssistantInitial()) {
    // رسالة ترحيبية أولى تظهر للمستخدم عند فتح الشات
    _messages.add(
      ChatMessageModel(
        role: 'assistant',
        content: 'أهلاً بك! أنا مساعدك في مديرية الثقافة. اسألني عن الفعاليات '
            'أو المراكز الثقافية، أو قل لي مثلاً "خطط لي نشاط بعد الظهر" '
            'وراح أرتب لك برنامج.',
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessageModel(role: 'user', content: text.trim()));
    emit(AssistantLoading(List.of(_messages)));

    try {
      final history = _messages.where((m) => m != _messages.last).toList();

      final reply = await repository.askAssistant(
        message: text.trim(),
        history: history,
      );

      _messages.add(ChatMessageModel(
        role: 'assistant',
        content: reply.message,
        plan: reply.plan,
      ));
      emit(AssistantLoaded(List.of(_messages)));
    } catch (e) {
      emit(AssistantError(List.of(_messages), 'تعذر الاتصال بالمساعد، تحقق من الإنترنت.'));
    }
  }
}
