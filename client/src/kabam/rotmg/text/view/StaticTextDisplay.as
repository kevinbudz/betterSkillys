// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//kabam.rotmg.text.view.StaticTextDisplay

package kabam.rotmg.text.view
{
    import kabam.rotmg.core.StaticInjectorContext;
    import org.swiftsuspenders.Injector;
    import kabam.rotmg.text.model.FontModel;
    import kabam.rotmg.text.model.TextAndMapProvider;

    public class StaticTextDisplay extends TextDisplay 
    {

        public function StaticTextDisplay()
        {
            var _local_1:Injector = StaticInjectorContext.getInjector();
            super(_local_1.getInstance(FontModel), _local_1.getInstance(TextAndMapProvider));
        }

    }
}//package kabam.rotmg.text.view

