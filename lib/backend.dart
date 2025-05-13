/// Hottest Hundred Heardle
/// backend.dart
///
/// Handles api calls. Ensures other files only have to handle dart data types
/// and dom't have to make api calls.
///
/// Authors: Joshua Linehan
library;

import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

/// Handles api calls
class Backend {
  static const int _httpOK = 200;
  static const String _backendURL = String.fromEnvironment("BACKEND_URL");

  /// returns a clip from
  static Future<StreamAudioSource?> getClip(int clipNum) async {
    // get data from backend
    try {
      final response =
          await http.get(Uri.https(_backendURL, "/api/current-song"));
      if (response.statusCode == _httpOK) {
        final jsonData = jsonDecode(response.body);
        final Uint8List audioBytes = base64Decode(jsonData['clip$clipNum']);
        return _BackendAudioSource(audioBytes);
      } else {
        debugPrint(response.toString());
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
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
