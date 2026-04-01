stop();
txtNote = "By offering a trade, you are agreeing to pay a $" + _global.usedCarXML.firstChild.attributes.t + " secure transaction fee if the trade is accepted ($" + _global.usedCarXML.firstChild.attributes.mt + " for members!).  If the trade occurs, the fee will be automatically removed from your account.  Note, you will NOT be charged this fee if your offer is declined.";
btnOK.onRelease = function()
{
   nextFrame();
};
