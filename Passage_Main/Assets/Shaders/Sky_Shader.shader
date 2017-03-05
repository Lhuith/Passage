// Upgrade NOTE: commented out 'float3 _WorldSpaceCameraPos', a built-in variable
// Good Color 5BA6C8FF

Shader "Custom/Sky_Shader"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
	}

	SubShader
	{
	Pass{
		Tags{"LightMode" = "ForwardBase"}
		cull off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		

	//user defined verables
	uniform fixed4 _Color;

	//The Cameras current Position
    //Light Direction
	uniform float _fCameraHeight; //The Camera's current height
	uniform float _fCameraHeight2; //fCameraHeight^2
	uniform float _fOuterRadius; //The outer(atmosphere) radius
	uniform float _fOuterRadius2; //fOuterRadius^2
	uniform float _fInnerRadius; //The inner (planetery) radius
	uniform float _fInnerRadius2; //fInnerRadius^2
	uniform float _fKrESun; // Kr * ESun
	uniform float _fKmESun; // Km * Esun
	uniform float _fKr4PI; // Kr * 4 * PI
	uniform float _fKm4PI; // Km * 4 * PI
	uniform float _fScale; //1 / (fInnerRadius - fInnerRadius)
	uniform float _fScaleOverScaleDepth; //fScale / fScaleDepth

	//Get the ray from the camera to the vertex and its length (which
	// is the far point of the ray passing through the atmosphere)

	struct vertexInput
	{
		half4 vertex : POSITION;
	};

	struct vertexOutput
	{
		half4 pos : SV_POSITION;
		fixed4 lightDir : TEXCOORD0;
		fixed3 viewDir : TEXCOORD1;
	};

	float getNearIntersection(float3 pos, float3 ray, float distance2, float radius2)
	{
		float B = 2.0 * dot(pos, ray);
		float C = distance2 - radius2;
		float det = max(0.0, B*B - 4.0 * C);
		return 0.5 * (-B - sqrt(det));
	} 

	float expScale(float cos)
	{
		float x = 1 - cos;
		return _fScale * exp(-0.00287 + x * (0.459 + x * (3.83 + x * (-6.80 + x * 5.25))));
	}

	vertexOutput vert(vertexInput v)
	{
		vertexOutput o;

		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		half4 posWorld = mul(unity_ObjectToWorld, v.vertex);
		o.viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld.xyz);
		half3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - posWorld.xyz;
		o.lightDir = fixed4(
		normalize(lerp(_WorldSpaceLightPos0.xyz, fragmentToLightSource, _WorldSpaceLightPos0.w)),
		lerp(1.0, 1.0/length(fragmentToLightSource), _WorldSpaceLightPos0.w)
		);
		return o;
	}

	fixed4 frag(vertexOutput i) : COLOR
	{
		return _Color;
	}
		ENDCG
	}
}
}
