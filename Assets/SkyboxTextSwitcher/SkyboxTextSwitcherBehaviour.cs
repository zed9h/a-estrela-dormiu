using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class SkyboxTextSwitcherBehaviour : PlayableBehaviour
{
    public float Fade;
    public float Row;

    public override void OnPlayableCreate (Playable playable)
    {
        
    }
}
