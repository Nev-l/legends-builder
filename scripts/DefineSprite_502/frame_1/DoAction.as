function getSelCarInfo()
{
   var _loc2_ = classes.GlobalData.getSelectedCarXML();
   if(_loc2_ == undefined && _global.garageXML != undefined && _global.garageXML.firstChild != undefined && _global.garageXML.firstChild.childNodes.length > 0)
   {
      _loc2_ = _global.garageXML.firstChild.childNodes[0];
      classes.GlobalData.setSelectedCar(_loc2_.attributes.i);
   }
   if(_loc2_ == undefined)
   {
      trace("garage selected car missing");
      return undefined;
   }
   carXML = new XML(_loc2_.toString());
   if(carXML.firstChild == undefined)
   {
      trace("garage selected car xml missing");
      return undefined;
   }
   accountCarID = Number(carXML.firstChild.attributes.i);
   carID = carXML.firstChild.attributes.ci;
   if(carID == undefined || carID == "")
   {
      carID = 1;
      carXML.firstChild.attributes.ci = carID;
   }
   lic = carXML.firstChild.attributes.pn;
   if(lic == undefined || lic == "")
   {
      lic = "01_ABC_23";
   }
   plateID = carXML.firstChild.attributes.pi;
   if(plateID == undefined || plateID == "")
   {
      plateID = 1;
   }
   logo.loadMovie("cache/car/logo_" + carID + ".swf");
   plateLoader.loadClip("cache/car/plates.swf",plate);
   navToGarage();
}
function navToGarage()
{
   if(classes.GlobalData.doesCarHaveDiagnosticToolInstalled() == true)
   {
      trace("show it");
      leftMenu.btnDiagnosticTool._visible = true;
      leftMenu.btnDiagnosticsDisplay._visible = true;
   }
   else
   {
      trace("hide it");
      leftMenu.btnDiagnosticTool._visible = false;
      leftMenu.btnDiagnosticsDisplay._visible = false;
   }
   dtHolder.removeMovieClip();
   leftMenu._visible = true;
   btnSpareParts.gotoAndStop("off");
   carMC._visible = true;
   front_back._visible = true;
   if(front_back.__garageShift != true)
   {
      front_back._x -= 18;
      front_back.__garageShift = true;
   }
   if(btnSpareParts.__garageShift != true)
   {
      btnSpareParts._x += 10;
      btnSpareParts.__garageShift = true;
   }
   front_back.swapDepths(this.getNextHighestDepth());
   logo._visible = true;
   plate._visible = true;
   partBack._visible = false;
   partMenu._visible = false;
}
function navToCarParts()
{
   trace("this: " + this);
   leftMenu._visible = false;
   btnSpareParts.gotoAndStop("off");
   carMC._visible = true;
   front_back._visible = true;
   logo._visible = false;
   plate._visible = false;
   partBack._visible = true;
   partMenu._visible = true;
   partMenu.partType = "Car Parts";
   partMenu.gotoAndPlay("retrieve");
}
function navToSpareParts()
{
   dtHolder.removeMovieClip();
   leftMenu._visible = false;
   btnSpareParts.gotoAndStop("on");
   carMC._visible = false;
   front_back._visible = false;
   logo._visible = false;
   plate._visible = false;
   partBack._visible = false;
   partMenu._visible = true;
   partMenu.partType = "Spare Parts";
   partMenu.gotoAndPlay("retrieve");
}
function navToDiagnosticTool()
{
   carXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
   leftMenu._visible = false;
   accountCarID = Number(carXML.firstChild.attributes.i);
   trace("this!");
   trace(this);
   front_back._visible = false;
   classes.Lookup.addCallback("getInstalledEngineParts",this,loadTuningDiagnosticTool,"");
   _root.getInstalledEngineParts(accountCarID);
}
function loadTuningDiagnosticTool(diagnosticXML)
{
   loadThisFile = "cache/misc/dt.swf";
   trace("load tuning diagnostic tool");
   trace(this);
   this.dtHolder.removeMovieClip();
   this.createEmptyMovieClip("dtHolder",this.getNextHighestDepth());
   dtHolder._x = 1;
   dtHolder._y = 88;
   trace(diagnosticXML);
   dtHolder.diagnosticXML = diagnosticXML;
   var _loc2_ = new Object();
   _loc2_.onLoadInit = function(target_mc)
   {
      trace("dt.swf loaded");
      target_mc.tuningDiagnosticTool._visible = true;
      trace(diagnosticXML);
      target_mc.tuningDiagnosticTool.init(diagnosticXML);
      delete dt_mcl;
      delete mclListener;
   };
   _loc2_.onLoadError = function(target_mc)
   {
      _root.displayAlert("warning","Missing Files","A file is missing from your cache folder:\r\r" + loadThisFile + "\r\rThe game will not function without this file.  Please close the game and re-install it by running the original installer.  Or you can download the latest installer at www.NittoLegends.com.  Note: Re-installing will not affect your account in any way.  You may continue to use your existing account.");
   };
   var _loc3_ = new MovieClipLoader();
   _loc3_.addListener(_loc2_);
   _loc3_.loadClip(loadThisFile,dtHolder);
}
function refreshGarage()
{
   carMC.clearCarView();
   classes.ClipFuncs.removeAllClips(carMC);
   carMC.removeMovieClip();
   carPicker.removeMovieClip();
   this.gotoAndPlay(1);
}
function redrawCar(tempPartXML)
{
   var _loc2_ = new XML(tempPartXML.toString());
   carXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   if(tempPartXML)
   {
      _loc3_ = Number(_loc2_.firstChild.attributes.pi);
      _loc4_ = 0;
      if(_loc3_ == 148 || _loc3_ == 149 || _loc3_ == 150 || _loc3_ == 151)
      {
         _loc4_ = 12;
      }
      else if(_loc3_ == 160 || _loc3_ == 161 || _loc3_ == 162 || _loc3_ == 163)
      {
         _loc4_ = -12;
      }
      _loc5_ = carXML.firstChild.childNodes.length - 1;
      if(_loc5_ || _loc5_ === 0)
      {
         _loc6_ = _loc5_;
         while(_loc6_ >= 0)
         {
            if(carXML.firstChild.childNodes[_loc6_].attributes.ci == _loc3_ || carXML.firstChild.childNodes[_loc6_].attributes.ci == _loc3_ + _loc4_)
            {
               carXML.firstChild.childNodes[_loc6_].removeNode();
            }
            _loc6_ -= 1;
         }
      }
      _loc2_.firstChild.attributes["in"] = 1;
      _loc2_.firstChild.attributes.ci = _loc2_.firstChild.attributes.pi;
      trace("onPartClick show...");
      trace(_loc2_);
      carXML.firstChild.appendChild(_loc2_.firstChild);
   }
   carMC.clearCarView();
   classes.ClipFuncs.removeAllClips(carMC);
   var _loc7_ = "front";
   if(isBack)
   {
      _loc7_ = "back";
   }
   gotoAndPlay(_loc7_);
}
function checkLockedMsg()
{
   usedCarMsg._visible = false;
   expiredMsg._visible = false;
   trace("checkLockedMsg");
   trace(Number(carXML.firstChild.attributes.td));
   trace(Number(carXML.firstChild.attributes.tdex));
   if(Number(carXML.firstChild.attributes.lk))
   {
      usedCarMsg._visible = true;
   }
   else if(Number(carXML.firstChild.attributes.td) == 1 && Number(carXML.firstChild.attributes.tdex) == 1)
   {
      expiredMsg._visible = true;
      expiredMsg.txt = "Your test drive has expired";
   }
   else if(Number(carXML.firstChild.attributes.td) == 1)
   {
      expiredMsg._visible = true;
      expiredMsg.txt = "You have " + carXML.firstChild.attributes.rh + " hours left in your test drive ";
   }
   else
   {
      usedCarMsg._visible = false;
   }
}
