stop();
sc = _parent._parent.sc;
classes.SCDial.setSCDial(scDial,sc);
scDial.fldLevel._visible = false;
var i = 0;
while(i < _global.scLevelsXML.firstChild.childNodes.length)
{
   var tier = Number(_global.scLevelsXML.firstChild.childNodes[i].attributes.sc);
   if(sc < tier)
   {
      var btm = Number(_global.scLevelsXML.firstChild.childNodes[i - 1].attributes.sc);
      if(!btm)
      {
         btm = 0;
      }
      var frac = (sc - btm) / (tier - btm);
      var xpos = this["seg" + i]._x + frac * this["seg" + i]._width;
      txtDescr = _global.scLevelsXML.firstChild.childNodes[i].attributes.id;
      var filter = new flash.filters.GlowFilter(Number("0x" + _global.scLevelsXML.firstChild.childNodes[i].attributes.c),75,3,3,3,3);
      var filterArray = new Array();
      filterArray.push(filter);
      gauge.filters = filterArray;
      gauge._width = xpos - gauge._x;
      if(_global.scLevelsXML.firstChild.childNodes[i].childNodes.length)
      {
         j = 0;
         while(j < _global.scLevelsXML.firstChild.childNodes[i].childNodes.length)
         {
            var jTier = Number(_global.scLevelsXML.firstChild.childNodes[i].childNodes[j].attributes.sc);
            if(sc < jTier)
            {
               txtDescr += ", " + _global.scLevelsXML.firstChild.childNodes[i].childNodes[j].attributes.id;
               txtDescr2 = jTier - sc + " SC to the next stage.";
               break;
            }
            j++;
         }
         break;
      }
      var jTier = Number(_global.scLevelsXML.firstChild.childNodes[i].attributes.sc);
      if(sc < jTier && i < _global.scLevelsXML.firstChild.childNodes.length - 1)
      {
         txtDescr2 = jTier - sc + " SC to the next stage.";
      }
      break;
   }
   i++;
}
