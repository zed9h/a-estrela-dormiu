using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;
using UnityEngine.XR;

public class MainController : MonoBehaviour
{
    public PlayableDirector timeline;
    public float renderScale = 1.4f;
    public Transform cam;
    public Text log;

    public void Recenter() {
        InputTracking.Recenter();
    }

    void Start()
    {
        UnityEngine.XR.XRSettings.eyeTextureResolutionScale = renderScale;

        InputTracking.disablePositionalTracking = true;
        XRDevice.SetTrackingSpaceType(TrackingSpaceType.Stationary);
        cam.localPosition = Vector3.zero;
        Recenter();

        if (timeline == null) timeline = GetComponentInParent<PlayableDirector>();
    }

    private void Update() {
        if(Input.GetMouseButton(0) || Input.anyKeyDown) {
            Recenter();
            timeline.time = 0;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        Recenter();
    }

}
