function onShopPartClick(pid)
{
   mb.hidePanel();
   delete selPartXML;
   var _loc2_ = 0;
   while(_loc2_ < licCatXML.firstChild.childNodes.length)
   {
      if(licCatXML.firstChild.childNodes[_loc2_].attributes.i == pid)
      {
         selPartXML = licCatXML.firstChild.childNodes[_loc2_];
         break;
      }
      _loc2_ += 1;
   }
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   if(selPartXML != undefined)
   {
      partDetail.txtName = selPartXML.attributes.n;
      if(selPartXML.attributes.i == 0)
      {
         showPlate(cs.plateID,cs.lic);
         customPlateForm.plateID = cs.plateID;
         _loc3_ = cs.lic.split("_");
         customPlateForm.seq1 = _loc3_[0];
         customPlateForm.seq2 = _loc3_[1];
         customPlateForm.seq3 = _loc3_[2];
         if(cs.plateID <= 4)
         {
            customPlateForm.gotoAndStop("usa");
         }
         else if(cs.plateID <= 7)
         {
            customPlateForm.gotoAndStop("japan");
         }
         else if(cs.plateID <= 10)
         {
            customPlateForm.gotoAndStop("euro" + cs.plateID);
         }
         customPlateForm._visible = true;
         partDetail.priceGroup.togBuy.onRelease = function()
         {
            startBuyPlateNumber("m");
         };
         partDetail.pointsGroup.togBuy.onRelease = function()
         {
            startBuyPlateNumber("p");
         };
         partDetail.txtDescription = "You are purchasing a custom license plate number.\r\rNote: Some custom numbers may already be taken. Number sequences are only unique to each license plate style, i.e., the same number sequence might be found on two different plate styles.";
         licCatXML.parseXML(licCatXML);
         _loc4_ = licCatXML.idMap[cs.plateID];
         trace("CUSTNODE: " + _loc4_);
         partDetail.priceGroup.txtPrice = "$" + classes.NumFuncs.commaFormat(_loc4_.attributes.vm);
         partDetail.pointsGroup.txtPoints = classes.NumFuncs.commaFormat(_loc4_.attributes.vp);
      }
      else
      {
         customPlateForm._visible = false;
         showPlate(selPartXML.attributes.di,classes.Lookup.samplePlateNumber(Number(selPartXML.attributes.di)));
         partDetail.priceGroup.togBuy.onRelease = function()
         {
            startBuyPlate("m");
         };
         partDetail.pointsGroup.togBuy.onRelease = function()
         {
            startBuyPlate("p");
         };
         partDetail.txtDescription = "When you purchase a new plate style, your old plate number will not carry over to the new plate. A new plate number will be automatically generated for you.\r\rNote: The number displayed on the plate above is for illustration purposes only. The actual number will be randomly generated.";
         partDetail.priceGroup.txtPrice = "$" + classes.NumFuncs.commaFormat(selPartXML.attributes.p);
         partDetail.pointsGroup.txtPoints = classes.NumFuncs.commaFormat(selPartXML.attributes.pp);
      }
      partDetail.fldDescription.setTextFormat(tfPlain);
      partDetail._visible = true;
   }
   else
   {
      partDetail._visible = false;
   }
}
function showPlate(pid, seq)
{
   if(pid >= 8 && pid <= 10)
   {
      classes.Drawing.plateView(partImg,pid,seq,56,true);
      partImg._y = 430;
   }
   else
   {
      classes.Drawing.plateView(partImg,pid,seq,100,true);
      partImg._y = 370;
   }
   var _loc3_ = new Object();
   _loc3_.cs = new classes.CarSpecs();
   _loc3_.cs.applyCarXML(selectedCarXML);
   _loc3_.cs.plateID = pid;
   _loc3_.cs.lic = seq;
   _loc3_.carID = carID;
   classes.Drawing.carView(image_mc,selectedCarXML,100,"back",_loc3_);
}
function startBuyPlate(paymentType)
{
   trace("startBuyPlate: " + paymentType);
   _root.buyPlate(Number(selectedCarXML.firstChild.attributes.i),Number(selPartXML.attributes.di),"m");
}
function installCartPlate(newseq)
{
   trace("installCartPlate");
   var _loc2_ = classes.GlobalData.getSelectedCarXML();
   _loc2_.attributes.pi = Number(selPartXML.attributes.di);
   _loc2_.attributes.pn = newseq;
   trace(classes.GlobalData.getSelectedCarXML());
   clearCart();
}
function startBuyPlateNumber(paymentType)
{
   trace("startBuyPlateNumber: " + paymentType);
   var _loc3_ = "";
   if(customPlateForm.seq1.length)
   {
      _loc3_ += customPlateForm.seq1;
   }
   if(customPlateForm.seq2.length)
   {
      _loc3_ += "_" + customPlateForm.seq2;
   }
   if(customPlateForm.seq3.length)
   {
      _loc3_ += "_" + customPlateForm.seq3;
   }
   if(_loc3_.length)
   {
      _root.buyVanity(Number(selectedCarXML.firstChild.attributes.i),_loc3_,paymentType);
   }
   else
   {
      _root.displayAlert("warning","No Plate Number","Please enter a custom plate number.");
   }
}
function installCartPlateNumber()
{
   trace("installCartPlateNumber");
   var _loc1_ = "";
   if(customPlateForm.seq1.length)
   {
      _loc1_ += customPlateForm.seq1;
   }
   if(customPlateForm.seq2.length)
   {
      _loc1_ += "_" + customPlateForm.seq2;
   }
   if(customPlateForm.seq3.length)
   {
      _loc1_ += "_" + customPlateForm.seq3;
   }
   classes.GlobalData.getSelectedCarXML().attributes.pn = _loc1_;
   trace(classes.GlobalData.getSelectedCarXML());
   clearCart();
}
function clearCart()
{
   delete selPartXML;
   gotoAndStop("retrieve");
   play();
}
function afterDialogSelectCar()
{
   _parent.sectionName = "licenses";
   _parent.locationID = locationID;
   _parent.gotoAndPlay(1);
}
