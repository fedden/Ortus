class Activity {

  String name;
  Boolean isTimed;
  int sets;
  int reps; //if not timed this is used
  int secs; //if timed this is used;
  int maxReps;
  int maxSecs;
  Boolean isDone; //have I done this exercise?

  Activity(String _name, Boolean _timed, int _sets, int _secsOrReps, int _maxRepsOrMaxSets)
  {
    //i haven't done this yet!
    isDone = false;
    //descriptor
    name = _name;
    //tiemd or reps?
    isTimed = _timed;
    //amount of sets
    sets = _sets;
    //if exercise is a timed one fill correct fields else fill repition fields
    if (isTimed)
    {
      secs = _secsOrReps;
      maxSecs = _maxRepsOrMaxSets;
    } else {
      reps = _secsOrReps;
      maxReps = _maxRepsOrMaxSets;
    }
  }
  
  void display()
  {
    println("Exercise: " + name + ", Timed: " + isTimed + ", Sets: " + sets);
  }
}
