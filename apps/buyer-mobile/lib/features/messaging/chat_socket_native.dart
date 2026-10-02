import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// An application origin label, not an endpoint or authorization credential.
// Reverb still requires the user's server-authorized private-channel signature.
WebSocketChannel connectChatSocket(Uri uri) => IOWebSocketChannel.connect(
  uri,
  headers: {'Origin': 'https://materyalph-buyer'},
);
