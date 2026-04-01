class classes.Repair
{
   function Repair()
   {
   }
   static function formatDamageItem(pcid, damage, numCylinder, numValve)
   {
      trace("formatDamageItem: " + pcid + ", " + damage + ", " + numCylinder + ", " + numValve);
      var _loc5_ = new Object();
      _loc5_.title = "";
      _loc5_.description = "";
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      if(pcid == 45)
      {
         _loc6_ = damage / 100 * numValve;
         _loc7_ = "Valve";
         _loc8_ = true;
      }
      else if(pcid == 135)
      {
         _loc6_ = damage / 100 * numCylinder;
         _loc7_ = "Connecting Rod";
         _loc8_ = true;
      }
      else if(pcid == 44)
      {
         _loc6_ = damage / 100 * numCylinder;
         _loc7_ = "Piston";
         _loc8_ = true;
      }
      else if(pcid == 136)
      {
         _loc6_ = damage / 100;
         _loc7_ = "Head Gasket";
         _loc8_ = false;
      }
      else if(pcid == 39)
      {
         _loc6_ = damage / 100;
         _loc7_ = "Engine Block";
         _loc8_ = false;
      }
      else if(pcid == 154)
      {
         _loc6_ = damage / 100 * numValve;
         _loc7_ = "Apex Seal";
         _loc8_ = true;
      }
      else if(pcid == 156)
      {
         _loc6_ = damage / 100 * numCylinder;
         _loc7_ = "Rotor Housing";
         _loc8_ = true;
      }
      else if(pcid == 155)
      {
         _loc6_ = damage / 100 * numCylinder;
         _loc7_ = "Rotor";
         _loc8_ = true;
      }
      else if(pcid == 157)
      {
         _loc6_ = damage / 100;
         _loc7_ = "Corner and Side Seals";
         _loc8_ = false;
      }
      else if(pcid == 153)
      {
         _loc6_ = damage / 100;
         _loc7_ = "Engine Block";
         _loc8_ = false;
      }
      var _loc9_ = undefined;
      if(_loc6_ == 0)
      {
         if(_loc8_)
         {
            _loc5_.title = "Healthy " + _loc7_ + "s";
            _loc5_.description = "All " + _loc7_.toLowerCase() + "s are in good condition.";
         }
         else
         {
            _loc5_.title = "Healthy " + _loc7_;
            _loc5_.description = "The " + _loc7_.toLowerCase() + " is in good condition.";
         }
      }
      else if(_loc6_ < 0.5)
      {
         if(_loc8_)
         {
            _loc5_.title = "Stressed " + _loc7_ + "s";
            _loc5_.description = "1 " + _loc7_.toLowerCase() + " is showing signs of stress. It is not affecting your power, but might not last many more races.";
         }
         else
         {
            _loc5_.title = "Stressed " + _loc7_;
            _loc5_.description = "The " + _loc7_.toLowerCase() + " is showing signs of stress. It is not affecting your power, but might not last many more races.";
         }
      }
      else if(_loc6_ < 1)
      {
         if(_loc8_)
         {
            _loc5_.title = "Worn " + _loc7_ + "s";
            _loc5_.description = "1 " + _loc7_.toLowerCase() + " is very close to failing. It is not affecting your power yet, but it could fail while racing soon.";
         }
         else
         {
            _loc5_.title = "Worn " + _loc7_;
            _loc5_.description = "The " + _loc7_.toLowerCase() + " is very close to failing. It is not affecting your power yet, but it could fail while racing soon.";
         }
      }
      else if(_loc8_)
      {
         _loc9_ = Math.floor(_loc6_);
         if(_loc9_ == 1)
         {
            _loc5_.title = "Broken " + _loc7_;
            _loc5_.description = _loc9_ + " " + _loc7_.toLowerCase() + " has completely failed. It must be replaced for the engine to run correctly.";
         }
         else
         {
            _loc5_.title = "Broken " + _loc7_ + "s";
            _loc5_.description = _loc9_ + " " + _loc7_.toLowerCase() + "s have completely failed. They must be replaced for the engine to run correctly.";
         }
      }
      else
      {
         _loc5_.title = "Broken " + _loc7_;
         _loc5_.description = "The " + _loc7_.toLowerCase() + " has completely failed. It must be replaced for the engine to run correctly.";
      }
      return _loc5_;
   }
   static function showDamageList(txml)
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      var _loc4_ = "";
      var _loc5_ = Number(txml.attributes.p);
      var _loc6_ = Number(txml.attributes.v);
      if("35".indexOf(String(classes.GlobalData.role)) > -1)
      {
         _loc4_ += "Note: Members receive a more detailed report including repair prices.\r\r";
      }
      var _loc7_ = 0;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      while(_loc7_ < txml.childNodes.length)
      {
         _loc8_ = txml.childNodes[_loc7_];
         if(Number(_loc8_.attributes.ci) != 102)
         {
            _loc9_ = Number(_loc8_.attributes.d);
            if(_loc9_)
            {
               _loc10_ = classes.Repair.formatDamageItem(Number(_loc8_.attributes.ci),_loc9_,_loc5_,_loc6_);
               _loc11_ = Number(_loc8_.attributes.p);
               _loc12_ = Number(_loc8_.attributes.pp);
               _loc4_ += _loc10_.title + "\r";
               if("1246".indexOf(String(classes.GlobalData.role)) > -1)
               {
                  _loc4_ += _loc10_.description + "\r";
                  _loc4_ += "Repair cost: $" + _loc11_ + "\r\r";
               }
               _loc2_ += _loc11_;
               _loc3_ += _loc12_;
            }
         }
         _loc7_ += 1;
      }
      if("1246".indexOf(String(classes.GlobalData.role)) > -1)
      {
         _loc4_ += "Total repair cost: $" + _loc2_ + "\r";
      }
      classes.Control.dialogTextBlob("Damage Report",_loc4_,"shop");
   }
}
