# kanban_ui

Flutter project to create a kanban board(Task tracking tool)

Root directory: kanban_ui/lib
   folder and its uses:
       1. main.dart -> entry point to application
       2. /bloc -> contains Bloc file, Event and state classes of app.
       3. /model -> contains all POJO classes
       4. /networking -> responsible for data fetching from network
       5. /repository -> handle the data from network and passes it to the bloc.
       6. /utils -> Utility classes
       7. /widget -> Widget classes

   To run:
        1. flutter run 
        
Additonal technical details:
   Flutter 3.7.0 
   Dart 2.19.0
        
Work flow steps:   
   1. Click Add board to create a board. If this is the "final board", select "Final status board" checkbox. We can create N number of boards.
   2. Once the board is created, We can add tasks to the board. 
   3. To create a Task, Type in "Add Task" text field and click "Add" button, now a dialog will popup, in which you can add necessary details about Task. 
   4. To move task from one board to another, long press a task and drag it to target board.
   5. To export data as CSV, click on "Export Csv" button on bottom right corner.

