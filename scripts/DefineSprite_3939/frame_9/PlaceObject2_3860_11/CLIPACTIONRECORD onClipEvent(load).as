onClipEvent(load){
   this.createEmptyMovieClip("dynoHolder",this.getNextHighestDepth());
   dynoHolder._yscale = 10 / _parent.graphScale;
   this.createEmptyMovieClip("dynoHolderMask",this.getNextHighestDepth());
   var theY = (- this._height) / this._yscale * 100 + 20;
   dynoHolderMask.beginFill(65280,100);
   dynoHolderMask.moveTo(0,0);
   dynoHolderMask.lineTo(this._width - 35,0);
   dynoHolderMask.lineTo(this._width - 35,theY);
   dynoHolderMask.lineTo(0,theY);
   dynoHolderMask.lineTo(0,0);
   dynoHolderMask.endFill();
   dynoHolder.setMask(dynoHolderMask);
}
