stop();
classes.Frame.assetLoader = loader;
if(isNewInstaller)
{
   loader.downloadText2.text = "Getting latest update ...";
   _root.loadInstaller();
}
else
{
   _root.loadUpdate();
}
