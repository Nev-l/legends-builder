_global.sectionClassifiedMC = this;
var searchCarID = 0;
var searchEngineID = 0;
var searchPage = 1;
if(classes.GlobalData.onUpdateCars)
{
   classes.GlobalData.onUpdateCars();
   classes.Control.dialogAlert("Garage Updated!","Your garage has been updated from recent sales or trades.",undefined,"key",true);
}
