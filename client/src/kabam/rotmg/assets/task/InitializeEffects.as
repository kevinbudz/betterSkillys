// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//kabam.rotmg.assets.task.InitializeEffects

package kabam.rotmg.assets.task
{
    import kabam.lib.tasks.BaseTask;
    import com.company.assembleegameclient.objects.particles.ThunderEffect;
    import com.company.assembleegameclient.objects.particles.OrbEffect;

    public class InitializeEffects extends BaseTask 
    {


        override protected function startTask():void
        {
            //ThunderEffect.initialize();
            //OrbEffect.initialize();
            completeTask(true);
        }


    }
}//package kabam.rotmg.assets.task

