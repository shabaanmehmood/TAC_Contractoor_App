import 'package:socket_io_client/socket_io_client.dart' as IO;

final String socketUrl = 'http://148.66.158.113:3006/'; // Replace with your server
late IO.Socket socket;

void connectAndStart() {
  socket = IO.io(socketUrl, <String, dynamic>{
    'transports': ['websocket'],
  });

  socket.connect();

  socket.onConnect((_) {
    print('connected');
    sendMessage();
  });

  socket.on('receive_message', (data) {
    print('New message: $data');
  });
}

void sendMessage() {
  Map<String, dynamic> message = {
    "senderId": "58edc77a-91c6-4299-9c02-6fadb5668565",
    "senderType": "Guard",
    "receiverId": "f7fc8393-00bc-4cba-a72f-ecbdf8069d13",
    "receiverType": "Contractor",
    "text": "Hello from Postman simulation"
  };
  socket.emit('send_message', message);
}
