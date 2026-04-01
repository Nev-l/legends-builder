var tdVal = Number(txml.firstChild.attributes.td);
if(tdVal < 0)
{
   fldWinning1.text = "winning by +" + Math.abs(tdVal);
}
else if(tdVal > 0)
{
   fldWinning2.text = "winning by +" + Math.abs(tdVal);
}
