function animOnClick(button, CB, CBIdx)
{
   with(button)
   {
      clearInterval(button.si);
      CB(_parent._parent._parent,CBIdx);
   }
}
function CB_goToViewer()
{
   classes.Control.focusViewer();
}
