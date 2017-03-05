// Upgrade NOTE: commented out 'float3 _WorldSpaceCameraPos', a built-in variable
// Good Color 5BA6C8FF

Shader "Custom/Sky_Shader"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_fSamples("Number Of Samples", Float) = 1.0
		_nSamples("Number Of Interations", Float) = 1.0
		_fScaleDepth("Depth Scale", Float) = 1.0
		_ESun("Enviroment Sun", Float) = 1.0
		_fOuterRadius("Outer Radius", Float) = 1.0
		_fInnerRadius("Inner Radius", Float) = 1.0
		_Kr("KR", Float) = 1.0
		_Km("Km", Float) = 1.0
		_G("G", Float) = 0.0
		_G2("G2", Float) = 0.0
	} 

	SubShader
	{
	Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		

	//user defined verables
	uniform fixed4 _Color;

	//The Cameras current Position
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
	float expScale(float cos)
	{
		float x = 1 - cos;
		return _fScale * exp(-0.00287 + x * (0.459 + x * (3.83 + x * (-6.80 + x * 5.25))));
	}

	struct v2f
	{
		float4 pos : SV_POSITION;
		half4 c0 : COLOR0;
		half4 c1 : COLOR1;
		half3 t0 : TEXCOORD0;
		float3 lightDir : TEXCOORD1;
	};

	v2f vert(appdata_full v)
	{
			v2f o;
		//Get the ray from the camera to the vertex and its length (which
		// is the far point of the ray passing through the atmosphere)

		float PI = 3.14159265f;
		_fCameraHeight = _WorldSpaceCameraPos.y;
		_fCameraHeight2 = pow(_fCameraHeight, 2); 
		_fOuterRadius2 = pow(_fOuterRadius, 2);
		_fInnerRadius2 = pow(_fInnerRadius, 2);
		_fInvScaleDepth = 1.0f / _fScaleDepth;
		_fKrESun = _Kr * _ESun;
		_fKmESun = _Km * _ESun;
		_fKr4PI = _Kr * 4 * PI;
		_fKm4PI = _Km * 4 * PI;
		//_G2 = pow(_G, 2);

		_fScale = 1 / (_fOuterRadius - _fInnerRadius);
		_fScaleOverScaleDepth = _fScale / _fScaleDepth;


		float3 v3Pos =  mul(unity_ObjectToWorld, v.vertex);
		float3 v3Ray = _WorldSpaceCameraPos - v3Pos;
		float fFar = length(v3Ray);
		v3Ray /= fFar;


		_v3InWaveLength = float3(
		1.0f / pow(0.650f, 4),
		1.0f / pow(0.570f, 4),
		1.0f / pow(0.475f, 4));

		//Calculate the closest intersection of the ray with
		//the outher atmosphere

		float fNear = getNearIntersection(_WorldSpaceCameraPos, v3Ray, _fCameraHeight2,
		 _fOuterRadius2);

		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		 //Calulate the rays start and end positions in the atmosphere,
		 //then calculate its scattering offset

		 float3 v3Start = _WorldSpaceCameraPos + v3Ray * fNear;
		 fFar -= fNear;

		 float fStartAngle = 1;
		 float fStartDepth = exp (-_fInvScaleDepth);
		 float fStartOffset = fStartDepth * expScale(fStartAngle);

		 float fSampleLength = fFar / _fSamples;
		 float fScaledLength = fSampleLength * _fScale;
		 float3 v3SampleRay = v3Ray * fSampleLength;
		 float3 v3SamplePoint = v3Start + v3SampleRay * 0.5;


		 //Now loop through the sample points
		float3 v3FrontColor = float3(0.0,0.0,0.0);

		half4 posWorld = mul(unity_ObjectToWorld, v.vertex);
		 _viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld.xyz);
		 half3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - posWorld.xyz;

		o.lightDir = fixed4(
		 normalize(lerp(_WorldSpaceLightPos0.xyz, fragmentToLightSource, _WorldSpaceLightPos0.w)),
		 lerp(1.0, 1.0/length(fragmentToLightSource), _WorldSpaceLightPos0.w)
		 );


		 for(int i = 0; i < 2; i++)
		 { 
			float fHeight = length(v3SamplePoint);
			float fDepth = exp(_fScaleOverScaleDepth * (_fInnerRadius -fHeight)); 
			float fLightAngle = dot(o.lightDir.xyz, v3SamplePoint) / fHeight;
			float fCameraAngle = dot(v3Ray, v3SamplePoint) / fHeight;
			float fScatter = (fStartOffset + fDepth * (expScale(o.lightDir.xyz) - 
													  expScale(fCameraAngle)));

			float3 v3Attenuate = expScale(-fScatter *
										(_v3InWaveLength * _fKr4PI + _fKm4PI));

			v3FrontColor += v3Attenuate * (fDepth * fScaledLength);
			v3SamplePoint += v3SampleRay;
		}

		//Finally, scale the Mie and Rayleigh colors;

		o.t0 = _WorldSpaceCameraPos - v3Pos;
		o.c0.rgb = v3FrontColor * (_v3InWaveLength.xyz * _fKrESun);
		o.c1.rgb = v3FrontColor * _fKmESun;
		 
		return o;
	}

	fixed4 frag(v2f i) : SV_TARGET
	{
		float fCos = dot(i.lightDir, i.t0) / length(i.t0);
		float fCos2 = fCos * fCos;

		float4 color = getRayleighPhase(fCos2) + i.c0 + getMiePhase(fCos, fCos2, _G, _G2) * i.c1;

		return color;
	}
		ENDCG
	}
}
}
