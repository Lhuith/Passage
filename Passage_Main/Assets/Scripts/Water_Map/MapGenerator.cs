using UnityEngine;
using System.Collections;

public class MapGenerator : MonoBehaviour {

    public int mapWidth;
    public int mapHeight;
    public float heightScale;

    public int octaves;
    [Range(0, 1)]
    public float persistance;
    public float lacunarity;

    public int seed;
    public Vector2 offset;

    public float meshHeightMultiplier;

    public bool autoUpdate;

    public MeshRenderer renderer;

    public MapDisplay display;

    public void GenerateMap()
    {
        //float[,] heightMap = HeightMap.GenerateHeightMap(mapWidth, mapHeight, seed, heightScale, octaves, persistance, lacunarity, offset);      
        //display.DrawMesh(MeshGenerator.GenerataTerrainMesh(heightMap, meshHeightMultiplier), TextureGenerator.TextureFromHeightMap(heightMap));
    }

    public void GenerateFunk(float VolumePump)
    {
        float[,] heightMap = HeightMap.GenerateHeightMap(mapWidth, mapHeight, seed, heightScale, octaves, persistance, lacunarity, offset);

        FunkyMeshGenerator funkyGen = GetComponent<FunkyMeshGenerator>();
        funkyGen.DrawFunkyMesh(mapWidth, mapHeight, seed, heightScale, octaves, persistance, lacunarity, offset, VolumePump);
    }

    public void Update()
    {
      
    }

    //void OnValidate()
    //{
    //    if(mapWidth < 1)
    //    {
    //        mapWidth = 1;
    //    }
    //
    //    if (mapHeight < 1)
    //    {
    //        mapHeight = 1;
    //    }
    //
    //    if (heightScale < 1)
    //    {
    //        heightScale = 1;
    //    }
    //
    //
    //    if (lacunarity < 1)
    //    {
    //        lacunarity = 1;
    //    }
    //
    //    if (octaves < 0)
    //    {
    //        octaves = 1;
    //    }
    //}
}
