package kabam.rotmg.core.view
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class BadDomainView extends Sprite
   {
      
      private static const BAD_DOMAIN_TEXT:String = "<p align=\"center\"><font color=\"#FFFFFF\">Play at: " + "<br/></font><font color=\"#7777EE\">" + "<a href=\"http://www.realmofthemadgod.com/\">" + "www.realmofthemadgod.com</font></a></p>";
       
      
      public function BadDomainView()
      {
         super();
         var textField:TextField = new TextField();
         textField.selectable = false;
         var textFormat:TextFormat = new TextFormat();
         textFormat.size = 20;
         textField.defaultTextFormat = textFormat;
         textField.htmlText = BAD_DOMAIN_TEXT;
         textField.width = 800;
         textField.y = 600 / 2 - textField.height / 2;
         addChild(textField);
      }
   }
}
