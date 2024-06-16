import 'package:emplanner/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:o3d/o3d.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<ProfileScreen> {
//   O3DController o3dController = O3DController();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       // child: O3D.asset(
//       //   src: 'assets/model.glb',
//       //   controller: o3dController,
//       //   autoPlay: true,
//       // ),
//       // child: Text('Settings'),
//     );
//   }
// }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfileScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  final FocusNode _textFieldFocus = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyCiqj3m0flnUtvdiJkYDVSe8AhRw2Nog4s',
    );
    _chatSession = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatSession.history.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                final Content content = _chatSession.history.toList()[index];
                final text = content.parts
                    .whereType<TextPart>()
                    .map<String>((e) => e.text)
                    .join('')
                    .replaceFirst(
                        "Bạn là AI hỗ trợ học tập của Emplanner ứng dụng hỗ trợ lên kế hoạch học tập, tên bạn là EmMentor, hãy trả lời câu hỏi của người dùng sau: ",
                        "");
                return MessageWidget(
                  text: text,
                  isFromUser: content.role == 'user',
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _textFieldFocus,
                    decoration: textFieldDecoration(),
                    controller: _textEditingController,
                    onSubmitted: _sendChatMessage,
                  ),
                ),
                const SizedBox(height: 15),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _sendChatMessage(_textEditingController.text);
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.amber,
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration textFieldDecoration() {
    return const InputDecoration(
      contentPadding: EdgeInsets.all(15),
      hintText: 'Enter a promt...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Colors.amber,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(color: Colors.amber),
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    String messageFinal =
        'Bạn là AI hỗ trợ học tập của Emplanner ứng dụng hỗ trợ lên kế hoạch học tập, tên bạn là EmMentor, hãy trả lời câu hỏi của người dùng sau: $message';
    setState(() {
      _loading = true;
    });

    try {
      final response = await _chatSession.sendMessage(
        Content.text(messageFinal),
      );
      final text = response.text;
      if (text == null) {
        _showError('No response from API');
        return;
      } else {
        setState(() {
          _loading = true;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textEditingController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 750),
              curve: Curves.easeOutCirc,
            ));
  }

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sthg Wrong'),
            content: SingleChildScrollView(
              child: SelectableText(message),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        });
  }
}
