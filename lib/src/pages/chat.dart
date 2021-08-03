// @dart=2.9

import 'dart:async';
import 'package:covid_bot/src/pages/chat_message.dart';
import 'package:covid_bot/src/settings_user/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

import 'package:text_to_speech/text_to_speech.dart';

// TODO import Dialogflow
import 'package:dialogflow_grpc/v2beta1.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';

class Chat extends StatefulWidget {

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final prefs = new PreferenciasUsuario();

  final TextToSpeech tts = TextToSpeech();


  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  bool _isRecording = false;

  RecorderStream _recorder = RecorderStream();
  StreamSubscription _recorderStatus;
  StreamSubscription<List<int>> _audioStreamSubscription;
  BehaviorSubject<List<int>> _audioStream;

  // TODO DialogflowGrpc class instance
  DialogflowGrpcV2Beta1 dialogflow;

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus?.cancel();
    _audioStreamSubscription?.cancel();
    super.dispose();
  }

  // Los mensajes de la plataforma son asíncronos, por lo que los inicializamos en un método asíncrono.
  // Inicializa el dialogflow
  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([_recorder.initialize()]);

    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/credentials.json'))}');
    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
  }

  void stopStream() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
  }

  //Interaccion del mensaje con el bot
  void manejadorEnvio(text) async {
    print(text);
    _textController.clear();
    String nombre = (prefs.nombreUsuario.length>0)?prefs.nombreUsuario:'You';
    //print('nombre : ${nombre.length}');
    //print('nombre : ${nombre}');
    //TODO Dialogflow Code
    ChatMessage message = ChatMessage(
      text: text,
      name: nombre,
      type: true,
    );

    setState(() {
      _messages.insert(0, message);
    });

    String respDialogFLow = "";
    try {
      DetectIntentResponse data = await dialogflow.detectIntent(text, 'es-ES');
      respDialogFLow = data.queryResult.fulfillmentText;
      print(respDialogFLow);
    } catch (e) {
      print(e);
    }

    if (respDialogFLow.isNotEmpty) {
      ChatMessage botMessage = ChatMessage(
        text: respDialogFLow,
        name: "Bot :D",
        type: false,
      );
      tts.setLanguage('es-ES');
      tts.speak(respDialogFLow);
      setState(() {
        _messages.insert(0, botMessage);
      });
    }
  }

  void handleStream() async {
    _recorder.start();

    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((data) {
      print(data);
      _audioStream.add(data);
    });

    // TODO Create SpeechContexts
    var biasList = SpeechContextV2Beta1(phrases: [
      'Dialogflow CX',
      'Dialogflow Essentials',
      'Action Builder',
      'HIPAA'
    ], boost: 20.0);

    // TODO Create and audio InputConfig
    var config = InputConfigV2beta1(
        encoding: 'AUDIO_ENCODING_LINEAR_16',
        languageCode: 'es-ES',
        sampleRateHertz: 16000,
        singleUtterance: false,
        speechContexts: [biasList]);

    // TODO Make the streamingDetectIntent call, with the InputConfig and the audioStream
    final responseStream =
    dialogflow.streamingDetectIntent(config, _audioStream);

    // TODO Get the transcript and detectedIntent and show on screen
    // Get the transcript and detectedIntent and show on screen
    responseStream.listen((data) {
      setState(() {
        String transcript = data.recognitionResult.transcript;
        /*String queryText = data.queryResult.queryText;
        String fulfillmentText = data.queryResult.fulfillmentText;

        String nombre = (prefs.nombreUsuario.length>0)?prefs.nombreUsuario:'You';
        //print('nombre : $nombre');
        if (fulfillmentText.isNotEmpty) {
          ChatMessage message = new ChatMessage(
            text: queryText,
            name: nombre,
            type: true,
          );

          ChatMessage botMessage = new ChatMessage(
            text: fulfillmentText,
            name: "Bot :D",
            type: false,
          );
          tts.setLanguage('es-ES');
          tts.speak(fulfillmentText);

          _messages.insert(0, message);
          _textController.clear();
          _messages.insert(0, botMessage);
        }*/
        if (transcript.isNotEmpty) {
          _textController.text = transcript;
        }
      });
    }, onError: (e) {
      print(e);
    }, onDone: () {
      //print('done');
    });
  }

  // Chat
  //
  //------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          )),
      Divider(height: 1.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: manejadorEnvio,
                      decoration:
                      InputDecoration.collapsed(hintText: "Ingrese un mensaje"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      icon: Icon(Icons.send, color: prefs.genero==1?Colors.blue:Colors.amber,),
                      onPressed: () => manejadorEnvio(_textController.text),
                    ),
                  ),
                  IconButton(
                    iconSize: 30.0,
                    icon: Icon(_isRecording ? Icons.mic_off : Icons.mic, color: prefs.genero==1?Colors.blue:Colors.amber,),
                    onPressed: _isRecording ? stopStream : handleStream,
                  ),
                ],
              ),
            ),
    ]
    );
  }
}
