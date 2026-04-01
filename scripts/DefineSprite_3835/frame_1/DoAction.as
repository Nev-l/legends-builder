function initFields()
{
   initOneField(fld1);
   initOneField(fld2);
   initOneField(fld3);
   if(!seq1.length)
   {
      seq1 = "";
   }
   if(!seq2.length)
   {
      seq2 = "";
   }
   if(!seq3.length)
   {
      seq3 = "";
   }
}
function initOneField(tf)
{
   tf.restrict = "A-Z 0-9";
   tf.onChanged = doOnChange;
}
function doOnChange()
{
   var _loc2_ = seq1;
   if(seq2.length)
   {
      _loc2_ += "_" + seq2;
   }
   if(seq3.length)
   {
      _loc2_ += "_" + seq3;
   }
   _parent.showPlate(plateID,_loc2_);
}
