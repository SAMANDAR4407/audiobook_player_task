import 'dart:math';

import 'package:audiobook_player/main.dart';
import 'package:flutter/material.dart';

import '../util.dart';

class SeekBarData {
  final Duration position;
  final Duration duration;

  SeekBarData(this.position, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;

  const SeekBar(
      {super.key,
      required this.position,
      required this.duration});

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(formatDuration(widget.position), style: const TextStyle(color: Colors.white),),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(
                disabledThumbRadius: 4,
                enabledThumbRadius: 4,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 10
              ),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              thumbColor: Colors.white,
              overlayColor: Colors.white
            ),
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(
                _dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()
                ), 
              onChanged: (value){
                setState(() {
                  audioHandler.seek(Duration(milliseconds: value.toInt()));
                });
              },
            ),
          ),
        ),
        Text(formatDuration(widget.duration), style: const TextStyle(color: Colors.white),),
      ],
    );
  }
}
