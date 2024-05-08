package com.company.util
{
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import flash.xml.XMLNodeType;
   
   public class HTMLUtil
   {
       
      
      public function HTMLUtil()
      {
         super();
      }
      
      public static function unescape(str:String) : String
      {
         return new XMLDocument(str).firstChild.nodeValue;
      }
      
      public static function escape(str:String) : String
      {
         return XML(new XMLNode(XMLNodeType.TEXT_NODE,str)).toXMLString();
      }
   }
}
