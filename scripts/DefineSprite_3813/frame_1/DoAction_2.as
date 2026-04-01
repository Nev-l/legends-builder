var shopName;
var locationID = _parent.locationID;
var shoppingFor = "Car";
var selAcid;
var isBack;
_global.shopPartsMC = this;
updateShopLocation();
if(locationID >= 300)
{
   bg._alpha = 0;
   bg.ta = 0;
   bg.onEnterFrame = function()
   {
      if(this._alpha < this.ta)
      {
         this._alpha += 10;
      }
   };
}
else
{
   bg.ta = 100;
   gotoAndStop("cats");
   play();
}
