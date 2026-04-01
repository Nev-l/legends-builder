stop();
swapMenuSP = new controls.ScrollPane(swapMenuHolder,148,200);
swapItemSP = new controls.ScrollPane(swapItemHolder,300,200);
partDetail._visible = partDetail.btnInstall._visible = partDetail.btnInstallTurbo._visible = partDetail.btnInstallSuper._visible = partDetail.btnUninstall._visible = partDetail.btnUninstallTurbo._visible = partDetail.btnUninstallSuper._visible = partDetail.btnSwapEngine._visible = partDetail.btnTradeIn._visible = false;
partDetail.txtTradeInPrice = "";
partDetail.fldName = "";
partDetail.fldDescription = "";
menuMC._visible = false;
partDetail.btnSelectPart._visible = true;
partDetail.btnSelectPart.onRelease = onSelectPart;
btnInstallSystem.onRelease = onInstallSystem;
btnBack.onRelease = function()
{
   this._parent.gotoAndStop("refresh");
};
if(newEngineTypeID == 1)
{
   if(currEngineTypeID == 2)
   {
      rightPane.icon.gotoAndStop("turbo");
      rightPane.title.text = "Uninstall Turbo (Install Headers)";
   }
   else
   {
      rightPane.icon.gotoAndStop("sc");
      rightPane.title.text = "Uninstall SC (Install Headers)";
   }
}
else if(newEngineTypeID == 2)
{
   rightPane.icon.gotoAndStop("turbo");
   rightPane.title.text = "Install Turbo";
}
else if(newEngineTypeID == 3)
{
   rightPane.icon.gotoAndStop("sc");
   rightPane.title.text = "Install Supercharger";
}
else if(newEngineTypeID == -1)
{
   rightPane.icon.gotoAndStop("engine");
   rightPane.title.text = "Engine Swap";
}
