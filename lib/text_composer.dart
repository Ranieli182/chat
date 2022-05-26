import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  Function({String text, File imgFile}) sendMessage;

  //const TextComposer({Key? key}) : super(key: key);

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  
  final TextEditingController _controller = TextEditingController();
  
  bool _isComposing = false;

  void _reset(){
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              final XFile? imgFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 0);
              final File file=File(imgFile!.path);
              if (imgFile == null) return;
              widget.sendMessage(imgFile: file);
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: 'Enviar uma Mensagem'),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _reset();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? () {
              widget.sendMessage(text: _controller.text);
              _reset();
            } : null,
          ),
        ],
      ),
    );
  }
}
