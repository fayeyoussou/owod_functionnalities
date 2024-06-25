import 'dart:async';
import 'dart:io';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../../core/error/server_exception.dart';
import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/show_snackbar.dart';
import '../../../../../features/messagerie/domain/entities/message.dart';
import '../../../../../features/messagerie/presentation/bloc/message_bloc.dart';
import '../../../../../features/messagerie/presentation/pages/components/message_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:path_provider/path_provider.dart';

import '../../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../../core/utils/pick_image.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  File? _image;
  TextEditingController messageController = TextEditingController();
  bool _isRecording = false;
  bool _isAudioMessage = false;
  bool _isImage = false;
  String _filePath = '';
  DeviceFileSource? source;
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  void initState() {
    super.initState();
    // _audioRecorder = AudioRecorder();
  }

  void selectImage([isGallery = true]) async {
    final pickedImage = await pickImage(isGallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
        _isImage = true;
      });
    }
  }

  void _sendMessage() async {
    try {
      String posterId =
          (context
              .read<AppUserCubit>()
              .state as AppUserLoggedIn).user.id;
      var bloc = context.read<MessageBloc>();
      if (_isAudioMessage && source != null && source!.path.isNotEmpty) {
        bloc.add(MessageUploadingEvent(
            chat: bloc.state is MessageSuccessState ? (bloc
                .state as MessageSuccessState).chatModel : null,
            userId: posterId,
            contentType: MessageContentType.audio,
            media: File(source!.path)));
      } else if (_isImage && _image != null) {
        print(_image?.path);
        bloc.add(

          MessageUploadingEvent(
            chat: bloc.state is MessageSuccessState ? (bloc
                .state as MessageSuccessState).chatModel : null,
            description: messageController.text.trim(),
            userId: posterId,
            contentType: MessageContentType.image,
            media: _image,

          ),
        );
      } else {
        bloc.add(
          MessageUploadingEvent(
            chat: bloc.state is MessageSuccessState ? (bloc
                .state as MessageSuccessState).chatModel : null,
            content: messageController.text.trim(),
            userId: posterId,
            contentType: MessageContentType.text,
            media: _image,

          ),
        );
      }
      setState(() {
        _image = null;
        source = null;
        _filePath = '';
        _isImage = false;
        _isAudioMessage = false;
        messageController.text = '';
      });
    } on ServerException catch (e) {
      showSnackBar(context, e.message, AppPalette.gradient1);
    }
  }

  // @override
  // void dispose() {
  //   _audioRecorder.dispose();
  //
  //   super.dispose();
  // }

  // void startRecorder() async {
  //   try {
  //     if (await _audioRecorder.hasPermission()) {
  //       Directory tempDir = await getApplicationDocumentsDirectory();
  //       String path =
  //           '${tempDir.path}/temp_${const Uuid().v1()}.m4a'; // Use .m4a for AAC
  //       await _audioRecorder.start(
  //         const RecordConfig(
  //           encoder: AudioEncoder.aacEld,
  //           // Use AAC encoder
  //           sampleRate: 44100,
  //           bitRate: 64000, // Lower the bitrate for better compression
  //         ),
  //         path: path,
  //       );
  //
  //       setState(() {
  //         _isRecording = true;
  //         _filePath = path;
  //       });
  //     }
  //   } catch (e) {
  //     showSnackBar(context, 'Error Start Recording $e');
  //   }
  // }
  //
  // void stopRecording() async {
  //   try {
  //     String? path = await _audioRecorder.stop();
  //     final file = File(path!);
  //
  //     print('${await file.length()} bytes');
  //     setState(() {
  //       _isRecording = false;
  //       _isAudioMessage = true;
  //       source = DeviceFileSource(path!);
  //
  //
  //       if (_isImage || _image != null) {
  //         _isImage = false;
  //         _image = null;
  //       }
  //     });
  //   } catch (e) {
  //     showSnackBar(context, 'Error Stopping Recording $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Color color = AppPalette.gradient2;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.defaultPadding,
        vertical: AppTheme.defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: _isAudioMessage
            ? MessageAudioPlayer(
          source: source,
          isAudio: () {
            setState(() {
              _isAudioMessage = false;
            });
          },
          sendAudio: _sendMessage,
        )
            : Row(
          children: [
            GestureDetector(
              onTap: () {
                if (_currentStatus==RecordingStatus.Stopped || _currentStatus == RecordingStatus.Unset) {
                  print('----- INITIALIZING ----->');
                  _init();
                } else if(_currentStatus==RecordingStatus.Recording){
                  print('----- STOPING ----->');

                  _stop();
                }
              },
              child: Icon(
                  _currentStatus==RecordingStatus.Recording ? Icons.stop : Icons.mic,
                color: AppPalette.gradient1,
              ),
            ),
            const SizedBox(width: AppTheme.defaultPadding),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.defaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: AppPalette.gradient1.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    if (_image != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.file(
                            _image!,
                            height: 50,
                            fit: BoxFit.contain,
                            width: 50,
                          ),
                        ),
                      ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (String message) {
                          setState(() {});
                        },
                        controller: messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: selectImage,
                      child: Icon(
                        Icons.attach_file,
                        color: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                    ),
                    const SizedBox(width: AppTheme.defaultPadding / 4),
                    messageController.text.isNotEmpty || _image != null
                        ? IconButton(
                      icon: Icon(Icons.send,
                          color: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.64)),
                      onPressed: _sendMessage,
                    )
                        : GestureDetector(
                      onTap: () {
                        selectImage(false);
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _init() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/recorder_';
        Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path + customPath + DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        // after initialization
        var current = await _recorder?.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print(_currentStatus);
        });
        await _start();
      } else {
        return const SnackBar(content: Text("You must accept permissions"));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
        print(_current?.status.toString());
      });

      const tick =  Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }
  _stop() async {
    var result = await _recorder?.stop();
    print("Stop recording: ${result?.path}");
    print("Stop recording: ${result?.duration}");

    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
      _isRecording = false;
      _isAudioMessage = true;
      source = DeviceFileSource(result!.path!);


      if (_isImage || _image != null) {
        _isImage = false;
        _image = null;
      }
    });
  }
}
