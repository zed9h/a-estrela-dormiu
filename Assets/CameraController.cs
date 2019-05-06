using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public float renderScale = 1.4f;

    public void Recenter() {
        UnityEngine.XR.InputTracking.Recenter();
    }

    void Start()
    {
        UnityEngine.XR.XRSettings.eyeTextureResolutionScale = renderScale;
        Recenter();
    }

    private void Update() {
        if(Input.GetMouseButton(0) || Input.anyKeyDown) {
            Recenter();
        }
    }

}
