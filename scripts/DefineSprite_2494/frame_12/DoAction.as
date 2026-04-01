stop();
delete _global.chatRoomListXML;
var vSpace = 23;
var i = 0;
listGroup.scrollContent["item" + i].txtName = "24/7 Computer Tournaments";
listGroup.scrollContent["item" + i].txtCount = "";
listGroup.scrollContent["item" + i].hi._visible = false;
listGroup.scrollContent["item" + i].membersIcon._visible = false;
listGroup.scrollContent["item" + i].btnInvisible._visible = false;
listGroup.scrollContent["item" + i].lockIcon._visible = false;
listGroup.scrollContent["item" + i].bgColor._visible = false;
listGroup.scrollContent["item" + i].onRollOver = function()
{
   this.hi._visible = true;
};
listGroup.scrollContent["item" + i].onRollOut = function()
{
   this.hi._visible = false;
};
listGroup.scrollContent["item" + i].onRelease = function()
{
   _parent._parent.showRaceRoom(10);
};
i = 1;
listGroup.scrollContent.item0.duplicateMovieClip("item" + i,i);
listGroup.scrollContent["item" + i].txtName = "Live Tournaments";
listGroup.scrollContent["item" + i].txtCount = "";
listGroup.scrollContent["item" + i].hi._visible = false;
listGroup.scrollContent["item" + i].membersIcon._visible = false;
listGroup.scrollContent["item" + i].btnInvisible._visible = false;
listGroup.scrollContent["item" + i].lockIcon._visible = false;
listGroup.scrollContent["item" + i]._y = i * vSpace;
listGroup.scrollContent["item" + i].bgColor._visible = false;
listGroup.scrollContent["item" + i].onRollOver = function()
{
   this.hi._visible = true;
};
listGroup.scrollContent["item" + i].onRollOut = function()
{
   this.hi._visible = false;
};
listGroup.scrollContent["item" + i].onRelease = function()
{
   _parent._parent.showRaceRoom(11);
};
if(classes.GlobalData.attr.r == 1 || classes.GlobalData.attr.r == 2 || classes.GlobalData.attr.r == 8)
{
   if(Number(_parent._parent.detailObj.s))
   {
      i = 2;
      listGroup.scrollContent.item0.duplicateMovieClip("item" + i,i);
      listGroup.scrollContent["item" + i].txtName = "*Current Live Tournament";
      listGroup.scrollContent["item" + i].txtCount = "";
      listGroup.scrollContent["item" + i].hi._visible = false;
      listGroup.scrollContent["item" + i].membersIcon._visible = false;
      listGroup.scrollContent["item" + i].lockIcon._visible = false;
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
         _parent._parent.enterRaceRoom(classes.GlobalData.tournamentChatRoomID,32,12,"",0,0,0);
      };
      listGroup.scrollContent["item" + i].btnInvisible.onRelease = function()
      {
         _parent._parent.enterRaceRoom(classes.GlobalData.tournamentChatRoomID,32,12,"",0,0,1);
      };
   }
}
