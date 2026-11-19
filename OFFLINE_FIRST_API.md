# Offline-First API Integration

## Architecture Overview

This app implements an **offline-first architecture** with Dio for API communication:

```
┌─────────────────────────────────────────────────────────────┐
│                        UI Layer (main.dart)                 │
│              Displays counter, online status, sync UI        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      BLoC Layer                              │
│  CounterBloc handles all events and state management         │
└─────────────────────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────┬─────────────────────┐
        ↓                     ↓                     ↓
   ┌─────────┐           ┌──────────┐         ┌─────────────┐
   │Repository│          │SyncService│        │NetworkService│
   │(Local DB)│          │ (Sync)   │        │(Connectivity)│
   └─────────┘           └──────────┘        └─────────────┘
        ↓                     ↓
   ┌─────────┐           ┌──────────┐
   │ Drift   │          │  Dio API │
   │Database │          │ Service  │
   └─────────┘          └──────────┘
        ↓                    ↓
   SQLite (Local)       API Server
```

## Components

### 1. **NetworkService** (`services/network_service.dart`)
- Checks internet connectivity
- Provides real-time connection status stream
- Uses `connectivity_plus` package

### 2. **ApiService** (`services/api_service.dart`)
- Handles all API calls using Dio
- Methods: `saveCounter()`, `getCounter()`
- Currently uses JSONPlaceholder as mock API
- Customizable base URL

### 3. **SyncService** (`services/sync_service.dart`)
- Orchestrates synchronization between local DB and API
- Methods:
  - `syncCounterToApi()` - Auto-sync after local changes
  - `fetchCounterFromApi()` - Get value from API or fallback to local
  - `pullFromApi()` - Manual pull from server
  - `pushToApi()` - Manual push to server

### 4. **CounterBloc** (`counter_bloc.dart`)
- Updated with new events for API operations
- Automatically syncs when device comes online
- Handles offline/online state changes

### 5. **CounterState** (`counter_state.dart`)
- Added fields:
  - `isOnline` - Current connectivity status
  - `isSyncing` - Sync in progress
  - `syncMessage` - User-friendly sync messages

### 6. **CounterEvent** (`counter_event.dart`)
- Added events:
  - `SyncToApiEvent` - Manual sync
  - `PullFromApiEvent` - Pull from API
  - `PushToApiEvent` - Push to API
  - `ConnectionStatusChangedEvent` - Network status changed

## Features

### ✅ Offline-First
- Counter value saved locally to SQLite
- App works fully offline
- Changes persist even without internet

### ✅ Automatic Syncing
- When device goes online, automatically pushes pending changes
- Increments/decrements auto-sync to API when online
- No data loss

### ✅ Manual Sync Controls
- Pull button: Fetch latest value from API
- Push button: Send local value to API
- Real-time sync status display

### ✅ Connectivity Awareness
- Shows online/offline indicator
- Adapts behavior based on connectivity
- Displays sync messages

## Flow Diagram

### Local-Only Flow (Offline)
```
User increments → BLoC → Repository → SQLite ✓
                        ↓
                  SyncService
                   checks online
                        ↓
                      SKIP (offline)
```

### Online Flow
```
User increments → BLoC → Repository → SQLite ✓
                        ↓
                  SyncService
                        ↓
                   checks online
                        ↓
                   YES → Dio → API ✓
```

### Manual Sync
```
User taps Pull → BLoC → SyncService → Dio → API
                              ↓
                          Update SQLite
                              ↓
                          Emit new state
```

## Usage Example

### Automatic Sync
```dart
// When user increments, it auto-syncs if online
context.read<CounterBloc>().add(IncrementEvent());
// BLoC handles: DB save + API sync automatically
```

### Manual Pull/Push
```dart
// Pull latest from server
context.read<CounterBloc>().add(PullFromApiEvent());

// Push local value to server
context.read<CounterBloc>().add(PushToApiEvent());
```

### Connectivity Monitoring
```dart
// App automatically detects online/offline
// Shows indicator and auto-syncs when connection restored
```

## Key Dependencies

- **Dio** (5.3.0) - HTTP client with retry/interceptors
- **connectivity_plus** (5.0.0) - Network status monitoring
- **Drift** (2.14.0) - Local database (unchanged)
- **flutter_bloc** (8.1.3) - State management

## Testing

### Offline Mode
1. Turn off WiFi/Mobile data
2. Increment counter - saves locally only
3. Turn connectivity back on
4. See auto-sync to API

### Online Mode
1. Increment counter while online
2. See instant API sync
3. Verify sync message

### Manual Controls
1. Use Pull button to fetch from API
2. Use Push button to send to API
3. Watch sync status in real-time

## Configuration

To change API endpoint, update `ApiService`:

```dart
static const String baseUrl = 'YOUR_API_BASE_URL';
static const String counterEndpoint = '/your/endpoint';
```

Modify save/get methods to match your API contract:

```dart
Future<int> saveCounter(int value) async {
  final response = await _dio.post(
    '/counter',
    data: {'value': value}, // Adjust as needed
  );
  return value;
}
```

## Notes

- Currently uses JSONPlaceholder as mock API
- Replace with real API endpoint for production
- Dio handles timeouts and retries automatically
- NetworkService provides real-time connectivity updates
