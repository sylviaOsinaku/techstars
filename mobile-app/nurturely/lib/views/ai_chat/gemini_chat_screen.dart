import 'dart:async';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:techstars_hackathon/common/colors.dart';
import 'package:techstars_hackathon/views/ai_chat/widgets/animated_markdown_text.dart';
import 'package:techstars_hackathon/views/ai_chat/widgets/example_question.dart';

import '../../core/data/handle_ai_chat_store_data.dart';
import '../../core/services/gemini_services.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> with AutomaticKeepAliveClientMixin{
  late final ValueNotifier<List<types.TextMessage>> _textMessage;
  final types.User _user = types.User(id: 'defaultUserId', role: types.Role.user, firstName: "User");
  final types.User _modelUser = types.User(id: 'model', role: types.Role.agent, firstName: "Nurturely assistant");
  final HandleAiChatStoreData handleAiChatStoreData = HandleAiChatStoreData("defaultUserId");
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _textMessage = ValueNotifier(<types.TextMessage>[]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTextMessages();
    });
  }

  Future<void> loadTextMessages() async {
    final List<Content> chatContents = await handleAiChatStoreData.getUserChatStore();

    if (chatContents.length == _textMessage.value.length) {
      bool listsAreSame = true;
      for (int i = 0; i < chatContents.length; i++) {
        final Content content = chatContents[i];
        final String newText = (content.parts.first as TextPart?)?.text ?? "";
        final types.TextMessage existingMessage = _textMessage.value[i];

        if (existingMessage.text != newText) {
          listsAreSame = false;
          break;
        }
      }
      if (listsAreSame) return; // No changes found; exit
    }

    List<types.TextMessage> tempList = <types.TextMessage>[];
    // Rebuild the message list if there's any difference.
    for (int i = 0; i < chatContents.length; i++) {
      final String text = (chatContents[i].parts.first as TextPart?)?.text ?? "";
      tempList.add(types.TextMessage(author: chatContents[i].role == "user" ? _user : _modelUser, id: "message_$i", text: text));
    }
    _textMessage.value = tempList;
    _textMessage.value = List.from(_textMessage.value);
  }

  Stream sendPromptToModel(Content content) async* {
    final List<Content> getUserChatContents = await handleAiChatStoreData.getUserChatStore();
    // log("getUserChatContents result: $getUserChatContents");
    final Stream rawResult = GeminiServices.sendPrompt(content: [...getUserChatContents, content]);
    yield* rawResult;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black.withValues(alpha: 0.9),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            SizedBox(
              height: kToolbarHeight + 12,
              child: Row(
                children: [
                  BackButton(),
                  Expanded(
                    child: Center(
                      child: AnimatedTextKit(
                        key: UniqueKey(),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Nurturely Assistant",
                            textStyle: TextStyle(color: TechStarsColors.primaryDark, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                     showDialog(context: context, builder: (context){
                       return AlertDialog(
                         title: CustomText("Clear Chat?", fontSize: 18, fontWeight: FontWeight.bold,),
                         content: CustomText("Are you sure you want to clear your chat?"),
                         actions: [
                           CustomTextButton(
                             label: "Cancel",
                             onClick: () => Navigator.of(context).pop(),
                           ),
                           CustomTextButton(
                             backgroundColor: TechStarsColors.lighterPink,
                             label: "Delete",
                             onClick: () async{
                               Navigator.of(context).pop();
                               LoadingDialog.showLoadingDialog(context, msg: "Deleting chat");
                               handleAiChatStoreData.deleteUserAllChatStore();
                               _textMessage.value.clear();
                               _textMessage.value = List.from(_textMessage.value);
                               LoadingDialog.hideLoadingDialog(context);

                             },
                           )
                         ],
                       );
                     });
                    },
                    icon: Icon(Iconsax.trash),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _textMessage,
                builder: (context, textMessageValue, child) {
                  return Chat(
                    textMessageBuilder: (textMessage, {messageWidth = 10, showName = true}) {
                      return Container(
                        color: textMessage.author.role == types.Role.user ? TechStarsColors.lighterPink : TechStarsColors.lightGray,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: MarkdownBody(
                          data: textMessage.text,
                          styleSheet: MarkdownStyleSheet(p: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                        ),
                      );
                    },

                    emptyState: _textMessage.value.isEmpty ? SingleChildScrollView(
                      child: FutureBuilder(
                        future: _buildEmptyPageWidget(handleAiChatStoreData, (question) => askModel(types.PartialText(text: question))),
                        builder: (context, snapshot) {
                          log("snapshot: ${snapshot.data}");
                          if (snapshot.hasData && snapshot.data != null) return snapshot.data!;
                          if (snapshot.data == null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: kToolbarHeight + 24),
                                const SizedBox(height: 64),
                                SvgPicture.asset("assets/svgs/nurturely_logo.svg", width: 200, height: 200),
                                const SizedBox(height: 48),
                                CustomText(
                                  "Start chatting with Nurturely AI",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: TechStarsColors.primary,
                                ),
                              ],
                            );
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: kToolbarHeight + 80),
                              SizedBox.square(
                                dimension: 48,
                                child: CircularProgressIndicator(color: TechStarsColors.primary, strokeCap: StrokeCap.round),
                              ),
                              const SizedBox(height: 24),
                              CustomText(
                                "Loading Nurturely Assistant",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: TechStarsColors.primary,
                              ),
                            ],
                          );
                        },
                      ),
                    ) : null,
                    typingIndicatorOptions: TypingIndicatorOptions(
                      typingUsers: isTyping ? [_modelUser.copyWith(id: "model_${DateTime.now().millisecondsSinceEpoch}")] : [],
                    ),
                    scrollPhysics: BouncingScrollPhysics(),
                    messages: textMessageValue.reversed.toList(),

                    onSendPressed: (content) {
                      askModel(content);
                    },
                    user: _user,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  askModel(types.PartialText partialText) async {
    if (isTyping) return;
    setState(() => isTyping = true);
    // User's message
    final Content userContent = Content("user", [TextPart(partialText.text)]);

    // Update the user's message in the ui
    _textMessage.value.add(
      types.TextMessage(id: "message_${DateTime.now().millisecondsSinceEpoch.toString()}", author: _user, text: partialText.text),
    );
    handleAiChatStoreData.addContentToChatStore(userContent); // store the user message immediately

    // Prepare a buffer to store the AI's response.
    final StringBuffer modelResponseString = StringBuffer();
    final modelCurrentId = "message_${DateTime.now().millisecondsSinceEpoch.toString()}";

    // Consulting Model text
    _textMessage.value.add(types.TextMessage(id: modelCurrentId, author: _modelUser, text: "Consulting model..."));

    final int aiMessageIndex = _textMessage.value.lastIndexWhere((element) => (element.id == modelCurrentId));

    // Listen to the streaming AI response.
    final StreamSubscription modelResponseSub = sendPromptToModel(userContent).listen((response) {
      log("listening: ${modelResponseString.toString()}");
      final String? newText = response.text;
      if (newText != null) {
        // Append new text to the buffer.
        modelResponseString.write(newText);

        // Create a new ChatMessage with the updated text.
        final types.TextMessage updatedMessage = types.TextMessage(
          id: modelCurrentId,
          author: _modelUser,
          text: modelResponseString.toString(),
        );


        _textMessage.value[aiMessageIndex] = updatedMessage;
        _textMessage.value = List.from(_textMessage.value);
      }
    });

    Timer timeoutTimer = Timer(Duration(seconds: 20), () async {
      await modelResponseSub.cancel();
      setState(() => isTyping = false);
      loadTextMessages();
    });

    // Cancel the timer on error.
    modelResponseSub.onError((error, stackTrace) async {
      if (timeoutTimer.isActive) timeoutTimer.cancel();
      await modelResponseSub.cancel();
      setState(() => isTyping = false);
      loadTextMessages();
    });

    // Cancel the timer on done.
    modelResponseSub.onDone(() async {
      if (timeoutTimer.isActive) timeoutTimer.cancel();
      handleAiChatStoreData.addContentToChatStore(
          Content(_modelUser.id, [TextPart(modelResponseString.toString())])
      );
      await modelResponseSub.cancel();
      setState(() => isTyping = false);
      loadTextMessages();
    });
  }

  @override
  bool get wantKeepAlive => true;
}



Future<Widget> _buildEmptyPageWidget(HandleAiChatStoreData handleAiChatStoreData, void Function(String) onTap) async {
  final List<Content> content = (await handleAiChatStoreData.getUserChatStore()).reversed.toList();
  buildExampleQuestion(String question) {
    return ExampleQuestion(question: question, onTap: (question) => onTap(question));
  }


  // Fetch multiple suggestions in parallel
  List<Future<String?>> futures = List.generate(2, (_) => GeminiServices.generateSuggestion(content: content));
  List<String?> outputs = await Future.wait(futures);
  List<ExampleQuestion> exampleQuestions = outputs
      .where((output) => output != null && output.trim().isNotEmpty) // Remove null/empty responses
      .map((output) => buildExampleQuestion(output!.trim()))
      .toList();


  if (exampleQuestions.isEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: kToolbarHeight),
          CustomText("Nurturely AI", fontSize: 32, fontWeight: FontWeight.w600),
          const SizedBox(height: 75),
          SvgPicture.asset("assets/svgs/nurturely_logo.svg", width: 200, height: 200,),
          const SizedBox(height: 48),
          CustomText(
            "Assistant Limit exceeded or try connecting to a network",
            fontWeight: FontWeight.bold,
            fontSize: 18,
            textAlign: TextAlign.center,
            color: TechStarsColors.primary,
          ),
        ],
      ),
    );
  }

  return Column(
    children: [
      const SizedBox(height: kToolbarHeight),
      CustomText("Nurturely AI", fontSize: 32, fontWeight: FontWeight.w600),
      const SizedBox(height: 64),
      ...exampleQuestions,
    ],
  );
}
