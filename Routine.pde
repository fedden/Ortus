class Routine {
  int restLength = 30;
  int routineLength; //length of routine
  int currentIndex; //current job
  int currentSet; //current set
  int maxSet; //maximum sets
  int minuteStarted; //when i started the job
  boolean isDone; //if true, user has finished routine
  boolean rest; //if true time to rest //<>//

  Timer timer; //timer help iterate through routine
  Timer exerciseTimer; //timer occasionally used for exercises
  Timer restTimer; //timer to rest between sets
  Table routine; //routine data
  RoutineBase[] subroutines; //array of routineBase jobs
  Button loadLink, hard, okay, easy, doneButton, completed, notCompleted, ready;

  Routine()
  {
    currentSet = 1;
    //we are not done yet
    isDone = false;
    //no rest for the wicked
    rest = false;
    //we start on the first job
    currentIndex = 0;
    //load routine data
    routine = loadTable("routine.csv"); 
    //get length of routine
    routineLength = routine.getRowCount();

    //length of array = amount of rows in data
    subroutines = new RoutineBase[routineLength];
    //load routine into array
    loadRoutine();
    //timer is initilised to first
    timer = new Timer(subroutines[currentIndex].allowedMinutes, 0);
    timer.start();
    //exercise timer is initilised to 0:0 until the time is changed
    exerciseTimer = new Timer(0, 0);
    restTimer = new Timer(0, restLength); //should be 30

    //exercise button

    hard = new Button("Too Hard", width/4 - 26, height-100, 160, 70, 5, 2);
    hard.setColours(red, red, red, black, black);

    okay = new Button("Okay", width/2, height-100, 160, 70, 5, 2);
    okay.setColours(neutral, neutral, neutral, black, black);

    easy = new Button("Too Easy", 3*width/4 + 26, height-100, 160, 70, 5, 2);
    easy.setColours(green, green, green, black, black);

    //quick job button

    doneButton = new Button("Done", width/2, height-100, 160, 70, 5, 2);
    doneButton.setColours(green, green, green, black, black);

    //syllabus buttons

    loadLink = new Button("Load Link", width/2, height-100, 160, 70, 5, 2);
    loadLink.setColours(neutral, neutral, neutral, black, black);

    completed = new Button("Completed", 3*width/4 + 26, height-100, 160, 70, 5, 2);
    completed.setColours(green, green, green, black, black);

    notCompleted = new Button("Not Completed", width/4 - 26, height-100, 160, 70, 5, 2);
    notCompleted.setColours(red, red, red, black, black);
    
    ready = new Button("Done", width/2, height-100, 160, 70, 5, 2);
    ready.setColours(green, green, green, black, black);
  } 


  void loadRoutine()
  {
    for (int i = 0; i < routineLength; i++)
    {
      //get current row
      TableRow currentRow = routine.getRow(i);
      //next get all fields on row
      int routineNo = currentRow.getInt(0);
      int targetHour = currentRow.getInt(1);
      int targetMinute = currentRow.getInt(2);
      int allowedHour = currentRow.getInt(3);
      int allowedMinute = currentRow.getInt(4);
      String descriptor = currentRow.getString(5);
      int routineType = currentRow.getInt(6);

      //add correct object to array
      switch (routineType)
      {
      case 0:
        //quick job
        subroutines[i] = new QuickJob(descriptor, routineNo, targetHour, targetMinute, allowedHour, allowedMinute);
        println("New Quick Job, index = " + i + ", descriptor = " + descriptor + ", routine number = " + routineNo + ", target hour = " + targetHour + ", target minute = " + targetMinute + ", allowed hour = " + allowedHour + ", allowed minute = " + allowedMinute); 
        break;
      case 1:
        //exercise
        subroutines[i] = new Exercise(descriptor, routineNo, targetHour, targetMinute, allowedHour, allowedMinute);
        println("New Exercise, index = " + i + ", descriptor = " + descriptor + ", routine number = " + routineNo + ", target hour = " + targetHour + ", target minute = " + targetMinute + ", allowed hour = " + allowedHour + ", allowed minute = " + allowedMinute); 
        break;
      case 2:
        //syllabus
        subroutines[i] = new Syllabus(descriptor, routineNo, targetHour, targetMinute, allowedHour, allowedMinute);
        println("New Syllabus, index = " + i + ", descriptor = " + descriptor + ", routine number = " + routineNo + ", target hour = " + targetHour + ", target minute = " + targetMinute + ", allowed hour = " + allowedHour + ", allowed minute = " + allowedMinute); 
        break;
      }
    }
  }

  void doneButtonPressed()
  {
    //preload some shit with a safety to prevent array index out of bounds error
    if (currentIndex < routineLength - 1) {
      if (subroutines[currentIndex + 1].returnRoutineType() == 2)
      {   
        //get subroutine descriptor - this is our current syllabus - i.e coding modules, german modules
        String currentSyllabus = subroutines[currentIndex+1].descriptor + ".csv";

        //load current modules
        subroutines[currentIndex+1].loadCurrentModule(currentSyllabus);
        println(currentSyllabus);
      }
    
    }

    //if quick job
    if (subroutines[currentIndex].returnRoutineType() == 0)
    {
      subroutines[currentIndex].isDone = true;
    }

    //if exercise, increment index by one
    else if (subroutines[currentIndex].returnRoutineType() == 1) 
    { 

      restTimer.changeLength(0, restLength);
      rest = true;
      restTimer.start();

      //if current set equals max set
      if (currentSet == maxSet) {
        
        //if exercises index < length of exercises arraylist size
        if (subroutines[currentIndex].exercises.size() - 1 > subroutines[currentIndex].index)
        {
          //increment exercises index
          subroutines[currentIndex].index++;
          currentSet = 1;
        } else {
          //done
          /*
             I NEED TO UPDATE 'TODAYS' WORKOUT HERE
           */
          subroutines[currentIndex].updateTomorrowsWorkout();
          subroutines[currentIndex].isDone = true;
        }
      } else {
        println("incrementing set");
        currentSet++;
        exerciseTimer.on = false;
      }
    }


    //if syllabus
    else if (subroutines[currentIndex].returnRoutineType() == 2)
    {   
      //if new button pressed we have finished
      subroutines[currentIndex].isDone = true;
    }

    //if current task is less than max (prevent array index out of bounds error) and task isDone bool = true
    if ((currentIndex < routineLength-1) && (subroutines[currentIndex].isDone)) {
      //increment index
      currentIndex++;
      //set new timer and start it
      timer.changeLength(subroutines[currentIndex].allowedMinutes, 0);
      timer.start();
    } else if ((currentIndex == routineLength - 1) && (subroutines[currentIndex].isDone)) {
      //we got to the end of routine so we are done!
      isDone = true;
      exit(); //quit - we are done!
    }
  }

  void updateExercise(int _difficulty)
  {
    //depending on which button the user pressed we update the exercise accordingly
    switch (_difficulty)
    {
    case 0:
      //too hard
      subroutines[currentIndex].updateExercise(true);
      break;

    case 1:
      //too easy
      subroutines[currentIndex].updateExercise(false);
      break;
    }
  }

  //run processes like timer update
  void run()
  {
    timer.update();
    //if past waking up then alarm song = stop
    if (currentIndex > 0) alarm.stop();
  }

  //String late()
  //{


  //  int lateness = abs(start - subroutines[currentIndex].targetMinute);

  //  return "You are " + lateness + " minutes behind";
  //}

  void display()
  {
    switch(subroutines[currentIndex].returnRoutineType())
    {
    case 0:   

      //quick job

      fill(neutral);
      textAlign(CENTER);
      textSize(16);    
      text("Current Task: " + subroutines[currentIndex].descriptor, width/2, 50+8);
      doneButton.display();
      textSize(300);  
      fill(black, alpha);
      text(timer.timeLeft(), width/2, height/3 + 200);
      textSize(30);
      fill(black);
      text(subroutines[currentIndex].returnCurrent(), width/2, height/2);
      break;

    case 1:

      //exercise

      fill(neutral);
      textAlign(CENTER);
      textSize(16);    
      text("Current Task: " + subroutines[currentIndex].descriptor, width/2, 25+8);
      
      text("Time Left: " + timer.timeLeft(), width/2, 50+8);
      
             if ((subroutines[currentIndex].exercises.size() - 2 > subroutines[currentIndex].index) && (maxSet == currentSet) && (!rest))
      {
        Activity next = subroutines[currentIndex].exercises.get(subroutines[currentIndex].index + 1);
        text("Next Exercise: " + next.name , width/2, 75+8);
        
      } else if ((subroutines[currentIndex].exercises.size() - 2 > subroutines[currentIndex].index) && (maxSet != currentSet) && (!rest))
      {
        Activity current = subroutines[currentIndex].exercises.get(subroutines[currentIndex].index);
        text("Next Exercise: " + current.name , width/2, 75+8);
        
      } else if ((subroutines[currentIndex].exercises.size() - 2 > subroutines[currentIndex].index) && (maxSet == currentSet) && (rest))
      {
        Activity next = subroutines[currentIndex].exercises.get(subroutines[currentIndex].index);
        text("Next Exercise: " + next.name , width/2, 75+8);
        
      } else if ((subroutines[currentIndex].exercises.size() - 2 > subroutines[currentIndex].index) && (maxSet != currentSet) && (rest))
      {
        Activity current = subroutines[currentIndex].exercises.get(subroutines[currentIndex].index);
        text("Next Exercise: " + current.name , width/2, 75+8);
        
      }
      
      if (rest) 
      {
        textSize(300);  
        fill(black, alpha);
        restTimer.update();        
        text(restTimer.timeLeft(), width/2, height/3 + 200);
        textSize(30);
        fill(black);
        text("Rest", width/2, height/2);
        ready.display();
      } else {
        Activity current = subroutines[currentIndex].exercises.get(subroutines[currentIndex].index);
        maxSet = current.sets;

        hard.display();
        okay.display();
        easy.display();

        //exercise
        textSize(30);
        fill(black, alpha);
        text("Set " + currentSet + " of " + maxSet, width/8 + 15, height/2-170);
        fill(black);
        text(subroutines[currentIndex].returnCurrent(), width/2, height/2);      
        if (current.isTimed)
        {
          if (exerciseTimer.on == false) {
            //insert second based timer here!
            //we have to convert a stack of seconds into minutes and seconds from the current activity

            //firstly get amount of minutes by dividing seconds by 60
            int exerciseMinutes = floor(current.secs / 60);
            //secondly get remainder of seconds using the modulus of 60
            int exerciseSeconds = current.secs % 60;
            //change exercisie timer time
            exerciseTimer.changeLength(exerciseMinutes, exerciseSeconds);
            println("exercise timer length set to: " + exerciseMinutes + " mins, " + exerciseSeconds + " secs.");
            exerciseTimer.start();
          }
          exerciseTimer.update();
          //timer text should go here
          textSize(300);  
          fill(black, alpha);         
          text(exerciseTimer.timeLeft(), width/2, height/3 + 200);
        } else {
          textSize(200);  
          fill(black, alpha);         
          text("Reps: " + subroutines[currentIndex].returnReps(), width/2, height/3 + 175);
        }
      }
      break;

    case 2:

      //syllabus

      fill(neutral);
      textAlign(CENTER);
      textSize(16);    
      text("Current Task: " + subroutines[currentIndex].descriptor, width/2, 50+8);

      completed.display();
      notCompleted.display();
      loadLink.display();

      textSize(300);  
      fill(black, alpha);
      text(timer.timeLeft(), width/2, height/3 + 200);
      textSize(30);
      fill(black);
      //syllabus

      text(subroutines[currentIndex].descriptor, width/2, height/2);

      break;
    }
  }
}
