# BoardView Example

This is a complete example Flutter app demonstrating the BoardView widget functionality.

## Features

- **Drag and Drop**: Drag items between lists and reorder them
- **Scrollable Lists**: Each list supports vertical scrolling
- **Horizontal Scrolling**: Scroll horizontally between lists
- **Customizable**: Styled cards with elevation and colors
- **Real-time Updates**: UI updates immediately when items are moved

## Getting Started

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## What's Included

- **3 Lists**: "To Do", "In Progress", and "Done"
- **Sample Tasks**: Pre-populated with example tasks
- **Drag & Drop**: Move tasks between lists
- **Visual Feedback**: Cards with elevation and hover effects
- **Responsive Design**: Works on different screen sizes
- **Modern Controller**: Uses the new BoardController for better performance
- **Navigation Buttons**: Quick navigation between lists using the controller
- **Real-time Callbacks**: Live status updates showing scrolling, dragging, and animation states
- **Status Panel**: Visual feedback for all board operations

## Usage

- **Long press** any task card to start dragging
- **Drag** the card to a different position within the same list or to another list
- **Release** to drop the card in its new position
- **Long press** a list header to drag entire lists around
- **Tap navigation buttons** at the top to quickly jump between lists

## Customization

The example shows how to:
- Create custom board items with styled Cards
- Set up board lists with headers
- Handle drag and drop events
- Update your data model when items are moved
- Style the board with colors and spacing
- **Set up callbacks** for real-time state monitoring
- **Display status information** using callback data
- **Handle errors** gracefully with error callbacks

## Callback Features

The example demonstrates the powerful callback system:

```dart
boardController.setCallbacks(BoardCallbacks(
  onScroll: (position, maxExtent) {
    // React to scroll changes
  },
  onDragStart: (listIndex, itemIndex) {
    // Handle drag start
  },
  onDragEnd: (fromListIndex, fromItemIndex, toListIndex, toItemIndex) {
    // Handle successful drag completion
  },
  onError: (error, stackTrace) {
    // Handle errors gracefully
  },
));
```

The status panel shows live updates for:
- **Scrolling state** (blue indicator)
- **Animation state** (green indicator)
- **Dragging state** (orange indicator)
- **Current visible list**
- **Last performed action**

## Code Structure

- `main.dart` - App entry point with MaterialApp setup
- `example.dart` - Main BoardView implementation with callbacks
- `BoardItemObject.dart` - Data model for individual items
- `BoardListObject.dart` - Data model for lists containing items