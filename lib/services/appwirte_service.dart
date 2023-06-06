import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppWriteService {
  static Client client = Client();
  static late Account account;
  static late AuthUser? user;
  static late Databases databases;
  static late Storage storage;
  static late Realtime realtime;
  static late Session session;
  static void init() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(AppCredentials.projectId)
        .setSelfSigned(status: false);
    account = Account(client);
    databases = Databases(client);
    realtime = Realtime(client);
    storage = Storage(client);
  }
}

class AppCredentials {
  static String projectId = dotenv.get('projectId');
  static String databaseId = dotenv.get('databaseId');
  static String userCollection = dotenv.get('userCollection');
  static String messagesCollection = dotenv.get('messagesCollection');
  static String chatCollection = dotenv.get('chatCollection');
  static String bucketCollection = dotenv.get('bucketCollection');
  static String profileBucketCollection = dotenv.get('profileBucketCollection');
}
