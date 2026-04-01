stop();
kingGroup._visible = false;
queueGroup._visible = false;
kingGroup.swapDepths(this.getNextHighestDepth());
joinPanel.swapDepths(this.getNextHighestDepth());
this.createEmptyMovieClip("maskMC",this.getNextHighestDepth());
joinPanel.setMask(maskMC);
classes.Drawing.rect(maskMC,800,600);
_root.chatKOTHGet();
