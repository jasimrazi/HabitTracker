# Habit Tracker App

This is a Habit Tracker app built with Flutter and Firebase, designed to help users manage their daily habits efficiently. The app allows users to add, edit, delete, and mark habits as completed. The habits are stored in Firebase Firestore, and each user's data is securely managed with Firebase Authentication.

## Features

### 1. User Authentication
- **Sign Up:** Users can create a new account using their email and password.
- **Login:** Users can log in to the app with their credentials.
- **Logout:** Users can securely log out of the app.

### 2. Habit Management
- **Add Habit:** Users can add new habits. The habit is stored in Firestore with the current date and time when it was created.
- **Edit Habit:** Users can edit the name of existing habits.
- **Delete Habit:** Users can delete habits they no longer need.
- **Mark as Completed:** Users can mark a habit as completed or not completed.

### 3. Calendar View
- **Date Selection:** The app features a calendar where users can select a specific date to view the habits scheduled for that day.
- **Hide/Show Calendar:** The calendar can be toggled to show or hide by tapping an arrow button.

### 4. Dynamic Habit List
- **Filtered by Date:** The habits displayed in the list are filtered by the selected date.
- **No Habits Message:** If no habits are available for the selected date, a message "No habits" is displayed.

### 5. Responsive UI
- **Dialog Boxes:** Dialog boxes are provided for adding and editing habits.
- **Expandable Calendar:** The calendar view is collapsible and can be expanded or hidden based on user interaction.

## Usage

1. Clone or download the project to your local machine.
2. Open a terminal in the project's root directory.
3. Run `flutter pub get` to ensure all dependencies are installed.
4. Build the APK using `flutter build apk` or run on an emulator/device using `flutter run`.

## Contributing

Contributions to this project are welcome. Feel free to open issues or pull requests to enhance the functionality, fix bugs, or improve the user experience.

## License

This project is open-source and available under the [MIT License](LICENSE). You are free to use and modify the code for your purposes.