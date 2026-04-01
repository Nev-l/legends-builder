function enterRaceWaitRoom(type)
{
   if(type)
   {
      roomType = type;
   }
   gotoAndStop("wait");
   play();
}
function clearWait()
{
   gotoAndStop("map");
   play();
}
function enterRaceRoom(pcid, pcy, type, roomName, isPriv, isMem, asInvisible)
{
   _global.newRoomName = roomName;
   cid = pcid;
   cy = pcy;
   if(isPriv == 1)
   {
      _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogPrivateRoomContent",typeID:type,roomID:cid,roomName:roomName,asInvisible:asInvisible});
   }
   else
   {
      enterRaceWaitRoom(type);
      _root.chatJoin(5,cid,"",asInvisible);
   }
}
function showRaceRoom(newRoomType)
{
   trace("show race room!");
   if(newRoomType)
   {
      roomType = newRoomType;
   }
   _global.chatObj = new Object();
   switch(Number(roomType))
   {
      case 8:
         _global.chatObj.roomType = "TEAMR";
         gotoAndStop("teamRivals");
         play();
         break;
      case 5:
         _global.chatObj.roomType = "RIV";
         gotoAndStop("rivals");
         play();
         break;
      case 3:
         _global.chatObj.roomType = "KOTHB";
         gotoAndStop("koth");
         play();
         break;
      case 6:
         _global.chatObj.roomType = "KOTHH";
         gotoAndStop("koth");
         play();
         break;
      case 7:
         _global.chatObj.roomType = "HTS";
         gotoAndStop("tourneySpectate");
         play();
         break;
      case 10:
         _global.chatObj.roomType = "CT";
         gotoAndStop("tourney");
         play();
         break;
      case 11:
         _global.chatObj.roomType = "HT";
         gotoAndStop("tourney");
         play();
         break;
      case 12:
         _global.chatObj.roomType = "HTR";
         _global.chatObj.roomID = classes.GlobalData.tournamentChatRoomID;
         gotoAndStop("tourneySpectate");
         play();
      default:
         return undefined;
   }
}
function processHtInfo(d)
{
   var _loc2_ = new XML();
   _loc2_.ignoreWhite = true;
   _loc2_.parseXML(d);
   var _loc3_ = _loc2_.firstChild.attributes;
   detailObj = new Object();
   detailObj = _loc3_;
   classes.GlobalData.serverTimeOffset = new Date(Number(_loc3_.ut) * 1000) - new Date();
   if(Number(_loc3_.s) > 0)
   {
      trackMap.trackMapTourneyHi._visible = true;
      trackMap.parkingGroup.createNew._visible = true;
      eventLogo.loadMovie("cache/tournaments/elg_" + _loc2_.firstChild.attributes.li + ".swf");
   }
   tourneyScheduleID = Number(_loc2_.firstChild.attributes.it);
}
function showError(errMsg)
{
   trace("TODO: show error message");
}
var roomType;
