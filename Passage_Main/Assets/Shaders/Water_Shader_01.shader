Shader "Test/Water_01"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DynamicTex("Texture", 2D) = "white" {}

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma glsl
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float3 wPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _DynamicTex;
			float4 _DynamicTex_ST;

			fixed4 dyno;

			v2f vert (appdata_full v)
			{
				v2f o;
				o.wPos =  mul(unity_ObjectToWorld, v.vertex).xyz;
				dyno = tex2Dlod(_DynamicTex, float4(v.texcoord.xy, 0.0,0.0));
				if(distance(o.wPos, _WorldSpaceCameraPos) > 128)
				dyno.a = 0;

				v.vertex.y += 1 - dyno.a * 10;
				v.vertex.z -=  dyno.a * 10;
				v.vertex.z +=  dyno.a * 10;

				float A = 5;
				float L = 50;
				float w = 2 * 3.1416 / L;
				float Q = 0.5;

				float3 p0 = v.vertex.xyz;
				float2 D = float2(0, 1);
				float dotD = dot(p0.xz, D);
				float C = cos(w * dotD + _Time.y /100);
				float S = sin(w * dotD + _Time.y /100);

				float3 P = float3 (p0.x + Q * A * C * D.x, A * S, p0.z + Q * A * C * D.y);
				 
				//v.vertex.y *= 1 - dyno.a;
				o.pos = mul(UNITY_MATRIX_MVP, float4(P, 1));
				o.uv = v.texcoord;
				


				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 main = tex2D(_MainTex, i.uv);
				fixed4 dynoSmoke = tex2D(_DynamicTex, i.uv);

				if(distance(i.wPos, _WorldSpaceCameraPos) > 241)
				dynoSmoke.a = 0;//lerp(0, dynoSmoke.a, distance(i.wPos, _WorldSpaceCameraPos) /241);

				fixed4 col = main + dynoSmoke.a;
				return col;
			}
			ENDCG
		}

	}
}
