import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvider {
  late io.Socket socket;
  final String _url = dotenv.env['APIDELIVERY']!;
  String nameSpace = '';
  Map<String, dynamic> query = {};

  SocketProvider({ required this.nameSpace, required this.query }) {
    _initSocket();
  }

  void _initSocket() {
    try {
      Uri uri = Uri.http(_url, nameSpace, query);
      io.OptionBuilder opts = io.OptionBuilder();

      opts.setTransports(['websocket']);
      opts.disableAutoConnect();
      
      socket = io.io(uri.toString(), opts.build());
      Logger().d('Socket $_url/$nameSpace initialized');
      
    } catch (e) {
      Logger().d('Error: $e');
    }
  }

  void connect() {
    socket.connect();
    socket.onConnect((data) => Logger().d('Socket connected to: $_url/$nameSpace'));
  }

  void disconnect() {
    if (socket.disconnected) return;
    socket.dispose();
    socket.onDisconnect((data) => Logger().d('Socket $_url/$nameSpace disconnected'));
  }

  bool isConnected() => socket.connected; 

}