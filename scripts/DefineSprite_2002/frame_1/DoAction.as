function showFBOnly(show)
{
   if(show == true)
   {
      btnFBConnect._x = 312.6;
      btnFBConnect._y = 65.6;
      btnWhatsFacebook._visible = false;
      btnForgotPW._visible = false;
      mvFbText._visible = true;
      fbOnlyBG._visible = true;
   }
   else
   {
      btnFBConnect._x = 23.6;
      btnFBConnect._y = 120.6;
      btnWhatsFacebook._visible = true;
      btnForgotPW._visible = true;
      mvFbText._visible = false;
      fbOnlyBG._visible = false;
   }
}
function tryLogin()
{
   if(facebookLogin == false)
   {
      if(!username.length)
      {
         classes.Control.dialogAlert("Racer Name Required","Please enter your username under Racer Name.");
      }
      else if(!pass.length)
      {
         classes.Control.dialogAlert("Password Required","Please enter your password.");
      }
      else
      {
         play();
      }
   }
   else
   {
      play();
   }
}
function tryLoginWithFB()
{
   if(!fbUsername.length)
   {
      classes.Control.dialogAlert("Racer Name Required","Please enter your username under Racer Name.");
   }
   else if(!fbPass.length && facebookLogin == false)
   {
      classes.Control.dialogAlert("Password Required","Please enter your password.");
   }
   else
   {
      play();
   }
}
function activateSuccess(m)
{
   _root.alertMC = classes.AlertBox(_root.attachMovie("alertBox","alertMC",_root.getNextHighestDepth()));
   _root.alertMC.setValue("Success!",m,"success");
   _root.alertMC.addButton("OK");
   var _loc4_ = new Object();
   _loc4_.owner = this;
   _loc4_.onRelease = function(theButton, keepBoxOpen)
   {
      switch(theButton.btnLabel.text)
      {
         case "Login":
            this.owner.username = this.owner.memberU;
            this.owner.pass = this.owner.memberPW;
            this.owner.tryLogin();
            break;
         case "OK":
      }
      if(!keepBoxOpen)
      {
         false;
         theButton._parent._parent.closeMe();
      }
   };
   _root.alertMC.addListener(_loc4_);
}
function fbTokenSuccess()
{
   facebookPollCount = 0;
   classes.Frame.serverLights(true);
   facebookPollInterval = setInterval(this,"getSession",5000);
   gotoAndStop(2);
   trace(facebookPollInterval);
}
function getSession()
{
   clearInterval(facebookPollInterval);
   _root.fbGetSession();
}
function getSessionCB(s)
{
   if(s == 1)
   {
      trace("1!");
      trace("interval ID from get session: " + facebookPollInterval);
   }
   else if(s == -15)
   {
      trace("-1!");
      facebookPollCount++;
      if(facebookPollCount > 24)
      {
         trace("poll count over 24!");
         classes.Frame.serverLights(false);
         _root.displayAlert("warning","Facebook Error","There was an error getting approval from facebook, please try again");
         facebookLinkPage = false;
         _root.clearFB();
         gotoAndStop(1);
      }
      else
      {
         facebookPollInterval = setInterval(this,"getSession",5000);
      }
   }
   else
   {
      classes.Frame.serverLights(false);
      trace("-2!");
      trace("interval ID from get session: " + facebookPollInterval);
      gotoAndPlay(29);
   }
}
var facebookPollInterval;
var facebookPollCount = 0;
