class classes.PaintSwatch extends MovieClip
{
   var clr;
   var swatchColorMC;
   var hexColor;
   function PaintSwatch()
   {
      super();
      this.clr = new Color(this.swatchColorMC);
   }
   function set HexColor(v)
   {
      this.hexColor = v;
      this.clr.setRGB(Number("0x" + v));
   }
   function get HexColor()
   {
      return this.hexColor;
   }
}
