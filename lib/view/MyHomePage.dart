import 'dart:async';
import 'dart:ui';

import 'package:challenge/constant/strings.dart';
import 'package:challenge/utils/system_state_overlay.dart';
import 'package:challenge/utils/volume_ovelay.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils/duration_converter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  OverlayEntry? volumeOverlayEntry;
  OverlayEntry? systemStateOverlayEntry;
  Timer? timer;
  WebSocketChannel? channel;
  String? coverArtUrl;
  String? artist;
  String? title;
  int volume = 0;
  bool isPlaying = false;
  int duration = 0;
  int playbackPosition = 0;
  String? systemState;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    channel =
        IOWebSocketChannel.connect('wss://challenge.jusst.engineering/ws');
    channel?.stream.listen((message) {
      Map<String, dynamic> data = jsonDecode(message);
      if (data.containsKey('metadata')) {
        setState(() {
          coverArtUrl = data['metadata']['coverArt'] ?? "";
          artist = data['metadata']['artist'];
          title = data['metadata']['title'];
          duration = data['metadata']['duration'] ?? 0;
          if (coverArtUrl != null &&
              artist != null &&
              title != null &&
              duration != 0) {
            loading = false;
          }
        });
      }
      if (data.containsKey('volume')) {
        setState(() {
          volume = data['volume'];
        });
        showVolumeOverlay(context, volumeOverlayEntry, volume);
      }
      if (data.containsKey('playbackState')) {
        setState(() {
          isPlaying = data['playbackState'] == 'play';
        });
      }
      if (data.containsKey('playbackPosition')) {
        setState(() {
          playbackPosition = data['playbackPosition'];
        });
      }
      if (data.containsKey('systemState')) {
        setState(() {
          systemState = data['systemState'];
        });
        if (systemState != 'ready') {
          showSystemStateOverlay(context, systemStateOverlayEntry, systemState);
        }
      }
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPlaying && playbackPosition < duration) {
        setState(() {
          playbackPosition++;
        });
      }
    });
  }

  @override
  void dispose() {
    channel?.sink.close();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading == false
          ? Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      opacity: 0.5,
                      image: NetworkImage(
                          coverArtUrl != null ? coverArtUrl! : gradientBG),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                        coverArtUrl!,
                        width: 300,
                        height: 300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "$title",
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white),
                      ),
                      Text(
                        "$artist",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.skip_previous,
                            size: 50,
                            color: Colors.white,
                          ),
                          IconButton(
                            icon: Icon(
                                isPlaying ? Icons.play_arrow : Icons.pause),
                            iconSize: 50,
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                              if (isPlaying) {
                                channel?.sink
                                    .add(jsonEncode({'command': 'play'}));
                              } else {
                                channel?.sink
                                    .add(jsonEncode({'command': 'pause'}));
                              }
                            },
                          ),
                          const Icon(
                            Icons.skip_next,
                            size: 50,
                            color: Colors.white,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Slider(
                        min: 0.0,
                        max: duration.toDouble(),
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey.shade800,
                        value: playbackPosition.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            playbackPosition = value.toInt();
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DurationConverter(playbackPosition),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              DurationConverter(duration),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: systemStateOverlayEntry != null
          ? Container(
              height: 60,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text("$systemStateOverlayEntry"),
            )
          : null,
    );
  }
}
