// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

State _$StateFromJson(Map<String, dynamic> json) => State(
      system: $enumDecodeNullable(_$SystemStateEnumMap, json['system']),
      playback: $enumDecodeNullable(_$PlaybackStateEnumMap, json['playback']),
      volume: json['volume'] as int?,
      bluetooth:
          $enumDecodeNullable(_$BluetoothStateEnumMap, json['bluetooth']),
      metadata: json['metadata'] == null
          ? null
          : MetaData.fromJson(json['metadata'] as Map<String, dynamic>),
      playbackPosition: json['playbackPosition'] as int?,
    );

Map<String, dynamic> _$StateToJson(State instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('system', _$SystemStateEnumMap[instance.system]);
  writeNotNull('playback', _$PlaybackStateEnumMap[instance.playback]);
  writeNotNull('volume', instance.volume);
  writeNotNull('bluetooth', _$BluetoothStateEnumMap[instance.bluetooth]);
  writeNotNull('metadata', instance.metadata?.toJson());
  writeNotNull('playbackPosition', instance.playbackPosition);
  return val;
}

const _$SystemStateEnumMap = {
  SystemState.booting: 'booting',
  SystemState.updating: 'updating',
  SystemState.error: 'error',
  SystemState.ready: 'ready',
};

const _$PlaybackStateEnumMap = {
  PlaybackState.inactive: 'inactive',
  PlaybackState.paused: 'paused',
  PlaybackState.playing: 'playing',
};

const _$BluetoothStateEnumMap = {
  BluetoothState.inactive: 'inactive',
  BluetoothState.pairing: 'pairing',
  BluetoothState.connected: 'connected',
};
