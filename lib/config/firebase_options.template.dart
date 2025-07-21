// This is a template file. Copy this to firebase_options.dart and fill in your values
class FirebaseConfig {
  static const apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'your-api-key',
  );

  static const appId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: 'your-app-id',
  );

  static const messagingSenderId = String.fromEnvironment(
    'FIREBASE_SENDER_ID',
    defaultValue: 'your-sender-id',
  );

  static const projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'your-project-id',
  );

  static const storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: 'your-storage-bucket',
  );
}
