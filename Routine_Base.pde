abstract class RoutineBase
{
  String descriptor; //whats the task called?
  int routineNumber; //which routine does it belong to?
  int targetHour; //the hour this should happen
  int targetMinute; //the minute this should happen
  int allowedHours; //how many hours do I have to do this?
  int allowedMinutes; //how many minutes do I have to do this?
  int moduleNo;
  boolean isDone; //did I do this?
  ArrayList<Activity> exercises;
  int index;
  
  RoutineBase(String _d, int _r, int _tHour, int _tMinute, int _aHour, int _aMinutes)
  {
    descriptor = _d;
    routineNumber = _r;
    isDone = false;
    targetHour = _tHour;
    targetMinute = _tMinute;
    allowedHours = _aHour;
    allowedMinutes = _aMinutes;
  }
  
  abstract String returnCurrent(); //abstract method to be filled out in each derived class
  
  abstract int returnRoutineType(); //returns 0-2 depending on derived class
  
  void updateCurrentModule() {}
  void loadCurrentModule(String _arg) {}
  
  int returnReps() {
    return 0;
  }
  
  String returnHyperlink() {
    return "HyperLINK: error using non-derived function";
  }
  
  void updateExercise(boolean _tooHard)
  {
    println("EVERCISE: error using non-derived function");
  }
  
  void updateTomorrowsWorkout() {}
  
  
}
