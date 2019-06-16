using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(0.1401745f, 0.3259392f, 0.6603774f)]
[TrackClipType(typeof(SkyboxTextSwitcherClip))]
[TrackBindingType(typeof(Skybox))]
public class SkyboxTextSwitcherTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
        return ScriptPlayable<SkyboxTextSwitcherMixerBehaviour>.Create (graph, inputCount);
    }
}
