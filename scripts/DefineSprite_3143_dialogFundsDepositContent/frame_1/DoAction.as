stop();
leaderMsg._visible = false;
classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
btnOK.btnLabel.text = "OK";
btnOK.onRelease = function()
{
   play();
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
if(_parent.isLeader)
{
   leaderMsg._visible = true;
   txtMsg = "Team Leaders!\r\rNote: You can now have ownership in your own team.  You can still disburse any and all team funds, regardless of who deposited it.";
}
else
{
   txtMsg = "Note!\r\rMoney you deposit will gain you team ownership.  But remember, the Leader can bet or disburse that money at any time.  Do not deposit money unless you trust the Leader.";
}
