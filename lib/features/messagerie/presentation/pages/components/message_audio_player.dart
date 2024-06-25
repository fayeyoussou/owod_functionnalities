import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/utils/show_snackbar.dart';

class MessageAudioPlayer extends StatefulWidget {
   MessageAudioPlayer({super.key,required this.source, required this.isAudio,this.sendAudio});
  final DeviceFileSource? source;

  final void Function()? sendAudio;
   final void Function()? isAudio;

  @override
  MessageAudioPlayerState createState() => MessageAudioPlayerState();
}

class MessageAudioPlayerState extends State<MessageAudioPlayer> {
  late AudioPlayer _audioPlayer;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _startStreams();
  }
  void _startStreams() async {
    await _audioPlayer.setSource(widget.source!);
    _initStreams();
  }
  void _initStreams() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen(
          (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
          setState(() {
            _playerState = state;
          });
        });
  }

  Future<void> _play() async {
    await _audioPlayer.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    setState(() => _playerState = PlayerState.paused);
  }


  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }
  Color color = AppPalette.gradient2;
  Future<void> deleteAudio() async {
    try {
      if (widget.source is DeviceFileSource) {
        final filePath = (widget.source as DeviceFileSource).path;
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          widget.isAudio!();
          setState(() {
            _duration = null;
            _position = null;
          });
        } else {
          showSnackBar(context, 'File doesnt exist');
        }
      }
    } catch (e) {
      if(mounted) showSnackBar(context, 'Error deleting audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: const Key('play_button'),
          onPressed: _isPlaying? _pause : _play,
          iconSize: 20.0,
          icon: Icon(_isPlaying? Icons.pause : Icons.play_arrow  ),
          color: color,
        ),

        Flexible( // Use Flexible instead of Expanded inside Row
          child: Slider(
            onChanged: (value) {
              final duration = _duration;
              if (duration == null) {
                return;
              }
              final position = value * duration.inMilliseconds;
              _audioPlayer.seek(Duration(milliseconds: position.round()));
            },
            value: (_position!= null &&
                _duration!= null &&
                _position!.inMilliseconds > 0 &&
                _position!.inMilliseconds < _duration!.inMilliseconds)
                ? _position!.inMilliseconds / _duration!.inMilliseconds
                : 0.0,
          ),
        ),
        Text(
          _position!= null
              ? '$_positionText / $_durationText'
              : _duration!= null
              ? _durationText
              : '',
          style: const TextStyle(fontSize: 12.0),
        ),
        if(widget.sendAudio !=null)IconButton(
          key: const Key('delete_button'),
          onPressed: deleteAudio,
          iconSize: 20.0,
          icon: const Icon(Icons.delete),
          color: color,
        ),
        if(widget.sendAudio !=null) IconButton(
          key: const Key('send_button'),
          onPressed: widget.sendAudio,
          iconSize: 20.0,
          icon: const Icon(Icons.send),
          color: AppPalette.gradient1,
        ),
      ],
    );
  }
}
