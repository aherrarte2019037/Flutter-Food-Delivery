import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvider {
  late io.Socket socket;
  final String _url = dotenv.env['APIDELIVERY']!;
  bool autoConnect = false;
  String nameSpace = '';
  Map<String, dynamic> query = {};

  SocketProvider({ required this.nameSpace, required this.query, required this.autoConnect }) {
    _initSocket(autoConnect: autoConnect);
  }

  void _initSocket({required bool autoConnect}) {
    try {
      Uri uri = Uri.http(_url, nameSpace, query);
      io.OptionBuilder opts = io.OptionBuilder();

      opts.setTransports(['websocket']);
      opts.disableAutoConnect();
      
      socket = io.io(uri.toString(), opts.build());
      Logger().d('Socket $_url/$nameSpace initialized');

      if (autoConnect) connect();
      
    } catch (e) {
      Logger().d('Error: $e');
    }
  }

  void connect() {
    try {
      socket.connect();
      socket.onConnectError((data) => Logger().d('Error: $data'));
      socket.onConnect((data) => Logger().d('Socket connected to: $_url/$nameSpace'));
      
    } catch (e) {
      Logger().d('Error: $e');
    }
  }

  void disconnect() {
    if (socket.disconnected) return;
    socket.dispose();
    socket.onDisconnect((data) => Logger().d('Socket $_url/$nameSpace disconnected'));
  }

  void emit(String event, Map<String, dynamic> data) {
    if (!isConnected()) return;

    final String dataEncoded = jsonEncode(data);
    socket.emit(event, dataEncoded);
  }

  void on(String event, Function callback) {
    socket.on(event, (data) => callback(data));
  }

  bool isConnected() => socket.connected; 

}