/// Hottest Hundred Heardle
/// backend.dart
///
/// Handles api calls. Ensures other files only have to handle dart data types
/// and dom't have to make api calls.
///
/// Authors: Joshua Linehan
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

import 'song-data.dart';

/// Handles api calls. Singleton to allow it to load data from backend
/// asynchronously
class Backend {
  static const String _backendURL = String.fromEnvironment("BACKEND_URL");

  final Future<SongData?> songData = _getSongData();
  final Completer<StreamAudioSource?> clip1 = Completer<StreamAudioSource?>();
  final Completer<StreamAudioSource?> clip2 = Completer<StreamAudioSource?>();
  final Completer<StreamAudioSource?> clip3 = Completer<StreamAudioSource?>();
  final Completer<StreamAudioSource?> clip4 = Completer<StreamAudioSource?>();
  final Completer<StreamAudioSource?> clip5 = Completer<StreamAudioSource?>();
  final Completer<StreamAudioSource?> clip6 = Completer<StreamAudioSource?>();

  // private constructor
  Backend._() {
    _init();
  }

  // Singleton instance
  static final Backend _instance = Backend._();

  /// access point to singleton instance
  factory Backend() {
    return _instance;
  }

  /// Sets up clip completers
  void _init() async {
    // wait for answer data
    await songData;
    // wait for each clip to load before requesting the next
    clip1.complete(_getClip(1));
    await clip1.future;
    clip2.complete(_getClip(2));
    await clip2.future;
    clip3.complete(_getClip(3));
    await clip3.future;
    clip4.complete(_getClip(4));
    await clip4.future;
    clip5.complete(_getClip(5));
    await clip5.future;
    clip6.complete(_getClip(6));
  }

  /// retrieves a clip from backend
  static Future<StreamAudioSource?> _getClip(int clipNum) async {
    // get data from backend
    try {
      final response = await http
          .get(Uri.https(_backendURL, "/api/clip", {"clip": "$clipNum"}));
      if (response.statusCode == HttpStatus.ok) {
        final jsonData = jsonDecode(response.body);
        final Uint8List audioBytes = base64Decode(jsonData['clip$clipNum']);
        return _BackendAudioSource(audioBytes);
      } else {
        debugPrint(
            "Backend._getClip: response.toString: ${response.toString()}");
        return null;
      }
    } catch (e) {
      debugPrint("Backend._getClip: e.toString: ${e.toString()}");
      return null;
    }
  }

  /// retrieves today's answer from backend
  static Future<SongData?> _getSongData() async {
    // get data from backend
    try {
      final response =
          await http.get(Uri.https(_backendURL, "/api/current-song"));
      if (response.statusCode == HttpStatus.ok) {
        final jsonData = jsonDecode(response.body);
        return SongData(
            artist: jsonData["artist"],
            title: jsonData["title"],
            year: jsonData["year"],
            place: jsonData["place"]);
      } else {
        debugPrint(
            "Backend._getSongData: response.toString: ${response.toString()}");
        return null;
      }
    } catch (e) {
      debugPrint("Backend._getSongData: e.toString: ${e.toString()}");
      return null;
    }
  }
}

/// Implementation of StreamAudioSource for audio from backend
class _BackendAudioSource extends StreamAudioSource {
  final Uint8List _audioBytes;
  _BackendAudioSource(this._audioBytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _audioBytes.length;
    return StreamAudioResponse(
      sourceLength: _audioBytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_audioBytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
