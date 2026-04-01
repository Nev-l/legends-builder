stop();
msg = "Uploading " + _parent.uggCount + " images (" + Math.round(_parent.filesize / 1000) + "KB).  Please wait:";
progressBar.bar._width = 212;
progressBar.shade._x = progressBar.bar._x + progressBar.bar._width;
