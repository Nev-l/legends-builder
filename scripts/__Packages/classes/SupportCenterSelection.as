class classes.SupportCenterSelection
{
   var index;
   var theTitle;
   var objType;
   var priorItem;
   var submitButton;
   var okButton;
   var errorForm;
   var displayText;
   var ticketNumber;
   var menuItems;
   var formFields;
   var resultFormType;
   static var MENU = "MENU";
   static var FORM = "FORM";
   static var PLAYER_LOOKUP = "PLAYER_LOOKUP";
   static var USER_DETAILS = "USER_DETAILS";
   static var NORMAL = 0;
   static var REPORT_MISCONDUCT = 1;
   function SupportCenterSelection(theType, prior, a_title, a_index, a_resultFormType)
   {
      this.index = a_index;
      this.theTitle = a_title;
      this.objType = theType;
      this.priorItem = prior;
      this.submitButton = false;
      this.okButton = false;
      this.errorForm = false;
      this.displayText = "";
      this.ticketNumber = "0";
      this.menuItems = new Array();
      this.formFields = new Array();
      this.resultFormType = a_resultFormType;
   }
   function getMenuItem(index)
   {
      return this.menuItems[index];
   }
}
