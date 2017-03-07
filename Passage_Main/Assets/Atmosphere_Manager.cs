using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Atmosphere_Manager : MonoBehaviour
{
    public float KM_Range = 0.0015f;

    public float KR_Range = 0.0025f;

    Material skyMat;

    void Start ()
    {
        skyMat = GetComponent<MeshRenderer>().sharedMaterial;
    }

    void Update()
    {
        skyMat.SetFloat("_Km", KM_Range);
        skyMat.SetFloat("_Kr", KR_Range);

        float eSun = skyMat.GetFloat("_ESun");
        float fOuterRadius = skyMat.GetFloat("_fOuterRadius");
        float fInnerRadius = skyMat.GetFloat("_fInnerRadius");
        float fScaleDepth = skyMat.GetFloat("_fScaleDepth");      
        float fScale = 1 / (fOuterRadius - fInnerRadius);

        if(skyMat.shader.name == "Custom / SkyFromSpace")
        {
            float _G = skyMat.GetFloat("_G");
            skyMat.SetFloat("_G2", _G * _G);
        }

        Vector4 v3InWaveLength = new Vector4(
        1.0f / Mathf.Pow(0.650f, 4),
        1.0f / Mathf.Pow(0.570f, 4),
        1.0f / Mathf.Pow(0.475f, 4));
         
        skyMat.SetVector("_v3InWaveLength", v3InWaveLength);
        skyMat.SetFloat("_fKr4PI", KR_Range * 4 * Mathf.PI);
        skyMat.SetFloat("_fKm4PI", KM_Range * 4 * Mathf.PI);
        skyMat.SetFloat("_fKrESun", KR_Range * eSun);
        skyMat.SetFloat("_fKmESun", KM_Range * eSun);
        skyMat.SetFloat("_fOuterRadius2", (fOuterRadius * fOuterRadius));
        skyMat.SetFloat("_fInnerRadius2", (fInnerRadius * fInnerRadius));
        skyMat.SetFloat("_fScale", fScale);
        skyMat.SetFloat("_fInvScaleDepth", 1.0f / fScaleDepth);
        skyMat.SetFloat("_fScaleOverScaleDepth", fScale / fScaleDepth);
    }

}   
 