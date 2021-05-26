import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
          title: 'Firebase Messaging App',
      theme: ThemeData.light(),

      home: Myapp(),
    );

  }
}

class Myapp extends StatefulWidget {
  Myapp() : super();
  final String title = 'Firebase Messaging Demo';

  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
     String messageTitle = "";
     String messageBody = "Empty messageBody";
String notificationAlert = "notificationAlert"; 
String notificationImage = "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png"; 


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('Device Token: $deviceToken');
    });
  }

  _configureFirebaseListeners(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
      setState((){
        messageTitle = message['notification']['title'];
        notificationAlert = 'New Notification Alert';
        messageBody = message['data']['title'];
        notificationImage = message['data']['img'];

      });

      print('onMessage: $message');
      },

      onLaunch: (Map<String, dynamic> message) async{
      print('onMessage: $message');
      },

      onResume: (Map<String, dynamic> message) async{
        setState((){
        messageTitle = message['notification']['title'];
        notificationAlert = 'Application opened From Notification';
        messageBody = message['data']['title'];
        notificationImage = message['data']['img'];
      });
      print('onMessage: $message ');
      },
    );
  }

  @override 
  void initState() { 
    super.initState();
    _getToken();
    _configureFirebaseListeners();

// FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print('Got a message whilst in the foreground!');
//   print('Message data: ${message.data}');

//   if (message.notification != null) {
//     print('Message also contained a notification: ${message.notification}');
//   }
// });
  }

  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
appBar: AppBar(title: Text(messageTitle != null? messageTitle : 'Firebase Push Notification'),),
body:  Center(
  
        child:
        Container(
          padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: Image.network(notificationImage) ,
              title: Text(
               notificationAlert != null? notificationAlert : 'No Message Notifications Recieved',
               style: TextStyle(fontSize:15.0,),
            ),
            subtitle: Text(
              messageBody != null? messageBody : 'No Message Body In Message',
              style: TextStyle(fontSize:20.0,),
            ),
            ),
            
            
            
          ],
        ),),
      ),
    );
  }
}
