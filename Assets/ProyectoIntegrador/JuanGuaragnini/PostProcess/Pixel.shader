// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Pixel"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_PixelX("Pixel X", Range( 0 , 5000)) = 32
		_PixelY("Pixel Y", Range( 0 , 5000)) = 32

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
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _PixelX;
			uniform float _PixelY;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
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
				float2 texCoord22 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float pixelWidth21 =  1.0f / _PixelX;
				float pixelHeight21 = 1.0f / _PixelY;
				half2 pixelateduv21 = half2((int)(texCoord22.x / pixelWidth21) * pixelWidth21, (int)(texCoord22.y / pixelHeight21) * pixelHeight21);
				

				finalColor = ( 1.0 - tex2D( _MainTex, pixelateduv21 ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
1552;73;1007;1278;691.126;385.6246;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1093.052,162.2842;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-1223.164,360.6251;Inherit;False;Property;_PixelY;Pixel Y;1;0;Create;True;0;0;0;False;0;False;32;5;0;5000;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1225.166,289.4697;Inherit;False;Property;_PixelX;Pixel X;0;0;Create;True;0;0;0;False;0;False;32;5;0;5000;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;21;-828.0521,226.2842;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;20;-705.5305,144.7559;Inherit;False;0;0;_MainTex;Shader;True;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-487.1033,183.165;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;24;-170.8298,187.4511;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;16,186;Float;False;True;-1;2;ASEMaterialInspector;0;2;Pixel;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;21;0;22;0
WireConnection;21;1;23;0
WireConnection;21;2;25;0
WireConnection;19;0;20;0
WireConnection;19;1;21;0
WireConnection;24;0;19;0
WireConnection;0;0;24;0
ASEEND*/
//CHKSM=8DE175109DEB663AE2BB303AF7DCA8DA705EB91C