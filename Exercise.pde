//loads up activities - loadWorkout() //<>//
//workouts get harder - updateWorkout()
//

class Exercise extends RoutineBase
{
  Table state; //contains data on which workout I am doing today
  int todaysWorkout; //what workout are we doing today?
  Table workout; //where I load my data from

  Exercise(String _d, int _r, int _tHour, int _tMinute, int _aHour, int _aMinutes) 
  {
    //instanciate abstract base class
    super(_d, _r, _tHour, _tMinute, _aHour, _aMinutes);
    //load state .csv file
    state = loadTable("state.csv");
    //get todays workout number
    todaysWorkout = state.getInt(0, 0);
    //load exercise table
    workout = loadTable("workout_" + todaysWorkout + ".csv");
    //instanciate the arraylist of activities objects
    exercises = new ArrayList<Activity>();
    //load workout
    loadWorkout();
  }

  void loadWorkout()
  {
    
    for (int i = 0; i < workout.getRowCount(); i++) {
      
        String name = workout.getString(i, 1);
        boolean timed = boolean(workout.getString(i, 2));
        int sets = workout.getInt(i, 3);
        int reps = workout.getInt(i, 4);
        int max = workout.getInt(i, 5);
        println("    Exercise added: " + name + ", isTimed = " + timed);
        exercises.add(new Activity(name, timed, sets, reps, max));
      }
    }
  

  void updateTomorrowsWorkout()
  {
    //now update todays workout and set it to state.csv
    todaysWorkout++;
    //if greater than 3 (max amount of workouts) make 1.
    if (todaysWorkout > 3) todaysWorkout = 1;
    //save new state for tomorrow morning
    state.setInt(0, 0, todaysWorkout);
    //save changes   
    saveTable(state, "data/state.csv");
  }

  //update a singular exercise
  void updateExercise(boolean _tooHard)
  {
    if (_tooHard)
    {     
      if (boolean(workout.getString(index, 2)))
      {
        //if timed and too hard
        
        int oldTime = workout.getInt(index, 4);
        //add random amount to time
        int newTime = oldTime - int(random(1, 7));
        //if new time is greater than max allowed, newtime/3 & sets++
        if (newTime <= 0)
        {
          newTime = oldTime;
          int oldSets = workout.getInt(index, 3);
          if (oldSets > 0) {
            int newSets = oldSets - 1;
            workout.setInt(index, 3, newSets);
          } else {
            int newSets = 0;
            workout.setInt(index, 3, newSets);
          }   
        }
        workout.setInt(index, 4, newTime);
        println("set " + workout.getString(index, 1) + " from " + oldTime + " time to " + newTime);
      
      } else {
        //if reps and too hard
        
        int oldReps = workout.getInt(index, 4);
        //add random amount to time
        int newReps = oldReps - int(random(1, 3));
        //if new time is greater than max allowed, newtime/3 & sets++
        if (newReps <= 0)
        {
          newReps = oldReps;
          int oldSets = workout.getInt(index, 3);
          if (oldSets > 0) {
            int newSets = oldSets - 1;
            workout.setInt(index, 3, newSets);
          } else {
            int newSets = 0;
            workout.setInt(index, 3, newSets);
          }  
        }
        workout.setInt(index, 4, newReps);   
        println("set " + workout.getString(index, 1) + " from " + oldReps + " reps to " + newReps);
      }
          
    } else {
      if (boolean(workout.getString(index, 2)))
      {
        //if timed and too easy
    
        //get old time
        int oldTime = workout.getInt(index, 4); //<>//
        //add random amount to reps
        int newTime = oldTime + int(random(2, 7));
        //if new reps is greater than max allowed, new reps/3 & sets++
        if (newTime > workout.getInt(index, 5))
        {
          newTime = int(newTime / 3);
          int oldSets = workout.getInt(index, 3); //<>//
          int newSets = oldSets + 1;
          workout.setInt(index, 3, newSets);
        }
        workout.setInt(index, 4, newTime);
        println("set " + workout.getString(index, 1) + " from " + oldTime + " time to " + newTime);
    
      } else {
        //if reps and too easy
        //get old reps
        int oldReps = workout.getInt(index, 4); //<>//
        //add random amount to reps
        int newReps = oldReps + int(random(1, 3));
        //if new reps is greater than max allowed, new reps/3 & sets++
        if (newReps > workout.getInt(index, 5))
        {
          newReps = int(newReps / 3);
          int oldSets = workout.getInt(index, 3); //<>//
          int newSets = oldSets + 1;
          workout.setInt(index, 3, newSets);
        }
        workout.setInt(index, 4, newReps);
        println("set " + workout.getString(index, 1) + " from " + oldReps + " reps to " + newReps);
      }       
    }
    saveTable(workout, "data/workout_"+ todaysWorkout +".csv");
  }
  
  
  Boolean returnIsTimed()
  {
    Activity current = exercises.get(index);
    return current.isTimed;
  }

  String returnCurrent()
  {
    //get current exercise according to index
    Activity current = exercises.get(index);
    return current.name;
  }
  
  int returnReps()
  {
    Activity current = exercises.get(index);
    return current.reps;
  }
  
  int returnRoutineType()
  {
    return 1;
  }
}
