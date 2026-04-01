class classes.data.SupportCenterData
{
   static var _menuArray;
   static var _formFields;
   static var _supportCenterType;
   static var _menuArrayUser;
   static var _menuArrayMod;
   static var MAIN_MENU = 1;
   static var ACCOUNT_RECOVERY = 2;
   static var COMPROMISED_ACCOUNT = 3;
   static var LOST_STUFF = 4;
   static var PROBLEM_REDEEMING = 5;
   static var REPORT_BUG = 6;
   static var REPORT_MISCONDUCT = 7;
   static var FORGOT_PASSWORD = 8;
   static var FORGOT_USERNAME = 9;
   static var LOST_EMAIL = 10;
   static var ACCOUNT_TAKE_OVER = 11;
   static var WONT_GIVE_ACCOUNT_BACK = 12;
   static var HACKED_VERSION = 13;
   static var SOMEONE_GUESSED_LOGIN = 14;
   static var TRICKED = 15;
   static var MONEY_CAR_MISSING = 16;
   static var GAVE_MONEY_TO_TEAM_LEADER = 17;
   static var BORROWED_CAR = 18;
   static var TOOK_STUFF = 19;
   static var ACTIVATION_CODE_NO_MEMBERSHIP = 20;
   static var ACTIVATION_CODE_NOT_ACCEPTED = 21;
   static var CHAT_ABUSE = 22;
   static var CHEATING = 23;
   static var FALSE_MISCONDUCT_REPORT = 24;
   static var INNAPPROPRIATE_AVATAR = 25;
   static var INNAPPROPRIATE_USERNAME = 26;
   static var SCAMMING = 27;
   static var UNFAIRLY_BANNED_SOMEONE = 28;
   static var ACCOUNT_COMPROMISED = 29;
   static var PETITION_ASSETS = 30;
   static var SOMEONE_GOT_INTO_ACCOUNT = 31;
   static var MADE_DEAL_NO_DELIVERY = 32;
   static var CA_BAD_LINKS = 33;
   static var CA_RACIAL = 34;
   static var CA_SEXUAL = 35;
   static var CA_SPAMMING = 36;
   static var CA_THREAT = 37;
   static var CHEATING_GLITCH = 38;
   static var CHEATING_THIRD_PARTY = 39;
   static var SCAM_ASKING_LOGIN = 40;
   static var SCAM_IMPERSONATION = 41;
   static var SCAM_LINKS_TO_HACKED = 42;
   static var SCAM_LINKS_TO_PHISHING = 43;
   static var SCAM_SENDING_EMAILS = 44;
   static var GLITCH_ACCOUNT_SECURITY = 45;
   static var GLITCH_MONEY = 46;
   static var GLITCH_RACING = 47;
   static var PLAYER_LOOKUP = 48;
   static var USER_DETAILS = 49;
   static var CA_RELIGION = 50;
   static var CA_DRUG = 51;
   static var CA_DEFAME_MOD = 52;
   static var ACCOUNT_RECOVERY_NOT_LOGGED_IN = 53;
   static var INNAPPROPRIATE_TEAM_AVATAR = 54;
   static var CA_PROFANITY = 55;
   static var CA_HARRASSMENT = 56;
   static var SCAM_STEALING = 57;
   static var USERNAME_OF_COMPROMISED_ACCOUNT = 0;
   static var YOUR_EMAIL_ADDRESS = 1;
   static var USERNAME_OF_OFFENDER = 2;
   static var LINK_TO_PHISHING_SITE = 3;
   static var PURCHASE_CONFIRMATION_NUMBER = 4;
   static var PHONE_NUMBER = 5;
   static var PLAYER_NAME = 6;
   static var LINK_TO_ILLEGAL_GAME_SITE = 7;
   static var DESCRIPTION = 8;
   static var NAME_OF_REPORTER = 9;
   static var DESCRIBE_BUG = 10;
   static var STEPS_TO_REPRODUCE_BUG = 11;
   static var PETITION = 12;
   function SupportCenterData()
   {
   }
   static function init(supportCenterType, movieType)
   {
      classes.data.SupportCenterData._menuArray = new Array();
      classes.data.SupportCenterData._formFields = new Array();
      classes.data.SupportCenterData._supportCenterType = supportCenterType;
      classes.data.SupportCenterData.setupReportMisconduct();
      classes.data.SupportCenterData.setupForms();
      trace("init, supportCenterType: " + supportCenterType);
      classes.data.SupportCenterData.setupMainMenu();
      classes.data.SupportCenterData.setupAccountRecovery();
      classes.data.SupportCenterData.setupCompromisedAccount();
      classes.data.SupportCenterData.setupLostStuff();
      classes.data.SupportCenterData.setupBugReporting();
      classes.data.SupportCenterData.setupProblemRedeeming();
      classes.data.SupportCenterData.setupModStuff();
      if(movieType == classes.SupportCenter.USER)
      {
         classes.data.SupportCenterData._menuArrayUser = classes.data.SupportCenterData._menuArray.slice();
      }
      else
      {
         classes.data.SupportCenterData._menuArrayMod = classes.data.SupportCenterData._menuArray.slice();
      }
   }
   static function setupModStuff()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.PLAYER_LOOKUP] = new classes.SupportCenterSelection(classes.SupportCenterSelection.PLAYER_LOOKUP,null,"Main Menu",classes.data.SupportCenterData.PLAYER_LOOKUP);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.USER_DETAILS] = new classes.SupportCenterSelection(classes.SupportCenterSelection.USER_DETAILS,classes.data.SupportCenterData.PLAYER_LOOKUP,"",classes.data.SupportCenterData.USER_DETAILS);
   }
   static function setupMainMenu()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MAIN_MENU] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,null,"Main Menu",classes.data.SupportCenterData.MAIN_MENU);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MAIN_MENU].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.ACCOUNT_RECOVERY,"Account Recovery");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MAIN_MENU].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.COMPROMISED_ACCOUNT,"Compromised Account");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MAIN_MENU].menuItems[2] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.LOST_STUFF,"Lost, Cars, Parts or Money");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MAIN_MENU].menuItems[3] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.PROBLEM_REDEEMING,"Problem Redeeming Membership or Points");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MAIN_MENU].menuItems[4] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.REPORT_BUG,"Report a Bug");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MAIN_MENU].menuItems[5] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.REPORT_MISCONDUCT,"Report Misconduct");
   }
   static function setupAccountRecovery()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACCOUNT_RECOVERY] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,classes.data.SupportCenterData.MAIN_MENU,"",classes.data.SupportCenterData.ACCOUNT_RECOVERY);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACCOUNT_RECOVERY].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.FORGOT_PASSWORD,"Forgot My Password");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACCOUNT_RECOVERY].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.FORGOT_USERNAME,"I Can\'t Remember My Account Name");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACCOUNT_RECOVERY].menuItems[2] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.LOST_EMAIL,"I Lost Access To My Email And Cannot Recover My Password");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACCOUNT_RECOVERY].menuItems[3] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.ACCOUNT_TAKE_OVER,"Someone Has Taken Over My Account And I Can\'t Get It Back");
      trace("setupAccountRecovery");
      trace(classes.data.SupportCenterData._menuArray[2]);
   }
   static function setupCompromisedAccount()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.COMPROMISED_ACCOUNT] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,classes.data.SupportCenterData.MAIN_MENU,"Compromised Account",classes.data.SupportCenterData.COMPROMISED_ACCOUNT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.COMPROMISED_ACCOUNT].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.WONT_GIVE_ACCOUNT_BACK,"I Let Someone On My Account And They Won\'t Give It Back");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.COMPROMISED_ACCOUNT].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.HACKED_VERSION,"I Logged Into An Unofficial Site Or Hacked Version Of The Game");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.COMPROMISED_ACCOUNT].menuItems[2] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.SOMEONE_GUESSED_LOGIN,"Someone Guessed My Login Information");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.COMPROMISED_ACCOUNT].menuItems[3] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.TRICKED,"Someone Tricked Me Into Giving Them My Login Info");
   }
   static function setupLostStuff()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_STUFF] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,classes.data.SupportCenterData.MAIN_MENU,"Lost Cars, Parts, or Money",classes.data.SupportCenterData.LOST_STUFF);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_STUFF].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.MONEY_CAR_MISSING,"I Don\'t Know Why My Car/Money Is Missing");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_STUFF].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.GAVE_MONEY_TO_TEAM_LEADER,"I Gave Money To My Team And The Leader Did Not Give It Back");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_STUFF].menuItems[2] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.BORROWED_CAR,"I Let Someone \"Borrow\" My Car And They Did Not Give It Back");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_STUFF].menuItems[3] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.TOOK_STUFF,"Someone Took My Cars, Parts, And/Or Money");
      classes.data.SupportCenterData.setupDontKnowWhyMissing();
      classes.data.SupportCenterData.setupSomeoneTookMyStuff();
   }
   static function setupBugReporting()
   {
   }
   static function setupProblemRedeeming()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.PROBLEM_REDEEMING] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,classes.data.SupportCenterData.MAIN_MENU,"Problem Redeeming Membership or Points",classes.data.SupportCenterData.PROBLEM_REDEEMING);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.PROBLEM_REDEEMING].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.ACTIVATION_CODE_NO_MEMBERSHIP,"I Entered My Activation Code But Did Not Receive My Membership");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.PROBLEM_REDEEMING].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.ACTIVATION_CODE_NOT_ACCEPTED,"It Will Not Accept My Activation Code");
   }
   static function setupReportMisconduct()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,classes.data.SupportCenterData.MAIN_MENU,"Report Misconduct",classes.data.SupportCenterData.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CHAT_ABUSE,"Chat Abuse");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CHEATING,"Cheating");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems[2] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.FALSE_MISCONDUCT_REPORT,"False Misconduct Reporting");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems[3] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.INNAPPROPRIATE_AVATAR,"Inappropriate Avatar");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems[4] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.INNAPPROPRIATE_USERNAME,"Inappropriate Username");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems[5] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.INNAPPROPRIATE_TEAM_AVATAR,"Inappropriate Team Avatar");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems[6] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.SCAMMING,"Scamming");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems[7] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.UNFAIRLY_BANNED_SOMEONE,"Unfairly Banned Someone");
      trace("support Center Type, report misconduct: " + classes.data.SupportCenterData._supportCenterType);
      if(classes.data.SupportCenterData._supportCenterType != classes.SupportCenter.SENIOR_MOD_TYPE)
      {
         classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems.splice(7,1);
      }
      if(classes.data.SupportCenterData._supportCenterType == classes.SupportCenter.USER_TYPE)
      {
         classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_MISCONDUCT].menuItems.splice(2,1);
      }
      classes.data.SupportCenterData.setupChatAbuse();
      classes.data.SupportCenterData.setupCheating();
      classes.data.SupportCenterData.setupScamming();
   }
   static function setupDontKnowWhyMissing()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MONEY_CAR_MISSING] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,null,"I Don\'t Know Why My Car/Money Is Missing",classes.data.SupportCenterData.MONEY_CAR_MISSING);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MONEY_CAR_MISSING].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.COMPROMISED_ACCOUNT,"My Account Has Been Compromised");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MONEY_CAR_MISSING].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.PETITION_ASSETS,"The Administrators Removed My Assets And I Would Like To Petition");
   }
   static function setupSomeoneTookMyStuff()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.TOOK_STUFF] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,null,"Someone Took My Cars, Parts, And/Or Money",classes.data.SupportCenterData.TOOK_STUFF);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.TOOK_STUFF].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.COMPROMISED_ACCOUNT,"Someone Got Onto My Account");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.TOOK_STUFF].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.MADE_DEAL_NO_DELIVERY,"I Made A Deal With Someone And They Didn\'t Pay Or Deliver The Car Or Part");
   }
   static function setupChatAbuse()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHAT_ABUSE] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,null,"Chat Abuse",classes.data.SupportCenterData.CHAT_ABUSE);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHAT_ABUSE].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CA_RELIGION,"Racial/Ethnic Slurs, Religious Slander & Sexual Harassment");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHAT_ABUSE].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CA_DEFAME_MOD,"Staff Harassment & Impersonation");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHAT_ABUSE].menuItems[2] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CA_PROFANITY,"Inappropriate Language");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHAT_ABUSE].menuItems[3] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CA_BAD_LINKS,"Posting Links for Cheat or Phishing Sites");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHAT_ABUSE].menuItems[4] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CA_THREAT,"Real Life Threats");
      classes.data.SupportCenterData.setupHarrasment();
   }
   static function setupHarrasment()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_HARRASSMENT] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,null,"Harrasment",classes.data.SupportCenterData.CA_HARRASSMENT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_HARRASSMENT].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CA_RACIAL,"Racial Harrasment");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_HARRASSMENT].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.CA_SEXUAL,"Sexual Harrasment");
   }
   static function setupCheating()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHEATING] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,null,"Cheating",classes.data.SupportCenterData.CHEATING);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHEATING].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.GLITCH_MONEY,"Currency Exploit");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHEATING].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.GLITCH_RACING,"Racing Exploits");
   }
   static function setupScamming()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAMMING] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,null,"Scamming",classes.data.SupportCenterData.SCAMMING);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAMMING].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.SCAM_IMPERSONATION,"Impersonating Game Staff");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAMMING].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.SCAM_STEALING,"Stealing cash or a car");
   }
   static function setupGlitch()
   {
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHEATING_GLITCH] = new classes.SupportCenterSelection(classes.SupportCenterSelection.MENU,null,"Glitch Abuse",classes.data.SupportCenterData.CHEATING_GLITCH);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHEATING_GLITCH].menuItems[0] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.GLITCH_ACCOUNT_SECURITY,"Account Security");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHEATING_GLITCH].menuItems[1] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.GLITCH_MONEY,"Money");
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CHEATING_GLITCH].menuItems[2] = new classes.SupportCenterMenuItem(classes.data.SupportCenterData.GLITCH_RACING,"Racing");
   }
   static function setupForms()
   {
      classes.data.SupportCenterData.setupFormsFields();
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_BUG] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,classes.data.SupportCenterData.MAIN_MENU,"",classes.data.SupportCenterData.REPORT_BUG,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_BUG].formFields = new Array({fld:classes.data.SupportCenterData.DESCRIBE_BUG,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIBE_BUG].fieldNum},{fld:classes.data.SupportCenterData.STEPS_TO_REPRODUCE_BUG,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.STEPS_TO_REPRODUCE_BUG].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_BUG].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.REPORT_BUG].supportID = 15;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FORGOT_PASSWORD] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.FORGOT_PASSWORD,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FORGOT_PASSWORD].formFields = new Array({fld:classes.data.SupportCenterData.PLAYER_NAME,pos:1});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FORGOT_PASSWORD].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FORGOT_PASSWORD].supportID = 1;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FORGOT_USERNAME] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.FORGOT_USERNAME,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FORGOT_USERNAME].supportID = 2;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FORGOT_USERNAME].submitButton = false;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_EMAIL] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.LOST_EMAIL,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_EMAIL].formFields = new Array({fld:classes.data.SupportCenterData.PLAYER_NAME,pos:1},{fld:classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS,pos:2});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_EMAIL].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.LOST_EMAIL].supportID = 3;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACCOUNT_TAKE_OVER] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.ACCOUNT_TAKE_OVER,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACCOUNT_TAKE_OVER].supportID = 4;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.WONT_GIVE_ACCOUNT_BACK] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.WONT_GIVE_ACCOUNT_BACK,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.WONT_GIVE_ACCOUNT_BACK].supportID = 5;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.HACKED_VERSION] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.HACKED_VERSION,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.HACKED_VERSION].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_COMPROMISED_ACCOUNT,pos:1},{fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:2},{fld:classes.data.SupportCenterData.LINK_TO_PHISHING_SITE,pos:3});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.HACKED_VERSION].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.HACKED_VERSION].supportID = 6;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SOMEONE_GUESSED_LOGIN] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.SOMEONE_GUESSED_LOGIN,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SOMEONE_GUESSED_LOGIN].supportID = 7;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.TRICKED] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.TRICKED,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.TRICKED].supportID = 8;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.PETITION_ASSETS] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.PETITION_ASSETS,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.PETITION_ASSETS].formFields = new Array({fld:classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS,pos:1},{fld:classes.data.SupportCenterData.PETITION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PETITION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.PETITION_ASSETS].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.PETITION_ASSETS].supportID = 9;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GAVE_MONEY_TO_TEAM_LEADER] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.GAVE_MONEY_TO_TEAM_LEADER,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GAVE_MONEY_TO_TEAM_LEADER].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GAVE_MONEY_TO_TEAM_LEADER].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GAVE_MONEY_TO_TEAM_LEADER].supportID = 10;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.BORROWED_CAR] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.BORROWED_CAR,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.BORROWED_CAR].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.BORROWED_CAR].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.BORROWED_CAR].supportID = 11;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MADE_DEAL_NO_DELIVERY] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.MADE_DEAL_NO_DELIVERY,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MADE_DEAL_NO_DELIVERY].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MADE_DEAL_NO_DELIVERY].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.MADE_DEAL_NO_DELIVERY].supportID = 12;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACTIVATION_CODE_NO_MEMBERSHIP] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.ACTIVATION_CODE_NO_MEMBERSHIP,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACTIVATION_CODE_NO_MEMBERSHIP].formFields = new Array({fld:classes.data.SupportCenterData.PURCHASE_CONFIRMATION_NUMBER,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PURCHASE_CONFIRMATION_NUMBER].fieldNum},{fld:classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACTIVATION_CODE_NO_MEMBERSHIP].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACTIVATION_CODE_NO_MEMBERSHIP].supportID = 13;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACTIVATION_CODE_NOT_ACCEPTED] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.ACTIVATION_CODE_NOT_ACCEPTED,classes.SupportCenterSelection.NORMAL);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACTIVATION_CODE_NOT_ACCEPTED].formFields = new Array({fld:classes.data.SupportCenterData.PURCHASE_CONFIRMATION_NUMBER,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PURCHASE_CONFIRMATION_NUMBER].fieldNum},{fld:classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACTIVATION_CODE_NOT_ACCEPTED].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.ACTIVATION_CODE_NOT_ACCEPTED].supportID = 14;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_RELIGION] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_RELIGION,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_RELIGION].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_RELIGION].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_RELIGION].supportID = 23;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_DEFAME_MOD] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_DEFAME_MOD,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_DEFAME_MOD].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_DEFAME_MOD].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_DEFAME_MOD].supportID = 24;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_DRUG] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_DRUG,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_DRUG].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_DRUG].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_DRUG].supportID = 25;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_BAD_LINKS] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_BAD_LINKS,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_BAD_LINKS].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_BAD_LINKS].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_BAD_LINKS].supportID = 16;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_RACIAL] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_RACIAL,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_RACIAL].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_RACIAL].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_RACIAL].supportID = 17;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_SEXUAL] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_SEXUAL,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_SEXUAL].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_SEXUAL].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_SEXUAL].supportID = 26;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_PROFANITY] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_PROFANITY,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_PROFANITY].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_PROFANITY].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_PROFANITY].supportID = 37;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_SPAMMING] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_SPAMMING,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_SPAMMING].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_SPAMMING].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_SPAMMING].supportID = 18;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_THREAT] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.CA_THREAT,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_THREAT].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_THREAT].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.CA_THREAT].supportID = 19;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_ACCOUNT_SECURITY] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.GLITCH_ACCOUNT_SECURITY,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_ACCOUNT_SECURITY].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_ACCOUNT_SECURITY].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_ACCOUNT_SECURITY].supportID = 20;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_MONEY] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.GLITCH_MONEY,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_MONEY].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_MONEY].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_MONEY].supportID = 21;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_RACING] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.GLITCH_RACING,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_RACING].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_RACING].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.GLITCH_RACING].supportID = 22;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FALSE_MISCONDUCT_REPORT] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.FALSE_MISCONDUCT_REPORT,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FALSE_MISCONDUCT_REPORT].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FALSE_MISCONDUCT_REPORT].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.FALSE_MISCONDUCT_REPORT].supportID = 27;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_AVATAR] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.INNAPPROPRIATE_AVATAR,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_AVATAR].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_AVATAR].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_AVATAR].supportID = 28;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_TEAM_AVATAR] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.INNAPPROPRIATE_TEAM_AVATAR,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_TEAM_AVATAR].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_TEAM_AVATAR].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_TEAM_AVATAR].supportID = 36;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_USERNAME] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.INNAPPROPRIATE_USERNAME,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_USERNAME].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_USERNAME].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.INNAPPROPRIATE_USERNAME].supportID = 29;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_ASKING_LOGIN] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.SCAM_ASKING_LOGIN,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_ASKING_LOGIN].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_ASKING_LOGIN].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_ASKING_LOGIN].supportID = 30;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_IMPERSONATION] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.SCAM_IMPERSONATION,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_IMPERSONATION].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_IMPERSONATION].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_IMPERSONATION].supportID = 31;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_LINKS_TO_HACKED] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.SCAM_LINKS_TO_HACKED,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_LINKS_TO_HACKED].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.LINK_TO_ILLEGAL_GAME_SITE,pos:2});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_LINKS_TO_HACKED].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_LINKS_TO_HACKED].supportID = 32;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_LINKS_TO_PHISHING] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.SCAM_LINKS_TO_PHISHING,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_LINKS_TO_PHISHING].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.LINK_TO_PHISHING_SITE,pos:2});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_LINKS_TO_PHISHING].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_LINKS_TO_PHISHING].supportID = 33;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_SENDING_EMAILS] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.SCAM_SENDING_EMAILS,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_SENDING_EMAILS].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_SENDING_EMAILS].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_SENDING_EMAILS].supportID = 34;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_STEALING] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.SCAM_STEALING,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_STEALING].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_STEALING].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.SCAM_STEALING].supportID = 38;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.UNFAIRLY_BANNED_SOMEONE] = new classes.SupportCenterSelection(classes.SupportCenterSelection.FORM,null,"",classes.data.SupportCenterData.UNFAIRLY_BANNED_SOMEONE,classes.SupportCenterSelection.REPORT_MISCONDUCT);
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.UNFAIRLY_BANNED_SOMEONE].formFields = new Array({fld:classes.data.SupportCenterData.USERNAME_OF_OFFENDER,pos:1},{fld:classes.data.SupportCenterData.DESCRIPTION,pos:classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum});
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.UNFAIRLY_BANNED_SOMEONE].submitButton = true;
      classes.data.SupportCenterData._menuArray[classes.data.SupportCenterData.UNFAIRLY_BANNED_SOMEONE].supportID = 35;
      classes.data.SupportCenterFormData.setupDisplayText(classes.data.SupportCenterData._menuArray);
   }
   static function setupFormsFields()
   {
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.USERNAME_OF_COMPROMISED_ACCOUNT] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.USERNAME_OF_COMPROMISED_ACCOUNT].fieldNum = 1;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.USERNAME_OF_COMPROMISED_ACCOUNT].fieldLabel = "Username of compromised account";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.USERNAME_OF_COMPROMISED_ACCOUNT].labelColor = 16777215;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS].fieldNum = 2;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS].fieldLabel = "Your email address:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.YOUR_EMAIL_ADDRESS].labelColor = 16777215;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.USERNAME_OF_OFFENDER] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.USERNAME_OF_OFFENDER].fieldNum = 4;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.USERNAME_OF_OFFENDER].fieldLabel = "Username of offender:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.USERNAME_OF_OFFENDER].labelColor = 16770048;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.LINK_TO_PHISHING_SITE] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.LINK_TO_PHISHING_SITE].fieldNum = 4;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.LINK_TO_PHISHING_SITE].fieldLabel = "Link to phishing site:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.LINK_TO_PHISHING_SITE].labelColor = 16770048;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PURCHASE_CONFIRMATION_NUMBER] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PURCHASE_CONFIRMATION_NUMBER].fieldNum = 1;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PURCHASE_CONFIRMATION_NUMBER].fieldLabel = "Purchase confirmation number:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PURCHASE_CONFIRMATION_NUMBER].labelColor = 16777215;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PLAYER_NAME] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PLAYER_NAME].fieldNum = 1;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PLAYER_NAME].fieldLabel = "Username:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PLAYER_NAME].labelColor = 16777215;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.LINK_TO_ILLEGAL_GAME_SITE] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.LINK_TO_ILLEGAL_GAME_SITE].fieldNum = 4;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.LINK_TO_ILLEGAL_GAME_SITE].fieldLabel = "Link to illegal game site:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.LINK_TO_ILLEGAL_GAME_SITE].labelColor = 16770048;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldNum = 5;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].fieldLabel = "Description:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIPTION].labelColor = 16777215;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PETITION] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PETITION].fieldNum = 5;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PETITION].fieldLabel = "Petition:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.PETITION].labelColor = 16777215;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIBE_BUG] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIBE_BUG].fieldNum = 6;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIBE_BUG].fieldLabel = "Please describe the bug:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.DESCRIBE_BUG].labelColor = 16777215;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.STEPS_TO_REPRODUCE_BUG] = new Object();
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.STEPS_TO_REPRODUCE_BUG].fieldNum = 7;
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.STEPS_TO_REPRODUCE_BUG].fieldLabel = "Steps to reproduce the bug:";
      classes.data.SupportCenterData._formFields[classes.data.SupportCenterData.STEPS_TO_REPRODUCE_BUG].labelColor = 16777215;
   }
   static function getFormFieldsObject(field)
   {
      return classes.data.SupportCenterData._formFields[field];
   }
   static function getSelection(selection, movieType)
   {
      trace("SupportCenterData::getSelection");
      trace(classes.data.SupportCenterData._menuArray.length);
      trace(selection);
      if(movieType == classes.SupportCenter.USER)
      {
         return classes.data.SupportCenterData._menuArrayUser[selection];
      }
      return classes.data.SupportCenterData._menuArrayMod[selection];
   }
}
