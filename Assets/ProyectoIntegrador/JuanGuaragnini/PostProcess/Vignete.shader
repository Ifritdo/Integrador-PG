// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vignete"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Height("Height", Float) = 1
		_Width("Width", Float) = 1
		_PosX("PosX", Float) = 0.5
		_PosY("PosY", Float) = 0.5
		_Radius("Radius", Range( 0 , 2)) = 2
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
			
			uniform float _Radius;
			uniform float _Smoothness;
			uniform float _PosX;
			uniform float _PosY;
			uniform float _Width;
			uniform float _Height;


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
				float4 color41 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float temp_output_35_0 = ( _Radius - _Smoothness );
				float2 appendResult26 = (float2(_PosX , _PosY));
				float2 appendResult25 = (float2(_Width , _Height));
				float smoothstepResult38 = smoothstep( ( temp_output_35_0 + ( _Smoothness + 0.001 ) ) , temp_output_35_0 , distance( ( appendResult26 + ( ( i.uv.xy - appendResult26 ) / appendResult25 ) ) , appendResult26 ));
				float4 lerpResult39 = lerp( color41 , tex2D( _MainTex, uv_MainTex ) , smoothstepResult38);
				

				finalColor = lerpResult39;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
937;188;981;1029;2889.889;1780.064;3.221099;True;False
Node;AmplifyShaderEditor.RangedFloatNode;22;-1652.614,223.7879;Inherit;False;Property;_PosY;PosY;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1659.015,164.5878;Inherit;False;Property;_PosX;PosX;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1643.014,-81.81216;Inherit;False;Property;_Height;Height;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;27;-1716.613,22.18783;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;26;-1502.214,161.3878;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1647.814,-174.6122;Inherit;False;Property;_Width;Width;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-1369.414,81.38777;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-1489.415,-88.21216;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1499.772,471.916;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1320.772,573.916;Inherit;False;Constant;_Float2;Float 0;1;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1502.772,365.916;Inherit;False;Property;_Radius;Radius;4;0;Create;True;0;0;0;False;0;False;2;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-1262.206,-64.21192;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1101.772,491.916;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-1128.772,371.916;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1169.806,53.38802;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;20;-1163.589,-173.3252;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;31;-1033.772,149.916;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-926.7719,409.916;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-761.7719,256.916;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-920.4164,-48.43962;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;41;-840.1741,-266.0239;Inherit;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;39;-503.7719,166.916;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-238.7951,183.2135;Float;False;True;-1;2;ASEMaterialInspector;0;2;Vignete;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;26;0;21;0
WireConnection;26;1;22;0
WireConnection;28;0;27;0
WireConnection;28;1;26;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;29;0;28;0
WireConnection;29;1;25;0
WireConnection;36;0;33;0
WireConnection;36;1;34;0
WireConnection;35;0;32;0
WireConnection;35;1;33;0
WireConnection;30;0;26;0
WireConnection;30;1;29;0
WireConnection;31;0;30;0
WireConnection;31;1;26;0
WireConnection;37;0;35;0
WireConnection;37;1;36;0
WireConnection;38;0;31;0
WireConnection;38;1;37;0
WireConnection;38;2;35;0
WireConnection;40;0;20;0
WireConnection;39;0;41;0
WireConnection;39;1;40;0
WireConnection;39;2;38;0
WireConnection;0;0;39;0
ASEEND*/
//CHKSM=4420033B6B8D9915204B016A8195DF634E9FA44C