using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class SkyboxTextSwitcherMixerBehaviour : PlayableBehaviour
{
    // NOTE: This function is called at runtime and edit time.  Keep that in mind when setting the values of properties.
    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        Skybox trackBinding = playerData as Skybox;

        if (!trackBinding)
            return;

        int inputCount = playable.GetInputCount ();

        float fade = 0;
        float row = 0;

        for (int i = 0; i < inputCount; i++)
        {
            float inputWeight = playable.GetInputWeight(i);
            ScriptPlayable<SkyboxTextSwitcherBehaviour> inputPlayable = (ScriptPlayable<SkyboxTextSwitcherBehaviour>)playable.GetInput(i);
            SkyboxTextSwitcherBehaviour input = inputPlayable.GetBehaviour ();

            fade += input.Fade * inputWeight;
            if(inputWeight>0) row = input.Row;
        }

        Material mat = trackBinding.material;
        mat.SetFloat("_Fade", fade);
        mat.SetFloat("_Row", row);
    }
}
