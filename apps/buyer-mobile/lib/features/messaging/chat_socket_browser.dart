import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel connectChatSocket(Uri uri) => WebSocketChannel.connect(uri);
