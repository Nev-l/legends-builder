class classes.data.Profanity
{
   static var wholeWordsArr = new Array("ass","asses","buey","butt","butts","cock","cocks","culo","culos","cum","dick","dicks","fag","fags","homo","homos","jap","japs","joto","jotos","kike","kikes","kock","kocks","kum","kumm","mmg","muff","muffs","nig","nigs","pinche","pito","pitos","pulmon","pulmones","puta","putas","puto","putos","slag","slags","slut","sluts","vagina");
   static var partialWordsArr = new Array("ass hol","ass kiss","ass lick","ass wipe","asshole","asskiss","asslick","asswipe","bastard","beastial","beastil","bestial","bitch","blow job","blowjob","boner","brown eye","browneye","bung hole","bunghole","cabron","chichis","chink","chocho","circle jerk","circlejerk","clit","cobia","cucksu","cumall","cumm","cumon","cunilingus","cunillingus","cunnilingus","cunt","cyberfuc","damn","dildo","douche","dumbass","dyke","ejaculat","estupida","estupido","fagg","fagot","fagots","fags","fatass","felatio","fellatio","fuck","fuk","fvck","fvk","gangbang","gaysex","gonad","hard on","homosex","horny","hussy","jackoff","jism","jiz","jizm","jizz","kike","kondum","kunilingus","lesbian","lesbo","mallate","mayate","mecos","merde","mierda","motha fu","mothafu","mother fu","motherfu","nigga","nigger","orgasim","orgasm","pecker","pendeja","pendejo","penis","porn","prno","prostituta","prostitute","pussie","pussy","retard","schlong","shit","shlong","twat","verga","wetback","whore","vagina");
   function Profanity()
   {
   }
   static function filterString(inputStr)
   {
      if(classes.GlobalData.prefsObj.disableProfanityFilter)
      {
         return inputStr;
      }
      var _loc2_ = inputStr;
      var _loc3_ = 0;
      while(_loc3_ < classes.data.Profanity.wholeWordsArr.length)
      {
         _loc2_ = classes.data.Profanity.filterWords(_loc2_,classes.data.Profanity.wholeWordsArr[_loc3_],"whole");
         _loc3_ += 1;
      }
      _loc3_ = 0;
      while(_loc3_ < classes.data.Profanity.partialWordsArr.length)
      {
         _loc2_ = classes.data.Profanity.filterWords(_loc2_,classes.data.Profanity.partialWordsArr[_loc3_],"partial");
         _loc3_ += 1;
      }
      return _loc2_;
   }
   static function filterWords(targetStr, searchWord, type)
   {
      var _loc4_ = targetStr;
      var _loc5_ = searchWord.length;
      var _loc6_ = "";
      var _loc7_ = targetStr.toLowerCase();
      _loc7_ = _loc7_.split("0").join("o");
      _loc7_ = _loc7_.split("$").join("s");
      _loc7_ = _loc7_.split("@").join("a");
      _loc7_ = _loc7_.split("!").join("i");
      _loc7_ = _loc7_.split("7").join("l");
      _loc7_ = _loc7_.split("3").join("e");
      _loc7_ = _loc7_.split("#").join("h");
      var _loc8_ = 0;
      while(_loc8_ < searchWord.length)
      {
         _loc6_ += "*";
         _loc8_ += 1;
      }
      var _loc9_ = 0;
      var _loc10_ = _loc7_.indexOf(searchWord,_loc9_);
      var _loc11_ = undefined;
      while(_loc10_ >= 0)
      {
         _loc11_ = false;
         if(type == "whole")
         {
            if(!classes.StringFuncs.isWordChar(_loc7_.charAt(_loc10_ - 1)) && !classes.StringFuncs.isWordChar(_loc7_.charAt(_loc10_ + _loc5_)))
            {
               _loc11_ = true;
            }
            else
            {
               _loc9_ = _loc10_ + _loc5_;
            }
         }
         else if(type == "partial")
         {
            _loc11_ = true;
         }
         if(_loc11_)
         {
            _loc9_ = _loc10_ + _loc5_;
            _loc7_ = _loc7_.substr(0,_loc10_) + _loc6_ + _loc7_.substr(_loc9_);
            _loc4_ = _loc4_.substr(0,_loc10_) + _loc6_ + _loc4_.substr(_loc9_);
         }
         _loc10_ = _loc7_.indexOf(searchWord,_loc9_);
      }
      return _loc4_;
   }
}
