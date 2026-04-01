mb.prepPanelRemove();
menuMC.removeMovieClip();
if(partType == "Car Parts")
{
   _root.getCarPartsBin(Number(this._parent.carXML.firstChild.attributes.i));
}
else if(partType == "Spare Parts")
{
   _root.getPartsBin();
}
