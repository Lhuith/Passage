using UnityEngine;
using System.Collections;
using System.Linq;
using System.Collections.Generic;
public class SpectrumAnalyzer : MonoBehaviour {

	GameObject[] cubes, spheres;
	public List<GameObject> cellList = new List<GameObject>();
	Vector3 cubeScale, sphereScale;
    MeshRenderer meshColor;
	public float freqBoost, cellfreqBoost;
	AudioClip[] songs;
	public AudioClip CurrentSong;
	MusicLoad musicListLoad;
	public AudioSource AudPlayer;
	int counter;
    [HideInInspector]
    public bool isPause, isPlay, musicMode;
    public float colorDivder;
    public Material one, two, three;

    public float curtimer, durtimer;

    public static float pump;

	// Use this for initialization
	void Awake ()
    {
        Application.runInBackground = true;
		cubes = GameObject.FindGameObjectsWithTag ("Cubes");

	}
	
    void Start()
    {
        songs = MusicLoad.songslist;
        CurrentSong = songs[0];
        AudPlayer = GetComponent<AudioSource>();
        counter = 0;

        if (musicMode)
        {
            PlaySong();
        }
    }

	// Update is called once per frame
	void Update ()
    {
        if(AudPlayer.clip == null)
        {
            PlaySong();
        }
		if (!AudPlayer.isPlaying) {
			if(isPlay){
			NextSong();
			}
		}
			
		cubeScale = new Vector3 (1,1,1);
		sphereScale = new Vector3 (1,1,1);
		//float[] spectrum = AudioListener.GetOutputData(1024, 0);

		//cubes = GameObject.FindGameObjectsWithTag ("Cubes");
		float[] spectrum = AudioListener.GetSpectrumData (1024, 0, FFTWindow.Hamming);


		//Cubes
		float c0 = spectrum[1] + spectrum[2];
		float c022 = spectrum[2] + spectrum[3];
		float c025 = spectrum[3] + spectrum[4];
		float c1 = spectrum[4] + spectrum[5];
		float c2 = spectrum[4] + spectrum[5] + spectrum[6];
		float c22 = spectrum[6] + spectrum[7]+ spectrum[8];
		float c25 = spectrum[7] + spectrum[8] + spectrum[9];
		float c3 = spectrum[9] + spectrum[10] + spectrum[11];
		float c32 = spectrum[11] + spectrum[12] + spectrum[13];
		float c35 = spectrum[13] + spectrum[14] + spectrum[15];
		float c4 = spectrum[15] + spectrum[16] + spectrum[17];
		float c42 = spectrum [17] + spectrum [18] + spectrum [19];
		float c45 = spectrum[19] + spectrum[20] + spectrum[21];
		float c47 = spectrum[21] + spectrum[22] + spectrum[23];
		float c5 = spectrum[23] + spectrum[24] + spectrum[25];
		float c55 = spectrum [25] + spectrum [26] + spectrum [27];
		float c6 = spectrum [27] + spectrum [28] + spectrum [29];
		float c62 = spectrum [29] + spectrum [30] + spectrum [31];
		float c65 = spectrum [31] + spectrum [32] + spectrum [33];
		float c67 = spectrum [33] + spectrum [34] + spectrum [35];
		float c7 = spectrum [35] + spectrum [36] + spectrum [37];
		float c72 = spectrum [37] + spectrum [38] + spectrum [39];
		float c75 = spectrum [39] + spectrum [41] + spectrum [41];
		float c77 = spectrum [41] + spectrum [42] + spectrum [43];
		float c8 = spectrum [43] + spectrum [44] + spectrum [45];
		float c82 = spectrum [45] + spectrum [46] + spectrum [47];
		float c85 = spectrum [47] + spectrum [48] + spectrum [49];
		float c87 = spectrum [49] + spectrum [50] + spectrum [51];
		float c9 = spectrum [51] + spectrum [52] + spectrum [53];
		float c92 = spectrum [53] + spectrum [54] + spectrum [55];

         pump = ((c0 + c022 + c025 + c1 + c2 + c22 + c25 + c3 + c32 + c35 + c4 + c42 + c45 + c47 +
            c5 + c55 + c6 + c62 + c65 + c67 + c7 + c72 + c75 + c77 + c8 + c82 + c85 + c87 + c9 + c92) / 30) * freqBoost;
        MapGenerator mapGen = FindObjectOfType<MapGenerator>();
        mapGen.GenerateFunk(pump);

        for (int i = 0; i < cubes.Length; i++) {
			switch (cubes [i].name)
            {
			case "C0":
				cubeScale.y = c0 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c0 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C022":
				cubeScale.y = c022 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c022 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C025":
				cubeScale.y = c025 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c025 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C1":
				cubeScale.y = c1 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c1 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C2":
				cubeScale.y = c2 * freqBoost;
				//windPower0 = c2;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c2 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C22":
				cubeScale.y = c22 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c22 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C25":
				cubeScale.y = c25 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c25 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C3":
				cubeScale.y = c3 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c3 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C32":
				cubeScale.y = c32 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c32 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C35":
				cubeScale.y = c35 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c35 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C4":
				cubeScale.y = c4 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c4 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C42":
				cubeScale.y = c42 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c42 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C45":
				cubeScale.y = c45 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c45 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C47":
				cubeScale.y = c47 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c47 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C5":
				cubeScale.y = c5 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c5 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C55":
				cubeScale.y = c55 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c55 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C6":
				cubeScale.y = c6 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c6 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C62":
				cubeScale.y = c62 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c62 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C65":
				cubeScale.y = c65 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c65 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C67":
				cubeScale.y = c67 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c67 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C7":
				cubeScale.y = c7 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c7 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C72":
				cubeScale.y = c72 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c72 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C75":
				cubeScale.y = c75 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c75 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C77":
				cubeScale.y = c77 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c77 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C8":
				cubeScale.y = c8 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c8 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C82":
				cubeScale.y = c82 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c82 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C85":
				cubeScale.y = c85 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c85 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C87":
				cubeScale.y = c87 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c87 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C9":
				cubeScale.y = c9 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c9 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;
			case "C92":
				cubeScale.y = c92 * freqBoost;
				cubes [i].transform.localScale = cubeScale;
				GetVolumeColor (c92 * 10, cubes [i].transform.GetComponent<MeshRenderer> ());
				break;

				
			}
		}
		if (cellList.Count > 0)
        {
			for (int i = 0; i < cellList.Count; i++)
            {
				switch (cellList [i].name)
                {
				case "Cell":
                        GetVolumeColor (c0 * 10, cellList [i].transform.GetComponent<MeshRenderer> ());
                        break;
					
				}
			}
		}


		//Debug.Log("LOW: " + spectrum[0]);
		/* c1 = 64hz
		 * c3 = 256hz
		 * c4 = 512hz
		 * c5 = 1024hz
		 * 
		 * 
*/
	}
	public void PlaySong(){
		AudPlayer.clip = CurrentSong;
		AudPlayer.Play ();
		isPlay = true;
	}
	public void NextSong()
    {
		if (counter <= songs.Length)
        {
            cellList.Clear();
			counter ++;
			CurrentSong = songs [counter];
			AudPlayer.clip = CurrentSong;
			PlaySong ();
		}
	}
	public void PrevSong(){
		if (counter > 0) {
			counter --;
			CurrentSong = songs [counter % songs.Count()];
			AudPlayer.clip = CurrentSong;
			PlaySong ();
		}
	}
	public void PauseSong(){
		AudPlayer.Pause ();
		isPlay = false;
	}

