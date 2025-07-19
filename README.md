# Digital खाता

**Digital खाता** is a Flutter application that enables shop owners to manage customer accounts—tracking dues and purchase history with Nepali calendar support and offline-first functionality.

## 🚀 Features

- **Customer Registration**

  - Assign and manage unique 4-digit IDs
  - Store customer names and contact details

- **Dues & Purchases**

  - Log product name, price, and due amount
  - Automatic Nepali date & time stamping

- **Transaction History & Summary**

  - Real-time view of total dues and itemized purchases
  - Searchable by customer ID

- **Offline-First**
  - Full offline data entry via Firebase Offline Persistence
  - Automatic sync when internet is available

## ⚙️ Configuration

### Firebase Setup

1. Copy the configuration files:

```bash
cp .env.template .env
cp lib/config/firebase_options.template.dart lib/config/firebase_options.dart
```

2. Update the `.env` file with your Firebase configuration:

```env
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id
FIREBASE_SENDER_ID=your-sender-id
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-storage-bucket
```

3. For development, you can also set these values directly in `lib/config/firebase_options.dart`

### Running the App

To run the app with your configuration:

```bash
flutter run --dart-define=FIREBASE_API_KEY=your-api-key \
           --dart-define=FIREBASE_APP_ID=your-app-id \
           --dart-define=FIREBASE_SENDER_ID=your-sender-id \
           --dart-define=FIREBASE_PROJECT_ID=your-project-id \
           --dart-define=FIREBASE_STORAGE_BUCKET=your-storage-bucket
```

Or use the .env file with a build runner.
