// Upgrade NOTE: commented out 'float3 _WorldSpaceCameraPos', a built-in variable
// Good Color 5BA6C8FF

Shader "Custom/SkyFromSpace"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_fSamples("Number Of Scatter's", Float) = 1.0
		_fScaleDepth("Depth Scale", Float) = 1.0
		_ESun("Enviroment Sun", Float) = 1.0
		_fOuterRadius("Outer Radius", Float) = 1.0
		_fInnerRadius("Inner Radius", Float) = 1.0
		_Kr("KR", Float) = 1.0
		_Km("Km", Float) = 1.0
		_G("G", Float) = 0.0
	} 

	SubShader
	{
	Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		
	const float PI = 3.14159265f;
	//user defined verables
	uniform fixed4 _Color;

	//The Cameras current Position
	uniform sampler2D _MainTex;
	uniform float4 _MainTex_ST;

	uniform float3 _viewDir; //View Direction
	uniform float3 _lightDir; //Direction of the Light
	uniform float _fCameraHeight; //The Camera's current height
	uniform float3 _v3InWaveLength; // 1 / pow(waveLength, 4) for RGB
	uniform float4 _waveLength; //WaveLength Colors
	uniform float _fCameraHeight2; //fCameraHeight^2
	uniform float _fOuterRadius; //The outer(atmosphere) radius
	uniform float _fOuterRadius2; //fOuterRadius^2
	uniform float _fInnerRadius; //The inner (planetery) radius
	uniform float _fInnerRadius2; //fInnerRadius^2
	uniform float _fInvScaleDepth;
	uniform float _ESun;
	uniform float _Kr;
	uniform float _Km;
	uniform float _fKrESun; // Kr * ESun
	uniform float _fKmESun; // Km * Esun
	uniform float _fKr4PI; // Kr * 4 * PI
	uniform float _fKm4PI; // Km * 4 * PI
	uniform float _fScale; //1 / (fInnerRadius - fInnerRadius)
	uniform float _fScaleOverScaleDepth; //fScale / fScaleDepth
	uniform float _fScaleDepth;
	uniform float _fSamples;
	uniform float _nSamples;
	uniform float _G;
	uniform float _G2;
	uniform float3 _LightDir;

	float getMiePhase(float fCos, float FCos2, float g, float g2)
	{
		return 1.5 * ((1.0 - g2) / (2.0 + g2)) * (1.0 + FCos2) / pow(abs(1.0 + g2 - 2.0 * g * fCos), 1.5);
	}

	float getRayleighPhase(float fCos2)
	{
		return 0.75 + 0.75 * fCos2;
	}

	float getNearIntersection(float3 pos, float3 ray, float distance2, float radius2)
	{
		float B = 2.0 * dot(pos, ray);
		float C = distance2 - radius2;
		float det = max(0.0, B*B - 4.0 * C);
		return 0.5 * (-B - sqrt(det));
	} 
	//
	float scale(float cos)
	{
		float x = 1 - cos;
		return _fScale * exp(-0.00287 + x * (0.459 + x * (3.83 + x * (-6.80 + x * 5.25))));
	}

	struct v2f
	{
		float4 pos : SV_POSITION;
		float4 c0 : COLOR0;
		float4 c1 : COLOR1;
		float3 t0 : TEXCOORD0;
		float4 tex : TEXCOORD1;
	};

	v2f vert(appdata_full v)
	{
		//Get the ray from the camera to the vertex and its length (which
		// is the far point of the ray passing through the atmosphere)

		_fCameraHeight = _WorldSpaceCameraPos.xyz;
		_fCameraHeight2 = pow(_fCameraHeight, 2); 


		float3 v3Pos =  v.vertex.xyz;
		float3 v3Ray = (_WorldSpaceCameraPos - v3Pos);
		float fFar = length(v3Ray);
		v3Ray /= fFar;

		//Calculate the closest intersection of the ray with
		//the outher atmosphere

		float fNear = getNearIntersection(_WorldSpaceCameraPos, v3Ray, _fCameraHeight2,
		 _fOuterRadius2);

		 //Calulate the rays start and end positions in the atmosphere,
		 //then calculate its scattering offset

		 float3 v3Start = _WorldSpaceCameraPos.xyz + v3Ray * fNear;
		 fFar -= fNear;

		 float fStartAngle = 1;
		 float fStartDepth = exp (-_fInvScaleDepth);
		 float fStartOffset = fStartDepth * scale(fStartAngle);

		 float fSampleLength = fFar / _fSamples;
		 float fScaledLength = fSampleLength * _fScale;
		 float3 v3SampleRay = v3Ray * fSampleLength;
		 float3 v3SamplePoint = v3Start + v3SampleRay * 0.5;


		 //Now loop through the sample points
		float3 v3FrontColor = float3(0.0,0.0,0.0);

		half4 posWorld = mul(unity_ObjectToWorld, v.vertex);
		 _viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld.xyz);
		 half3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - posWorld.xyz;

		 _LightDir = normalize(_WorldSpaceLightPos0.xyz);//float4(
					 //normalize(lerp(_WorldSpaceLightPos0.xyz, fragmentToLightSource, _WorldSpaceLightPos0.w)),
					 //lerp(1.0, 1.0/length(fragmentToLightSource), _WorldSpaceLightPos0.w)
					 //);


		 for(int i = 0; i < 2; i++)
		 { 
			float fHeight = length(v3SamplePoint);
			float fDepth = exp(_fScaleOverScaleDepth * (_fInnerRadius -fHeight)); 
			float fLightAngle = dot(_WorldSpaceLightPos0.xyz, v3SamplePoint) / fHeight;
			float fCameraAngle = dot(v3Ray, v3SamplePoint) / fHeight;
			float fScatter = (fStartOffset + fDepth * (scale(_LightDir.xyz) - 
													   scale(fCameraAngle)));

			float3 v3Attenuate = scale(-fScatter *
										(_v3InWaveLength * _fKr4PI + _fKm4PI));

			v3FrontColor += v3Attenuate * (fDepth * fScaledLength);
			v3SamplePoint += v3SampleRay;
		}

		//Finally, scale the Mie and Rayleigh colors;
		v2f o;
		
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.t0 = normalize(_WorldSpaceCameraPos - v3Pos);
		o.c0.rgb = v3FrontColor * (_v3InWaveLength.xyz * _fKrESun);
		o.c1.rgb = v3FrontColor * _fKmESun;
		o.tex = v.texcoord;
		return o;
	}

	fixed4 frag(v2f i) : SV_TARGET
	{
		float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);

		float fCos = dot(_WorldSpaceLightPos0.xyz, i.t0) / length(i.t0);
		float fCos2 = fCos * fCos;

		float4 color = (getRayleighPhase(fCos2) * i.c0) + (getMiePhase(fCos, fCos2, _G, _G2) * i.c1) + tex;

		return color;
	}
		ENDCG
	}
}
}
