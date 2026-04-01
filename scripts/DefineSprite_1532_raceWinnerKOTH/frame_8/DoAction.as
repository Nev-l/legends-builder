function doNext()
{
   if(classes.GlobalData.id == _parent.kingObj.id)
   {
      if(_parent.kingObj.ks > 1)
      {
         _parent.showKingOption();
      }
      else if(_parent.kingObj.ks > 0)
      {
         _parent.showKingNew();
      }
   }
}
stop();
_global.setTimeout(this,"doNext",5000);
