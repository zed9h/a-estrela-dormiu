using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayClip : MonoBehaviour
{
    private AudioSource theAudioSource;

    private void Start()
    {
        theAudioSource = GetComponent<AudioSource>();

    }
    public void PlayAudio()
    {
        theAudioSource.Play();
    }
}
