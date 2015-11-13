/*
- Load up syllabus.csv
- Load up current state (current module) from state.csv
- Load current module
- API to update state (if user finishes task)
- Needs to handle hyperlinks - link() will work!
*/

class Syllabus extends RoutineBase 
{
  
  String currentModule; //current module title
  String hyperlink; //link to module webpage etc.
  String subject;
  Table modules; 
  
  Syllabus(String _d, int _r, int _tHour, int _tMinute, int _aHour, int _aMinutes)
  {
    super(_d, _r, _tHour, _tMinute, _aHour, _aMinutes);
    moduleNo = 0;
    currentModule = hyperlink = "";
    
  }
  
  void loadCurrentModule(String _arg)
  {
    //first load syllabus
    modules = loadTable(_arg);
    subject = _arg;
    //loop through and count rows until we get to unfinished row
    for (int i = 0; i < modules.getRowCount(); i++)
    {
      if (boolean(modules.getString(i,2)))
      {
        moduleNo++;
      }
    }
    if (moduleNo > modules.getRowCount() - 1) moduleNo = 0;
    //next set variables at unfinished rows
    currentModule = modules.getString(moduleNo, 0);
    
    hyperlink = modules.getString(moduleNo, 1);
    println("      " + hyperlink);
  }
  
  //this is called if user reports they have finished the module
  void updateCurrentModule()
  { 
    modules.setString(moduleNo, 2, "true");
    saveTable(modules, "data/"+subject);
  }
  
  String returnCurrent()
  {
    return currentModule;
  }
  
  String returnHyperlink()
  {
    println(hyperlink);
    return hyperlink;
  }
  
  int returnRoutineType()
  {
    return 2;
  }
  
}
