class classes.data.TutorialData
{
   static var arrControllingYourCar;
   static var arrPreparingRace;
   static var arrRacing;
   static var arrAdvancedRacing;
   static var arrIntro;
   static var arrSectionRaceTrack;
   static var arrHome;
   static var arrGarage;
   static var arrShop;
   static var arrTeamHQ;
   static var arrRivalsTrack;
   static var holdIncentiveID;
   static var holdIncentiveMsg;
   function TutorialData()
   {
   }
   static function init()
   {
      classes.data.TutorialData.arrControllingYourCar = new Array();
      classes.data.TutorialData.arrControllingYourCar.push(new Array(674,335,471 + (-40 + Math.floor(Math.random() * 80)),160 + (-20 + Math.floor(Math.random() * 40)),"Hey, it\'s me X!  In this short tutorial I\'ll teach you how to control your car.  You will be awarded $100 the first time you complete this lesson.  Click the arrow below to continue.  At any time, you can click the red X above to quit this lesson."));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(457,292,491,218,"This is the gas pedal.  Click and hold this pedal to rev your engine.  Try it now and notice the effect on your RPM gauge."));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(457,306,491,232,"While holding down the gas pedal, drag up to increase power.  Drag down to decrease power."));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(285,286,240,143,"Your car always begins on the track in Neutral indicated by the \"N\" here.  In neutral, your engine is not applying power to the wheels.  Your car will not move until you shift your transmission into gear."));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(285,286,240,113,"To shift your gear up one notch, press and release the up arrow key on your keyboard (or \"w\" key).  Try it now."));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(285,286,240,143,"Notice that the \"N\" changed to a \"1\".  You are now in first gear.  Your car should be creeping forward.  Pressing the gas now will accelerate your car."));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(285,286,240,123,"Press the down arrow (or \"s\" key) to shift back down.  If you shift down from Neutral, you will be in reverse.  Try shifting all the way down to reverse, indicated by an \"R\" here.  You may have to give it some gas to actually start moving backwards."));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(400,295,245,197,"At any time, you can click and hold the Brake to slow your car down."));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(202,216,215,100,"This indicator lights up when your engine is potentially damaged enough to cause a loss of power.  Damage can be fixed at the Repair Shop.",classes.data.TutorialData.blinkItem,"classes.RaceControls._mc.damageLight"));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(170,323,235,177,"This indicator lights up if your tires have lost traction and are spinning wildly.  When that happens, you should reduce the gas until you regain traction.",classes.data.TutorialData.blinkItem,"classes.RaceControls._mc.tractionIcon"));
      classes.data.TutorialData.arrControllingYourCar.push(new Array(430,157,260,157,"Congratulations, this lesson is complete!  You now know how to control your car.  Please continue to the next tutorial on Preparing to Race.",classes.data.TutorialData.getIncentive,1));
      classes.data.TutorialData.arrPreparingRace = new Array();
      classes.data.TutorialData.arrPreparingRace.push(new Array(674,335,471 + (-40 + Math.floor(Math.random() * 80)),160 + (-20 + Math.floor(Math.random() * 40)),"By now you know how to control your car.  This short tutorial will teach you the \"staging\" phase of racing.  You will be awarded $100 the first time you complete this lesson."));
      classes.data.TutorialData.arrPreparingRace.push(new Array(302,276,344,143,"Your car always begins on the track 13 feet behind the starting line.  Before the race can start, you need to move your car to the staging position, which is just a few inches behind the starting line."));
      classes.data.TutorialData.arrPreparingRace.push(new Array(7,170,48,95,"This gauge shows where your car is relative to the staging position.  You need to put your car in the green area to be properly staged.  The yellow, or pre-stage, area just means you\'re close."));
      classes.data.TutorialData.arrPreparingRace.push(new Array(354,96,408,106,"These lights also indicate if you\'re in the pre-staged and staged positions.  When you are properly staged, both sets of lights will light up."));
      classes.data.TutorialData.arrPreparingRace.push(new Array(404,82,436,98,"In a live race, you have a limited amount of time to stage.  In those cases, your remaining time will appear here.  If time runs out before you stage, you will get a DNS (Did Not Stage) and automatically lose the race."));
      classes.data.TutorialData.arrPreparingRace.push(new Array(385,174,434,202,"Once you are staged, the \"christmas tree\" lights will activate, and the race begins!"));
      classes.data.TutorialData.arrPreparingRace.push(new Array(7,172,48,70,"Try moving your car forward into the green stage zone now.  Once you are properly staged, do not move your car out of the stage zone until you get the green light."));
      classes.data.TutorialData.arrPreparingRace.push(new Array(430,157,260,157,"Congratulations, this lesson is complete!  You now know how to prepare to race.  Please continue to the next tutorial on Racing.",classes.data.TutorialData.getIncentive,2));
      classes.data.TutorialData.arrRacing = new Array();
      classes.data.TutorialData.arrRacing.push(new Array(674,335,471 + (-40 + Math.floor(Math.random() * 80)),160 + (-20 + Math.floor(Math.random() * 40)),"Now that you know how to stage, you\'re ready to race!  You will be awarded $100 the first time you complete this lesson."));
      classes.data.TutorialData.arrRacing.push(new Array(385,174,474,202,"Once you are staged, the \"christmas tree\" lights will begin to light up from the top down.  First the three yellows will light up one by one, then the green."));
      classes.data.TutorialData.arrRacing.push(new Array(425,174,488,202,"Note that the tree has a set of lights for each lane.  In \"bracket\" races (covered later in this lesson) your opponent\'s lights will be triggered at a different time than yours, so make sure that you watch the lights on your own side."));
      classes.data.TutorialData.arrRacing.push(new Array(385,203,474,215,"Once you get your green light, you can give it the gas and start down the track.  But be careful... if you cross the starting line before you get the green light, you will get a FOUL (red light) and automatically lose the race."));
      classes.data.TutorialData.arrRacing.push(new Array(457,306,491,232,"Try staging now.  When you get the green light, shift into first gear (up arrow) and give it the gas."));
      classes.data.TutorialData.arrRacing.push(new Array(99,181,209,70,"As your car moves faster, your RPM gauge will approach redline.  Running an engine in \"the red\" will damage the engine.  Every engine has a different redline, indicated by the red arc on the tachometer.  Try accelerating to the redline by staying in first gear and applying full gas.  Don\'t worry, any damage you cause here on the practice track is not permanent!"));
      classes.data.TutorialData.arrRacing.push(new Array(99,181,209,70,"You may have noticed that the RPM\'s do not go much farther than redline.  This is because every car in this game is equipped with a rev limiter to help prevent engine damage.  However, be careful when gearing down, as the rev limiter does not apply to downshifting.  Forcing a downshift at high speeds can overrev the engine into the red. "));
      classes.data.TutorialData.arrRacing.push(new Array(285,286,240,143,"Before you hit redline, shift into the next gear (up arrow) to continue accelerating your car.  In this way, you can accelerate through all of your gears to the finish line."));
      classes.data.TutorialData.arrRacing.push(new Array(400,250,478,206,"Standard drag racing tracks are a quarter of a mile long (1320 feet!) from the starting line to the finish line.  If you haven\'t already, drive the entire length to the finish line now."));
      classes.data.TutorialData.arrRacing.push(new Array(233,171,338,136,"Once you cross the finish line, the time you took from line to line, known as your elapsed time (ET), will appear on screen."));
      classes.data.TutorialData.arrRacing.push(new Array(221,216,338,146,"Your trap speed (TS) is also shown.  This is your speed at the moment you cross the finish line.  Trap speed is not generally used for scoring.  It is only displayed for your information (and bragging rights)."));
      classes.data.TutorialData.arrRacing.push(new Array(233,157,338,126,"In a regular head-to-head race (H2H), your \"score\" is the combination of your RT and ET.  This score is compared to your opponent\'s score to figure out who won.  Of course, you can also tell who won by seeing who crossed the finish line first."));
      classes.data.TutorialData.arrRacing.push(new Array(253,171,338,86,"While many racers\' cars are modified to run extremely fast ET\'s, there is a way to even the playing field.  There is a special race format called \"bracket\" racing, in which top speeds don\'t matter."));
      classes.data.TutorialData.arrRacing.push(new Array(253,171,338,86,"In a \"bracket\" race, instead of trying to simply be the fastest car, you specify what ET you think you will run.  This is called your dial-in time.  The goal is to get as close as possible to your dial-in without beating it."));
      classes.data.TutorialData.arrRacing.push(new Array(210,133,266,70,"Actually, in a bracket race, your score is a combination of your RT and whatever time you missed your dial-in by.  As you can see, it doesn\'t matter if your car runs the quarter mile in 16 seconds or 8 seconds.  The important thing is how close you get to the dial-in that you specified."));
      classes.data.TutorialData.arrRacing.push(new Array(210,133,266,80,"But be careful: beating your dial-in time in a bracket race will get you what\'s called a \"breakout\"... and the only way to win with a breakout is if your opponent breaks out even worse than you."));
      classes.data.TutorialData.arrRacing.push(new Array(425,174,484,142,"In a bracket race, you and your opponent will get your christmas tree lights at different times, depending on the difference between your dial-ins.  This is done so that the winner is still the racer who crosses the finish line first.  For example, if your dial-in is 15 seconds and your opponent\'s dial-in is 10 seconds, you would get a 5 second head start.",classes.data.TutorialData.showItem,"classes.RaceTreeLights._MC"));
      classes.data.TutorialData.arrRacing.push(new Array(430,157,260,100,"When you\'re out looking for a race, remember that \"head-to-head\" means you\'re racing for speed while \"bracket\" means you\'re racing for consistency.  But a good RT is important either way.  Congratulations, this lesson is complete!  Now you\'re ready to race!  For a leg up, try the tutorial on Advanced Racing Techniques.",classes.data.TutorialData.getIncentive,3));
      classes.data.TutorialData.arrAdvancedRacing = new Array();
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(674,335,471 + (-40 + Math.floor(Math.random() * 80)),160 + (-20 + Math.floor(Math.random() * 40)),"So you think you\'re ready to learn some advanced racing techniques?  There\'s no money reward for completing this lesson... just the skills you\'ll need to become one of the best!  Let\'s begin!"));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(457,292,491,188,"A technique to maximize your speed is to stage as far from the starting line as allowed.  To do this, creep slowly into the staging zone and stop the car immediately when the \"stage\" light illuminates.  When the race begins, start accelerating a moment before you get the green light."));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(385,203,454,191,"By the time the green lights, you should be crossing the starting line with a little bit of speed.  Note that using this technique is often at the expense of a better RT.  It also causes a greater risk of fouling.  Try it now.  If you foul, you can press the Reset button to try again."));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(127,198,203,146,"Another technique to maximize your speed is to prerev your engine.  While staged, put your car in neutral and apply some gas.  Try adjusting the gas level to hold exactly 2,000 RPM."));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(385,203,454,181,"When you get the green, shift to first gear and then quickly increase the gas to full power.  If you do this correctly, your car will launch with a greater initial speed.  But be careful as the sudden torque can cause your tires to lose traction.  Try finding the best RPM prerev level for your car."));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(358,287,413,120,"This clutch setting determines how fast you want the clutch pedal released during shifting.  A high setting will give you a quick and harsh clutch release. A low setting will provide a smoother but slower clutch release.  Try experimenting to figure out what setting gives you the best times without losing traction."));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(170,217,257,101,"At some point you may choose to install a Nitrous Oxide System (nitrous).  While nitrous is being injected into the engine, it causes a chemical reaction that increases power, making your car faster.  If you have nitrous installed, hold down the right arrow key (or \"d\") to continuously inject nitrous to the engine."));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(214,250,253,143,"If you have a system installed, a nitrous gauge will appear here.  This gauge shows how much nitrous you have left.  Make sure to refill your nitrous at a Repair Shop, as you don\'t want to run out during a race!",classes.data.TutorialData.blinkItem,"classes.RaceControls._mc.nosGauge"));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(202,216,239,145,"Customizing and tuning your car can make it go faster, but it can also increase the chance of damaging your engine.  The risk of damage is affected by systematic stress levels, durability of parts, and operating conditions.",classes.data.TutorialData.blinkItem,"classes.RaceControls._mc.damageLight"));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(202,216,239,115,"The more horsepower you achieve, the higher the stress levels.  But note, many racers accept the damage to their cars in order to achieve the fastest speeds.  For more details, check out the Tuning section of the online game guide at NittoLegends.com."));
      classes.data.TutorialData.arrAdvancedRacing.push(new Array(430,157,260,157,"Congratulations, you\'ve completed the tutorial on Advanced Racing Techniques!"));
      classes.data.TutorialData.arrIntro = new Array();
      classes.data.TutorialData.arrIntro.push(new Array(39,561,200,250,"\r\rWelcome to Nitto 1320 Legends!  My name is \"X\" and I\'m an administrator of this game (and the best racer around)!  Click the arrow below for a quick tour.  Or you can skip the tour by clicking the X above.  If you ever want to view this tour again, click the \"?\" button here at the bottom left corner of the map.\r\r"));
      classes.data.TutorialData.arrIntro.push(new Array(400,312,271,375,"This is the main map.  There are four neighborhoods that you can live in.  Where you live affects what you can buy and how many cars you can own at once.  But everybody starts in Toreno..."));
      classes.data.TutorialData.arrIntro.push(new Array(337,326,367,369,"If you\'re a new user, this button represents your Home in Toreno.  You can view your buddies, cars, and account settings here."));
      classes.data.TutorialData.arrIntro.push(new Array(51,54,80,94,"This is the map button.  At any time, you can click this button to get back to the map."));
      classes.data.TutorialData.arrIntro.push(new Array(432,250,486,207,"Here\'s the Race Track where all the races happen.  There\'s even a Practice Track here, where I teach you how to race."));
      classes.data.TutorialData.arrIntro.push(new Array(312,201,362,164,"At the Shop you\'ll find parts, kits, paint and other options to modify your cars."));
      classes.data.TutorialData.arrIntro.push(new Array(286,414,330,354,"When you\'re ready to buy a new car, you can find one here at the Dealership."));
      classes.data.TutorialData.arrIntro.push(new Array(219,514,146,414,"This is where you can find cars that other players have posted for sale or trade."));
      classes.data.TutorialData.arrIntro.push(new Array(638,63,460,105,"Clicking this tab brings up your Nitto Instant Messenger.  Here you can talk to your online buddies and add new ones."));
      classes.data.TutorialData.arrIntro.push(new Array(557,62,440,94,"Use the Viewer to browse through racer and team profiles."));
      classes.data.TutorialData.arrIntro.push(new Array(762,53,505,113,"This is your info panel.  Your virtual money ($), Points (P), Street Credit (SC) and unread emails always appear here."));
      classes.data.TutorialData.arrIntro.push(new Array(365,203,419,160,"That\'s it for now.  When you\'re ready, come meet me in the Practice Track for your first tutorial on how to race.  As a bonus, you\'ll earn some virtual money when you complete it!"));
      classes.data.TutorialData.arrSectionRaceTrack = new Array();
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(39,561,50,395,"This is the race track where all the races happen!  This map shows the different types of races available, plus the Practice Track.  Click the arrow below for a quick tour.  Or you can skip the tour by clicking the X above."));
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(358,211,260,70,"At the Rivals Strip, racers set up challenges against other racers.  Racers wager their street credit, funds, and even their cars in head-to-head and bracket races."));
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(412,262,477,236,"Teams challenge other teams for reputation and team funds.  You must be a member of a team to enter."));
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(470,400,466,436,"Defend the King position until someone dethrones you!  All races here use the head-to-head (H2H) format.  For information on H2H racing, see the tutorials at the Practice Track."));
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(471,357,515,387,"Another King of the Hill strip.  The only difference is that all races here use the bracket format.  For information on bracket racing, see the tutorials at the Practice Track."));
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(427,306,494,281,"Prove your mettle in tournaments that pit you against computer opponents or real live racers!  Check the schedule under Live Tournaments to see when the next live event will take place."));
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(95,332,23,359,"Only the top 32 qualifiers get to compete in a Live Tournament.  Everyone else can come here to watch the live tournament action!"));
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(221,380,256,436,"See who ranks among the best in the Leader Boards."));
      classes.data.TutorialData.arrSectionRaceTrack.push(new Array(224,235,226,85,"That covers all the options you have at the Race Track.  Now join me here in the Practice Track and I\'ll teach you everything you need to know about racing."));
      classes.data.TutorialData.arrHome = new Array();
      classes.data.TutorialData.arrHome.push(new Array(39,561,50,395,"Welcome to your Home.  Here you have various options to view your public profile and garage, and to modify your account information."));
      classes.data.TutorialData.arrHome.push(new Array(551,122,278,147,"This is your Profile page, where you have some options to affect the way other racers see you."));
      classes.data.TutorialData.arrHome.push(new Array(104,286,175,246,"Here you can view your buddies and manage the remarks they\'ve left for you.  To add a buddy, find a racer in the Viewer and send them a buddy request.  When they accept, they\'ll appear on this page, as well as in your NIM buddy list."));
      classes.data.TutorialData.arrHome.push(new Array(104,310,175,290,"Click here to get information on where you live and the places you can move.  There are four locations through Nitto 1320 Legends with different move-in fees and rent."));
      classes.data.TutorialData.arrHome.push(new Array(104,334,175,334,"Over here you can create a new team, or check the status of applications you\'ve sent to other teams.  To apply to a team, find a team in the Viewer and click their \'Join\' button.  If you\'re already on a team, go to the Team HQ on the main map to get more information on your team."));
      classes.data.TutorialData.arrHome.push(new Array(490,109,432,170,"You\'ll find all your cars and their parts here.  You can swap spare parts back into your cars, or trade them in for some virtual cash."));
      classes.data.TutorialData.arrHome.push(new Array(687,109,493,170,"Click here to view and change your account settings."));
      classes.data.TutorialData.arrGarage = new Array();
      classes.data.TutorialData.arrGarage.push(new Array(70,199,133,263,"Your cars are listed here.  If you have more than one, click on a car to view it in detail.\r\rThe number of cars you can own is limited by the number of parking spaces in your home.  You can gain more parking spaces by moving up to a nicer city.  (Or you can double your parking spaces simply by purchasing a Nitto 1320 Legends Membership!  See www.NittoLegends.com for details.)"));
      classes.data.TutorialData.arrGarage.push(new Array(94,410,169,369,"Click this button to see all the installed parts and spare parts for the current car."));
      classes.data.TutorialData.arrGarage.push(new Array(106,479,193,460,"This button lets you instantly sell your car for quick cash."));
      classes.data.TutorialData.arrGarage.push(new Array(681,202,454,261,"Clicking this button will show you all the spare parts you own, regardless of which car they fit."));
      classes.data.TutorialData.arrShop = new Array();
      classes.data.TutorialData.arrShop.push(new Array(41,563,143,397,"Welcome to the Nitto 1320 Legends shop!  You are about to enter a whole new world of car customization!"));
      classes.data.TutorialData.arrShop.push(new Array(200,274,135,332,"The Paint Shop is where you can customize the exterior color of your car.  Pick from over a hundred different paint colors for your car.  Each city\'s shop has different colors to choose from."));
      classes.data.TutorialData.arrShop.push(new Array(230,180,155,220,"Give your car a personalized look at the Graphics Shop.  Choose from a variety of professionally designed car graphics.  If you don\'t find something you like, you can upload your own images to wrap onto your car!"));
      classes.data.TutorialData.arrShop.push(new Array(386,306,249,347,"Over here in the parts showroom is where you can purchase a variety of parts for your car.  That includes engine parts to enhance its performance, and body kits to change the look of your car."));
      classes.data.TutorialData.arrShop.push(new Array(586,187,474,233,"At License and Registration you can customize the style of your license plate, and even get a vanity plate number. "));
      classes.data.TutorialData.arrShop.push(new Array(582,386,263,208,"Check out how well your car is performing at the Dyno Garage.  See what each new engine part has done and tune your car to perfection!"));
      classes.data.TutorialData.arrShop.push(new Array(503,438,183,340,"Head on over to the Repair Shop to fix any engine damage that may have occurred in a race.  If you have a nitrous system installed, this is also where you come to refill your nitrous oxide."));
      classes.data.TutorialData.arrShop.push(new Array(236,499,64,292,"The Tire Shop and Certified Performance Retailers allow you to purchase high quality custom wheels for your race car as well as Nitto Tires."));
      classes.data.TutorialData.arrTeamHQ = new Array();
      classes.data.TutorialData.arrTeamHQ.push(new Array(39,561,50,395,"Welcome to the Team HQ where you can check out the status of your team."));
      classes.data.TutorialData.arrTeamHQ.push(new Array(104,310,175,270,"This is the Members page where you can check out everyone that is on your team.  A team has one Team Leader who can appoint Co-Leaders and Dealers."));
      classes.data.TutorialData.arrTeamHQ.push(new Array(104,334,175,334,"Click here to view Applications of racers wanting to be a part of your team.  Only Leaders can accept or decline these applications.  The Team Leader can also modify the Message from the Leader on this page."));
      classes.data.TutorialData.arrTeamHQ.push(new Array(104,358,175,394,"Check the latest team transactions, and deposit and withdraw Funds here.  The Team Leader can disburse funds to any teammate from this page."));
      classes.data.TutorialData.arrRivalsTrack = new Array();
      classes.data.TutorialData.arrRivalsTrack.push(new Array(500,420,150,425,"Welcome to Nitto 1320 Legends!  My name is “X” and I’m the administrator of this game (and the best racer around)!  I’m going to help you to get started on the path to being a Legend.  This is the chat window.  Type here to chat with the other players in the room."));
      classes.data.TutorialData.arrRivalsTrack.push(new Array(108,54,80,94,"This is the map button.  When you’re ready, come meet me in the Practice Track for your first tutorial on how to race.  As a bonus, you’ll earn some virtual money when you complete it!"));
   }
   static function getIncentive(id)
   {
      trace("getIncentive: " + id);
      if(id > 0 && classes.GlobalData.prefsObj.incentiveArray[id] != 1)
      {
         trace("...executing");
         classes.data.TutorialData.holdIncentiveID = id;
         switch(id)
         {
            case 1:
               classes.data.TutorialData.holdIncentiveMsg = "Congratulations, you have been awarded $100 for completing this lesson!\r\rYour current funds always appears at the top right corner of the main screen.";
               break;
            case 2:
               classes.data.TutorialData.holdIncentiveMsg = "Congratulations, you have been awarded $100 for completing this lesson!\r\rYou can use funds to pay for part upgrades, new cars, and other items throughout the game.";
               break;
            case 3:
               classes.data.TutorialData.holdIncentiveMsg = "Congratulations, you have been awarded $100 for completing this lesson!\r\rYou can use funds to make money bets when you race!";
               break;
            default:
               classes.data.TutorialData.holdIncentiveMsg = "Congratulations, you have been awarded money for completing this lesson!";
         }
         _root.earnIncentive(id);
      }
   }
   static function blinkItem(targetStr)
   {
      var target = eval(targetStr);
      trace("blinkItem: " + target);
      var origVis = target._visible;
      if(target._totalframes > 1)
      {
         origVis = target._currentframe == 2;
      }
      target.blinkItemC = 0;
      classes.data.TutorialData.blinkInt(target,origVis);
   }
   static function blinkInt(target, origVis)
   {
      trace("blinkInt: " + target + ", " + origVis);
      var _loc4_ = undefined;
      if(target.blinkItemC >= 9)
      {
         if(target._totalframes > 1)
         {
            target.gotoAndStop(!origVis ? 1 : 2);
         }
         else
         {
            target._visible = origVis;
         }
      }
      else
      {
         target.blinkItemC += 1;
         if(target._totalframes > 1)
         {
            _loc4_ = 1 + target._currentframe % 2;
            target.gotoAndStop(_loc4_);
         }
         else
         {
            target._visible = !target._visible;
         }
         _global.setTimeout(classes.data.TutorialData.blinkInt,400,target,origVis);
      }
   }
   static function showItem(targetStr)
   {
      var target = eval(targetStr);
      var origVis = target._visible;
      target._visible = true;
      _global.setTimeout(classes.data.TutorialData.endShowItem,3000,target,origVis);
   }
   static function endShowItem(target, origVis)
   {
      if(target._visible && !origVis)
      {
         target._visible = false;
      }
   }
}
