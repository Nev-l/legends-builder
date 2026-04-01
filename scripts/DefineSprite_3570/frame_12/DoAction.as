stop();
roomListXML = _global.chatRoomListXML;
var vSpace = 23;
var i = 0;
while(i < roomListXML.firstChild.childNodes.length)
{
   if(i != 0)
   {
      listGroup.scrollContent.item0.duplicateMovieClip("item" + i,i);
   }
   listGroup.scrollContent["item" + i].txtName = roomListXML.firstChild.childNodes[i].attributes.rn;
   listGroup.scrollContent["item" + i].txtCount = roomListXML.firstChild.childNodes[i].attributes.rc;
   listGroup.scrollContent["item" + i].cid = roomListXML.firstChild.childNodes[i].attributes.cid;
   listGroup.scrollContent["item" + i].cy = roomListXML.firstChild.childNodes[i].attributes.cy;
   listGroup.scrollContent["item" + i].rt = roomListXML.firstChild.childNodes[i].attributes.rt;
   listGroup.scrollContent["item" + i].rn = roomListXML.firstChild.childNodes[i].attributes.rn;
   listGroup.scrollContent["item" + i].ip = roomListXML.firstChild.childNodes[i].attributes.ip;
   listGroup.scrollContent["item" + i].mo = roomListXML.firstChild.childNodes[i].attributes.mo;
   listGroup.scrollContent["item" + i].sm = roomListXML.firstChild.childNodes[i].attributes.sm;
   listGroup.scrollContent["item" + i].hi._visible = false;
   if(roomListXML.firstChild.childNodes[i].attributes.mo == "1")
   {
      listGroup.scrollContent["item" + i].membersIcon._visible = true;
   }
   else
   {
      listGroup.scrollContent["item" + i].membersIcon._visible = false;
   }
   if(roomListXML.firstChild.childNodes[i].attributes.ip == "1")
   {
      listGroup.scrollContent["item" + i].lockIcon._visible = true;
      listGroup.scrollContent["item" + i].membersIcon._visible = false;
   }
   else
   {
      listGroup.scrollContent["item" + i].lockIcon._visible = false;
   }
   listGroup.scrollContent["item" + i]._y = i * vSpace;
   listGroup.scrollContent["item" + i].bg.onRollOver = function()
   {
      this._parent.hi._visible = true;
   };
   listGroup.scrollContent["item" + i].bg.onRollOut = function()
   {
      this._parent.hi._visible = false;
   };
   listGroup.scrollContent["item" + i].bg.onRelease = function()
   {
      trace("tracing sm: ");
      trace(this._parent.sm);
      classes.SectionModElection.MC.enterRaceRoom(this._parent.cid,this._parent.cy,this._parent.rt,this._parent.rn,this._parent.ip,this._parent.mo,0);
   };
   if(classes.GlobalData.attr.r != 1 && classes.GlobalData.attr.r != 2 && classes.GlobalData.attr.r != 8)
   {
      listGroup.scrollContent["item" + i].btnInvisible._visible = false;
   }
   else
   {
      listGroup.scrollContent["item" + i].btnInvisible.onRelease = function()
      {
         classes.SectionModElection.MC.enterRaceRoom(this._parent.cid,this._parent.cy,this._parent.rt,this._parent.rn,this._parent.ip,this._parent.mo,1);
      };
   }
   i++;
}
var scrollerObj = new controls.ScrollPane(listGroup.scrollContent,188,136,null,176,188,-11);
