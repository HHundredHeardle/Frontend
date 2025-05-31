/// Hottest Hundred Heardle
/// backend.dart
///
/// Handles api calls. Ensures other files only have to handle dart data types
/// and don't have to make api calls.
///
/// Authors: Joshua Linehan
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'song_data.dart';

/// Handles api calls. Singleton to allow it to load data from backend
/// asynchronously
class Backend {
  static const String _backendURL =
      String.fromEnvironment("BACKEND_URL"); // TODO: assert not empty

  final Completer<SongData> songData = Completer<SongData>();
  final Completer<List<String>> answers = Completer<List<String>>();
  final Completer<StreamAudioSource> clip1 = Completer<
      StreamAudioSource>(); // TODO: add to list, privatise and write getter
  final Completer<StreamAudioSource> clip2 = Completer<StreamAudioSource>();
  final Completer<StreamAudioSource> clip3 = Completer<StreamAudioSource>();
  final Completer<StreamAudioSource> clip4 = Completer<StreamAudioSource>();
  final Completer<StreamAudioSource> clip5 = Completer<StreamAudioSource>();
  final Completer<StreamAudioSource> clip6 = Completer<StreamAudioSource>();

  // private constructor
  Backend._() {
    assert(_backendURL.isNotEmpty);
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
    await Future.wait([
      _getSongData().then(
        (value) => songData.complete(value),
      ),
      _getAnswers().then(
        (value) => answers.complete(value),
      ),
    ]);
    // wait for each clip to load before requesting the next
    await _getClip(1).then(
      (value) => clip1.complete(value),
    );
    await _getClip(2).then(
      (value) => clip2.complete(value),
    );
    await _getClip(3).then(
      (value) => clip3.complete(value),
    );
    await _getClip(4).then(
      (value) => clip4.complete(value),
    );
    await _getClip(5).then(
      (value) => clip5.complete(value),
    );
    await _getClip(6).then(
      (value) => clip6.complete(value),
    );
  }

  /// retrieves a clip from backend
  static Future<StreamAudioSource> _getClip(int clipNum) async {
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
          "${(Backend).toString()}._getClip: response.toString: ${response.toString()}",
        );
        return Future.error("Failed to load data.");
      }
    } catch (e) {
      debugPrint(
        "${(Backend).toString()}._getClip: e.toString: ${e.toString()}",
      );
      return Future.error("Failed to load data.");
    }
  }

  /// retrieves today's answer from backend
  static Future<SongData> _getSongData() async {
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
          place: jsonData["place"],
        );
      } else {
        debugPrint(
          "${(Backend).toString()}._getSongData: response.toString: ${response.toString()}",
        );
        return Future.error("Failed to load data.");
      }
    } catch (e) {
      debugPrint(
        "${(Backend).toString()}._getSongData: e.toString: ${e.toString()}",
      );
      return Future.error("Failed to load data.");
    }
  }

  /// retrieves answers list
  static Future<List<String>> _getAnswers() async {
    // get data from backend
    try {
      final response = await http.get(Uri.https(_backendURL, "/api/answers"));
      if (response.statusCode == HttpStatus.ok) {
        return List.from(jsonDecode(response.body));
      } else {
        debugPrint(
          "${(Backend).toString()}._getAnswers: response.toString: ${response.toString()}",
        );
        return Future.error("Failed to load data.");
      }
    } catch (e) {
      debugPrint(
        "${(Backend).toString()}._getAnswers: e.toString: ${e.toString()}",
      );
      return Future.error("Failed to load data.");
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
