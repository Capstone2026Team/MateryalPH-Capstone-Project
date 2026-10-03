import 'package:web_socket_channel/web_socket_channel.dart';
import 'chat_socket_browser.dart'
    if (dart.library.io) 'chat_socket_native.dart'
    as platform;

WebSocketChannel connectChatSocket(Uri uri) => platform.connectChatSocket(uri);
