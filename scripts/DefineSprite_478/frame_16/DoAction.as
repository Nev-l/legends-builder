stop();
swapMenuSP.destroy();
swapItemSP.destroy();
var ptr = classes.GlobalData.getSelectedCarXML();
var currEngineTypeID = Number(ptr.attributes.et);
delete ptr;
var newEngineTypeID;
var newEngineID;
partDetail._visible = false;
partDetail.btnSelectPart._visible = false;
partDetail.btnTradeIn.onRelease = startTradeInPart;
partDetail.btnInstall.onRelease = startInstallPart;
partDetail.btnUninstall.onRelease = startUninstallPart;
partDetail.btnInstallTurbo.onRelease = function()
{
   var _loc2_ = classes.GlobalData.getSelectedCarXML();
   _root.getSystemParts(Number(_loc2_.attributes.i),2);
   newEngineTypeID = 2;
};
partDetail.btnInstallSuper.onRelease = function()
{
   var _loc2_ = classes.GlobalData.getSelectedCarXML();
   _root.getSystemParts(Number(_loc2_.attributes.i),3);
   newEngineTypeID = 3;
};
partDetail.btnUninstallTurbo.onRelease = partDetail.btnUninstallSuper.onRelease = function()
{
   var _loc2_ = classes.GlobalData.getSelectedCarXML();
   _root.getSystemParts(Number(_loc2_.attributes.i),1);
   newEngineTypeID = 1;
};
partDetail.btnSwapEngine.onRelease = function()
{
   _root.engineSwapStart(newEngineID);
   newEngineTypeID = -1;
};
var selPartXML;
if(partType == "Car Parts")
{
   var mb = new classes.GaragePartMenu(menuMC.shopMenu,_global.partCatXML,_global.partsBinXML,null,onPartClick);
   btnSellAll._visible = false;
}
else if(partType == "Spare Parts")
{
   var mb = new classes.GaragePartMenu(menuMC.shopMenu,_global.partCatXML,_global.partsBinXML,null,onPartClick);
   if(_global.partsBinXML.firstChild.childNodes.length)
   {
      btnSellAll._visible = true;
      btnSellAll.onRelease = function()
      {
         _root.getSparePrice();
      };
   }
   else
   {
      btnSellAll._visible = false;
   }
}
var tfPlain = new TextFormat();
tfPlain.bold = false;
