import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/common/widgets/loader.dart';
import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/utils/show_snackbar.dart';
import '../../../data/models/message_model.dart';

class AudioMessage extends StatefulWidget {
  final MessageModel? message;
  final bool isSender;

  const AudioMessage({super.key, this.message, this.isSender = true});

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  late AudioPlayer _audioPlayer;
  bool _downloaded = false;
  bool _isDownloaading = false;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  DeviceFileSource? source;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration != null ? '${_duration!.inMinutes}:${_duration!.inSeconds/60}' : '';


  String get _positionText {
    if (_duration != null && _position != null) {
      final minutes = _position!.inMinutes;
      final seconds = _position!.inSeconds % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '';
    }
  }
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  void _startStreams() async {
    await _audioPlayer.setSource(source!);
    _initStreams();
  }

  void _downloadAudio() async {
    try {
      // Get the path to the application documents directory
      Directory downloadsDir = await getApplicationDocumentsDirectory();
      String downloadsPath = downloadsDir.path;
      String filePath = '$downloadsPath/';
      String url = widget.message!.content;
      final fileName = (url.split('/')).last;
      filePath = '$filePath$fileName.wav';

      final File file = File(filePath);
      if (await file.exists()) {
        // await file.delete();
        if (kDebugMode) {
          print('Existing file deleted: $filePath');
        }
      }

      // Create a new file to write the downloaded data
      final newFile = File(filePath);
      final request = Request('GET', Uri.parse(url));
      final response = await request.send();

      if (response.statusCode == 200) {
        final totalBytes = response.contentLength ?? 0;
        num bytesReceived = 0;

        // Open a sink to write the data
        final sink = newFile.openWrite();

        await response.stream.listen((chunk) {
          // Write the received data to the file
          sink.add(chunk);
          bytesReceived += chunk.length;

          // Calculate the download progress
          double progress = bytesReceived / totalBytes;
          if (progress == 1) {
            setState(() {
              _downloaded = true;
              source = DeviceFileSource(filePath);
              _startStreams();
            });
          }
        }).asFuture();

        // Close the sink
        await sink.close();
      } else if (mounted) {
        showSnackBar(
            context, 'Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      if (mounted) showSnackBar(context, 'Error during update: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _downloaded
            ? IconButton(
                key: const Key('play_button'),
                onPressed: _isPlaying ? _pause : _play,
                iconSize: 20.0,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                color: color,
              )
            : _isDownloaading
                ? const Loader()
                : IconButton(
                    key: const Key('play_button'),
                    onPressed: () {
                      _downloadAudio();
                      setState(() {
                        _isDownloaading = true;
                      });
                    },
                    iconSize: 20.0,
                    icon: const Icon(Icons.download),
                    color: color,
                  ),
        Flexible(
          // Use Flexible instead of Expanded inside Row
          child: Slider(
            onChanged: (value) {
              final duration = _duration;
              if (duration == null) {
                return;
              }
              final position = value * duration.inMilliseconds;
              _audioPlayer.seek(Duration(milliseconds: position.round()));
            },
            value: (_position != null &&
                    _duration != null &&
                    _position!.inMilliseconds > 0 &&
                    _position!.inMilliseconds < _duration!.inMilliseconds)
                ? _position!.inMilliseconds / _duration!.inMilliseconds
                : 0.0,
          ),
        ),
        Text(
          _position != null
              ? _positionText
              : _duration != null
                  ? _durationText
                  : '',
          style: const TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }
}
