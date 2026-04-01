newWinner._alpha = 0;
newWinner.swapDepths(10);
newWinner.onEnterFrame = function()
{
   if(this._alpha < 100)
   {
      this._alpha += 7;
   }
   else
   {
      this._alpha = 100;
      showWinnerInfo();
      delete this.onEnterFrame;
   }
};
