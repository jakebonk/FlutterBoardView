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

## Usage

- **Long press** any task card to start dragging
- **Drag** the card to a different position within the same list or to another list
- **Release** to drop the card in its new position
- **Long press** a list header to drag entire lists around

## Customization

The example shows how to:
- Create custom board items with styled Cards
- Set up board lists with headers
- Handle drag and drop events
- Update your data model when items are moved
- Style the board with colors and spacing

## Code Structure

- `main.dart` - App entry point with MaterialApp setup
- `example.dart` - Main BoardView implementation
- `BoardItemObject.dart` - Data model for individual items
- `BoardListObject.dart` - Data model for lists containing items