	void GetVolumeColor (float volume, MeshRenderer meshcolor)
    {
		Color tempCol = new Color(meshcolor.material.color.r, meshcolor.material.color.g, meshcolor.material.color.b, 1.0f);

		if (volume > 1f)
        {
            curtimer = 0;
            curtimer += Time.deltaTime;
            // meshcolor.material.color = two.color;
            meshcolor.material.color = Color.Lerp(meshcolor.material.color, three.color, 1);

            if (meshcolor.tag == "Cubes")
            {
				meshcolor.material.SetColor ("_EmissionColor", tempCol / colorDivder);
			}
            else
            {
                meshcolor.material.SetColor("_EmissionColor", tempCol / colorDivder);
                meshcolor.material.SetFloat("_EmissionScaleUI", 1f);
            }

		}

        else if (volume > .5f)
        {
            curtimer = 0;
            curtimer += Time.deltaTime;
           // meshcolor.material.color = two.color;
            meshcolor.material.color = Color.Lerp(meshcolor.material.color, two.color, 1);

            if (meshcolor.tag == "Cubes")
            {
                meshcolor.material.SetColor("_EmissionColor", tempCol / colorDivder / 0.5f);
                meshcolor.material.SetFloat("_EmissionScaleUI", .3f);
            }
            else
            {
                meshcolor.material.SetColor("_EmissionColor", tempCol / colorDivder/ 0.5f);
                meshcolor.material.SetFloat("_EmissionScaleUI", .3f);
            }
		}
        else if (volume > .2f)
        {
            curtimer = 0;
            curtimer += Time.deltaTime;
            // meshcolor.material.color = two.color;
            meshcolor.material.color = Color.Lerp(meshcolor.material.color, one.color, 1);

            if (meshcolor.tag == "Cubes")
            {
				meshcolor.enabled = true;
				meshcolor.GetComponent<isActive> ().active = true;
                meshcolor.material.SetColor("_EmissionColor", tempCol / colorDivder / 0.2f);
                meshcolor.material.SetFloat("_EmissionScaleUI", .3f);
            }
            else
            {
			   meshcolor.material.SetColor("_EmissionColor", tempCol / colorDivder / 0.2f);
			   meshcolor.material.SetFloat("_EmissionScaleUI", .3f);
			}
			meshcolor.enabled = true;
		}
        else
        {      
			if(meshcolor.tag == "Cubes")
            {
			meshcolor.GetComponent<isActive>().active = false;
			}
			meshcolor.enabled = false;
		}
	}

	void MeshChange(float volume, MeshRenderer meshcolor){
		if (volume > 5f) {
		
		} else if (volume > 2f) {

		} else if (volume <= 0f) {
		}
		else if (volume > .1f) {
			//meshcolor.enabled = true;
		}else {
			//meshcolor.enabled = false;
		}
	}



}
