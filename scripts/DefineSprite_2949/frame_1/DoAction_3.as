classes.Control.htourneyMC = this;
var detailObj = _parent.detailObj;
var qualFlag;
var qualStatus;
var joinFlag;
var roomFlag;
var spectateFlag;
var raceRoomInitFlag;
var raceRoomFlag;
var qualRT;
var qualET;
var prepMsg = "PREPARING TRACK.\rPLEASE WAIT...";
var tourneyWinnerID;
var bracketTime = _global.htJoinTournamentBT;
delete _global.htJoinTournamentBT;
var selCarID = _global.htJoinTournamentACID;
delete _global.htJoinTournamentACID;
var matchTreeXML;
var userStr;
var matchArr;
var leadersArr;
var leadersXML;
var leadersNodes;
var cy = 32;
var playerRank;
var tourneyType;
var roundsArr;
var opponentPrestaged;
var rankingBoardMC;
var myRacerNum;
var tourneyID;
var tourneyScheduleID;
var currentMatch;
countdownGroup._visible = false;
initRoom();
tourneyScheduleID = detailObj.it;
if(_global.chatObj.roomType == "HTR" || _global.chatObj.roomType == "HTS")
{
   classes.Control.setMapButton("race");
   spectateFlag = true;
   gotoAndStop("raceRoom");
   play();
}
else
{
   classes.Control.setMapButton("htTourney");
}
