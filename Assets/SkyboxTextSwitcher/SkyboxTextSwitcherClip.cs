using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class SkyboxTextSwitcherClip : PlayableAsset, ITimelineClipAsset
{
    public SkyboxTextSwitcherBehaviour template = new SkyboxTextSwitcherBehaviour ();

    public ClipCaps clipCaps
    {
        get { return ClipCaps.Blending; }
    }

    public override Playable CreatePlayable (PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<SkyboxTextSwitcherBehaviour>.Create (graph, template);
        SkyboxTextSwitcherBehaviour clone = playable.GetBehaviour ();
        return playable;
    }
}
