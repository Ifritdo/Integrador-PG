using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class ShaderMnger2 : MonoBehaviour
{
    private enum config
    {
        proyector,
        renderTexture,
        Distance,
        UI
    }
    [SerializeField] private config cfg;

    [Header("Distance Settings")]
    [SerializeField] private Material Distance;
    [SerializeField] private Material Flag;
    [SerializeField] private Material Ripple;

    [SerializeField] private Slider freq1;
    [SerializeField] private Slider freq2;
    [SerializeField] private Slider freq3;
    [SerializeField] private Slider tess1;
    [SerializeField] private Slider tess2;
    [SerializeField] private Slider edge;
    [SerializeField] private Slider radio;
    [SerializeField] private Slider fademin;
    [SerializeField] private Slider fademax;

    [Header("Proyector Settings")]
    [SerializeField] private Material ProyectorAOI;
    [SerializeField] private Material Highlight;

    [SerializeField] private Slider highlightwidth;

    [Header("UI Settings")]
    [SerializeField] private Material Distortion;
    [SerializeField] private Material Flow;
    [SerializeField] private Material Rotate;
    [SerializeField] private Material Shine;
    [SerializeField] private Material Lens;
    [SerializeField] private Material Dissolve;

    [SerializeField] private Slider distortintensity;
    [SerializeField] private Slider dissolveumbral;
    [SerializeField] private Slider lensIntensity;

    [Header("Render Settings")]
    [SerializeField] private Material Vignette;
    [SerializeField] private Material Pixel;
    [SerializeField] private Material Bloom;

    [SerializeField] private Slider vignettepower;
    [SerializeField] private Slider bloompower;
    [SerializeField] private Slider bloomshine;
    [SerializeField] private Slider bloomsize;
    [SerializeField] private Slider pixelDensity;

    public void Start()
    {
        switch (cfg)
        {
            case config.Distance: SetDistanceSettings(); break;
            case config.proyector: SetProyectorSettings(); break;
            case config.renderTexture: SetRenderSettings(); break;
            case config.UI: SetUISetting(); break;
            default: break;
        }
    }

    public void SetProyectorSettings() 
    {
        float HighlightWidth = Highlight.GetFloat("_Width");
    }

    public void changeProjHighlightWidth(float n) { Highlight.SetFloat("_Width",n); }




    public void SetUISetting() 
    {
        distortintensity.value = Distortion.GetFloat("_Intensity");
        dissolveumbral.value = Dissolve.GetFloat("_Umbral");
        lensIntensity.value = Lens.GetFloat("_Intensity");
    }

    public void changeDistortIntensity(float n) { Distortion.SetFloat("_Intensity",n); }
    public void changeDissolveUmbral(float n) { Dissolve.SetFloat("_Umbral",n);  }

    public void changeLensIntensity(float n) { Lens.SetFloat("_Intensity", n); }



    public void SetRenderSettings() 
    { 
        vignettepower.value = Vignette.GetFloat("_PowerMult");
        bloompower.value = Bloom.GetFloat("_FPower1");
        bloomshine.value = Bloom.GetFloat("_PowerShine1");
        bloomsize.value = Bloom.GetFloat("_Size1");
        pixelDensity.value = Pixel.GetFloat("_PixelDensity");
    }

    public void changePixelSize(float n) { Pixel.SetFloat("_PixelDensity", n); }
    public void changeBloomPower(float n) { Bloom.SetFloat("_PowerShine1", n); }
    public void changeBloomSize(float n) { Bloom.SetFloat("_Size1", n); }
    public void changeBloomIntensity(float n) { Bloom.SetFloat("_PowerShine1", n); }
    public void changeVignetteIntensity(float n) { Vignette.SetFloat("_PowerMult", n); }


    public void SetDistanceSettings() 
    {
        freq1.value = Distance.GetFloat("_Frequency");
        tess1.value = Distance.GetFloat("_TesselationScale");

        freq2.value = Flag.GetFloat("_Frequency");
        tess2.value = Flag.GetFloat("_TesselationScale");


        edge.value = Ripple.GetFloat("_Edge");
        radio.value = Ripple.GetFloat("_Radio");
        freq3.value = Ripple.GetFloat("_Frequency");
        fademin.value = Ripple.GetFloat("_FadeMin");
        fademax.value = Ripple.GetFloat("_FadeMax");
    }

    public void changefrequency1(float n){ Distance.SetFloat("_Frequency", n); }
    public void changefrequency2(float n) { Flag.SetFloat("_Frequency", n); }
    public void changefrequency3(float n) { Ripple.SetFloat("_Frequency", n); }
    public void changetess(float n) { Distance.SetFloat("_TesselationScale", n); }
    public void changetess2(float n) { Distance.SetFloat("_TesselationScale", n); }
    public void chengedge(float n) { Ripple.SetFloat("_Edge", n); }
    public void changeradio(float n) { Ripple.SetFloat("_Radio", n); }
    public void changefademin(float n) { Ripple.SetFloat("_FadeMin", n); }
    public void changefademax(float n) { Ripple.SetFloat("_FadeMax",n); }


}
