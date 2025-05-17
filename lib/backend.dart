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

/// Handles api calls. Singleton to allow it to load data from backend
/// asynchronously
class Backend {
  static const String _backendURL = String.fromEnvironment("BACKEND_URL");

  late final Future<StreamAudioSource?> clip1;
  late final Future<StreamAudioSource?> clip2;
  late final Future<StreamAudioSource?> clip3;
  late final Future<StreamAudioSource?> clip4;
  late final Future<StreamAudioSource?> clip5;
  late final Future<StreamAudioSource?> clip6;

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

  void _init() async {
    clip1 = _getClip(1);
    await clip1;
    clip2 = _getClip(2);
    await clip2;
    clip3 = _getClip(3);
    await clip3;
    clip4 = _getClip(4);
    await clip4;
    clip5 = _getClip(5);
    await clip5;
    clip6 = _getClip(6);
    await clip6;
  }

  /// returns a clip from backend
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
