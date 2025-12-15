// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Bloom_Con_Ruido"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_EdgeColor("EdgeColor", Color) = (0,0,0,0)
		_Size("Size", Float) = 95
		_PowerShine("PowerShine", Range( 0 , 10)) = 2
		_FPower("FPower", Range( 0 , 1)) = 0.2

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Size;
			uniform float4 _EdgeColor;
			uniform float _FPower;
			uniform float _PowerShine;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord4.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord5.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float3 ase_worldPos = i.ase_texcoord4.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 normalizeResult26 = normalize( ase_worldViewDir );
				float3 ase_worldNormal = i.ase_texcoord5.xyz;
				float3 normalizeResult25 = normalize( ase_worldNormal );
				float dotResult27 = dot( normalizeResult26 , normalizeResult25 );
				float4 lerpResult36 = lerp( tex2D( _MainTex, ( floor( ( i.uv.xy * _Size ) ) / _Size ) ) , _EdgeColor , pow( ( 1.0 - dotResult27 ) , _FPower ));
				

				finalColor = ( lerpResult36 * _PowerShine );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
1190;73;1369;1278;2644.153;1229.441;2.54642;True;False
Node;AmplifyShaderEditor.CommentaryNode;43;-1741.637,288.359;Inherit;False;972.3447;387.2294;Comment;8;26;23;24;25;27;28;29;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-1823.969,-587.7423;Inherit;False;1171.03;552.8745;Comment;7;41;40;31;32;33;34;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;31;-1681.262,-391.4174;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-1773.969,-216.4989;Inherit;False;Property;_Size;Size;1;0;Create;True;0;0;0;False;0;False;95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;24;-1691.637,492.5878;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;23;-1664.75,338.3589;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;26;-1478.917,354.0017;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1460.862,-286.4666;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;25;-1472.169,498.5148;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;27;-1276.589,402.3795;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;34;-1306.935,-279.4699;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;41;-1186.341,-537.7423;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;28;-1131.126,398.4013;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1234.459,520.1949;Inherit;False;Property;_FPower;FPower;3;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;-1133.765,-232.2415;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;40;-972.9388,-264.8679;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;29;-946.2926,396.1023;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-1638.331,13.75346;Inherit;False;Property;_EdgeColor;EdgeColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-407.8802,217.9608;Inherit;False;Property;_PowerShine;PowerShine;2;0;Create;True;0;0;0;False;0;False;2;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;36;-278.5005,16.39218;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-114.4259,22.63045;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;76.22453,4.917712;Float;False;True;-1;2;ASEMaterialInspector;0;2;Bloom_Con_Ruido;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;26;0;23;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;25;0;24;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;34;0;33;0
WireConnection;28;0;27;0
WireConnection;35;0;34;0
WireConnection;35;1;32;0
WireConnection;40;0;41;0
WireConnection;40;1;35;0
WireConnection;29;0;28;0
WireConnection;29;1;30;0
WireConnection;36;0;40;0
WireConnection;36;1;39;0
WireConnection;36;2;29;0
WireConnection;37;0;36;0
WireConnection;37;1;38;0
WireConnection;0;0;37;0
ASEEND*/
//CHKSM=B622122AF394CA6675E58E01B8CFA267AAD2BA00