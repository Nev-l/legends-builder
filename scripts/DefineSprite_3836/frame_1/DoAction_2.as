var shopName = "Licenses";
var locationID = _parent.locationID;
_global.shopLicensesMC = this;
var licMainCatXML = new XML("<n2><c i=\"100\" pi=\"0\" c=\"0\" n=\"Plate Style\" p=\"0\"></c><c i=\"200\" pi=\"0\" c=\"0\" n=\"Custom Number\" p=\"0\"></c></n2>");
var licCatXML = new XML("<n2><p i=\"0\" pi=\"200\" l=\"100\" n=\"Custom Plate Number\"/><p i=\"0\" pi=\"200\" l=\"200\" n=\"Custom Plate Number\"/><p i=\"0\" pi=\"200\" l=\"300\" n=\"Custom Plate Number\"/><p i=\"0\" pi=\"200\" l=\"400\" n=\"Custom Plate Number\"/></n2>");
var i = 0;
while(i < _global.platesXML.firstChild.childNodes.length)
{
   var sNode = _global.platesXML.firstChild.childNodes[i];
   var tNode = new XMLNode(1,"p");
   tNode.attributes.id = sNode.attributes.i;
   tNode.attributes.i = sNode.attributes.i;
   tNode.attributes.pi = 100;
   tNode.attributes.di = sNode.attributes.i;
   tNode.attributes.n = sNode.attributes.d;
   tNode.attributes.p = sNode.attributes.m;
   tNode.attributes.pp = sNode.attributes.p;
   tNode.attributes.ms = sNode.attributes.ms;
   tNode.attributes.l = sNode.attributes.ml;
   tNode.attributes.mc = sNode.attributes.mc;
   tNode.attributes.vm = sNode.attributes.vm;
   tNode.attributes.vp = sNode.attributes.vp;
   licCatXML.firstChild.appendChild(tNode);
   i++;
}
