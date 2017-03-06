using UnityEngine;
using System.Collections;

public class Atmosphere_Manager : MonoBehaviour
{
    [Range(0.0f , -0.1f)]
    public float KM_Range = -.0015f;

    [Range(0.000f, 0.002f)]
    public float KR_Range = .0015f;

    Material skyMat;

    void Start ()
    {
        skyMat = GetComponent<MeshRenderer>().material;
    }

    void Update()
    {
        skyMat.SetFloat("_Km", KM_Range);
        skyMat.SetFloat("_Kr", KR_Range);
    }

}
