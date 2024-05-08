package kabam.rotmg.game.model
{
public class AddTextLineVO
{


   public var name:String;
   public var objectId:int;
   public var numStars:int;
   public var recipient:String;
   public var text:String;
   public var nameColor:int;
   public var textColor:int;

   public function AddTextLineVO(name:String, text:String, objectId:int = -1, numStars:int = -1, recipient:String = "", nameColor:int = 0, textColor:int = 0)
   {
      super();
      this.name = name;
      this.objectId = objectId;
      this.numStars = numStars;
      this.recipient = recipient;
      this.text = text;
      this.nameColor = nameColor;
      this.textColor = textColor;
   }
}
}
