# Chat API Integration Guide

## Overview
The chat page has been integrated with your message classification API endpoint. When users send a message, it will call the API at `http://localhost:3000/api/messages/classify` and display the response.

## Features Added

### 1. API Service Layer
- **File**: `lib/core/services/api_service.dart`
- Generic HTTP client using Dio
- Error handling and timeout configuration
- Logging for debugging

### 2. Chat API
- **File**: `lib/features/chat/api.dart`
- `classifyMessage()` method that calls your endpoint
- Error handling with user-friendly messages
- Response models for structured data

### 3. Enhanced Chat UI
- **File**: `lib/features/chat/presentation/pages/chat_page.dart`
- Loading indicators during API calls
- Error message display with retry functionality
- Classification and recommendation display
- Disabled input during loading

## API Response Format

The chat expects responses in this format:

```json
{
  "response": "I'd be happy to help you find thrilling action movies! Here are some recommendations...",
  "classification": "action_request",
  "recommendations": [
    "John Wick",
    "Mad Max: Fury Road",
    "The Dark Knight"
  ],
  "success": true
}
```

### Required Fields
- `response`: The main message to display to the user

### Optional Fields
- `classification`: Category label shown as a chip
- `recommendations`: List of movie recommendations
- `success`: Boolean indicating success status

## Testing the Integration

### 1. Start Your Server
Make sure your API server is running on `localhost:3000`

### 2. Test Messages
Try these sample messages in the chat:
- "I want to watch a thrilling action movie"
- "Recommend a comedy for tonight"
- "What are the best sci-fi films?"

### 3. Expected Behavior
1. **Message Sent**: User message appears on the right
2. **Loading State**: "Thinking..." indicator appears
3. **API Response**: Bot response appears on the left with:
   - Classification chip (if provided)
   - Recommendations list (if provided)
   - Proper timestamp

### 4. Error Handling
If the server is not running, you'll see:
- Error icon and "Connection Error" label
- User-friendly error message
- Red styling to indicate the error

## Quick Test Setup

You can test with suggestion chips:
1. Open the chat page
2. Tap on any of the suggested chips:
   - "Recommend a comedy"
   - "Latest releases" 
   - "Top rated movies"
   - "Award winners"
3. These will automatically trigger the API call

## Troubleshooting

### Common Issues:

1. **Connection refused**
   - Make sure your server is running on port 3000
   - Check if the endpoint `/api/messages/classify` exists

2. **CORS Issues** (if testing on web)
   - Add CORS headers to your server
   - Allow requests from Flutter app origin

3. **Response Format Issues**
   - Ensure your API returns JSON
   - Include at least the `response` field

### Server Requirements:
```bash
POST http://localhost:3000/api/messages/classify
Content-Type: application/json

{
  "message": "I want to watch a thrilling action movie"
}
```

## Customization

### Changing the Base URL
Update `lib/core/services/api_service.dart`:
```dart
baseUrl: 'http://your-server:port',
```

### Adding Authentication
Add headers in `api_service.dart`:
```dart
headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer your-token',
},
```

### Timeout Configuration
Modify timeouts in `lib/core/constants/app_constants.dart`:
```dart
static const int connectionTimeout = 30000; // 30 seconds
static const int receiveTimeout = 30000;    // 30 seconds
```

## Next Steps

1. Test the integration with your actual server
2. Customize the UI styling if needed
3. Add more API endpoints as needed
4. Consider adding retry functionality
5. Add unit tests for the API service
