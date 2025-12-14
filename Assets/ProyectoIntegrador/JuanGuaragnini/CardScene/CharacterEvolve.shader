// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CharacterEvolve"
{
	Properties
	{
		_Evo("Evo", Int) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Texture2("Texture 2", 2D) = "white" {}
		_Texture3("Texture 3", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Texture4("Texture 4", 2D) = "white" {}
		_Texture1("Texture 1", 2D) = "white" {}
		_Texture5("Texture 5", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref 0
			Comp NotEqual
			Pass Keep
			Fail Keep
		}
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform sampler2D _Texture2;
		uniform float4 _Texture0_ST;
		uniform sampler2D _Texture1;
		uniform sampler2D _TextureSample2;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _Texture4;
		uniform sampler2D _Texture3;
		uniform float4 _Texture4_ST;
		uniform sampler2D _Texture5;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform int _Evo;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float2 MainUvs222_g1 = uv_Texture0;
			float4 tex2DNode65_g1 = tex2D( _Texture2, MainUvs222_g1 );
			float4 appendResult82_g1 = (float4(0.0 , tex2DNode65_g1.g , 0.0 , tex2DNode65_g1.r));
			float2 temp_output_84_0_g1 = (UnpackScaleNormal( appendResult82_g1, _Time.y )).xy;
			float2 temp_output_71_0_g1 = ( temp_output_84_0_g1 + MainUvs222_g1 );
			float4 tex2DNode96_g1 = tex2D( _Texture0, temp_output_71_0_g1 );
			float2 uv_Texture1232_g1 = i.uv_texcoord;
			float4 tex2DNode12 = tex2D( _TextureSample2, i.uv_texcoord );
			float4 temp_output_192_0_g1 = tex2DNode12;
			float4 tex2DNode17 = tex2D( _TextureSample1, i.uv_texcoord );
			float2 uv_Texture4 = i.uv_texcoord * _Texture4_ST.xy + _Texture4_ST.zw;
			float2 MainUvs222_g2 = uv_Texture4;
			float4 tex2DNode65_g2 = tex2D( _Texture3, MainUvs222_g2 );
			float4 appendResult82_g2 = (float4(0.0 , tex2DNode65_g2.g , 0.0 , tex2DNode65_g2.r));
			float2 temp_output_84_0_g2 = (UnpackScaleNormal( appendResult82_g2, _Time.y )).xy;
			float2 temp_output_71_0_g2 = ( temp_output_84_0_g2 + MainUvs222_g2 );
			float4 tex2DNode96_g2 = tex2D( _Texture4, temp_output_71_0_g2 );
			float2 uv_Texture5232_g2 = i.uv_texcoord;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_192_0_g2 = tex2D( _TextureSample0, uv_TextureSample0 );
			float4 lerpResult18 = lerp( ( ( ( tex2DNode96_g1 * tex2DNode96_g1.a * tex2D( _Texture1, uv_Texture1232_g1 ).g ) + temp_output_192_0_g1 ) + tex2DNode12 ) , ( tex2DNode17 + ( ( tex2DNode96_g2 * tex2DNode96_g2.a * tex2D( _Texture5, uv_Texture5232_g2 ).g ) + temp_output_192_0_g2 ) ) , (float)_Evo);
			o.Emission = lerpResult18.rgb;
			float lerpResult19 = lerp( tex2DNode12.a , tex2DNode17.a , (float)_Evo);
			o.Alpha = lerpResult19;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
917;73;1136;927;3575.03;978.1678;3.085104;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2276.695,93.96903;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;44;-2118.178,851.8557;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;43;-2166.203,948.5129;Inherit;True;Property;_Texture5;Texture 5;16;0;Create;True;0;0;0;False;0;False;None;6b6133586a4da544bab2f57e106d6ce5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;42;-2124.609,654.1255;Inherit;True;Property;_Texture4;Texture 4;14;0;Create;True;0;0;0;False;0;False;None;f7e96904e8667e1439548f0f86389447;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;41;-2414.9,834.9823;Inherit;True;Property;_Texture3;Texture 3;11;0;Create;True;0;0;0;False;0;False;None;bfca7f1a3437812479d5b63e50fafd60;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;12;-1814.195,-87.78001;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;98fe6059ed17a3a47bb1c64e7a1f7d65;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;-2186.589,1171.397;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;bfca7f1a3437812479d5b63e50fafd60;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;37;-1793.809,-310.6639;Inherit;True;Property;_Texture1;Texture 1;15;0;Create;True;0;0;0;False;0;False;None;3eaf0ffb87807aa4683db144a430c7e3;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleTimeNode;40;-1745.784,-407.3211;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;39;-2042.506,-424.1945;Inherit;True;Property;_Texture2;Texture 2;10;0;Create;True;0;0;0;False;0;False;None;98fe6059ed17a3a47bb1c64e7a1f7d65;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;36;-1752.215,-605.0513;Inherit;True;Property;_Texture0;Texture 0;13;0;Create;True;0;0;0;False;0;False;None;f7e96904e8667e1439548f0f86389447;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;35;-1361.176,-413.6511;Inherit;False;UI-Sprite Effect Layer;3;;1;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,1,92,0,98,0,234,0,126,0,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.SamplerNode;17;-1826.409,408.9947;Inherit;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;0;False;0;False;-1;None;bfca7f1a3437812479d5b63e50fafd60;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;45;-1733.57,845.5256;Inherit;False;UI-Sprite Effect Layer;3;;2;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,1,92,0,98,0,234,0,126,0,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-997.5839,-341.7023;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;21;-1245.065,153.9784;Inherit;False;Property;_Evo;Evo;0;0;Create;True;0;0;0;False;0;False;0;1;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1355.467,602.7747;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;18;-852.7775,60.35039;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-3056.933,-307.3329;Inherit;False;Constant;_Frequency;Frequency;5;0;Create;True;0;0;0;False;0;False;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-854.4058,182.0431;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;10;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CharacterEvolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;14;all;True;True;True;True;0;False;-1;True;0;False;-1;255;False;-1;255;False;-1;6;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;1;8;0
WireConnection;35;192;12;0
WireConnection;35;37;36;0
WireConnection;35;75;39;0
WireConnection;35;80;40;0
WireConnection;35;233;37;0
WireConnection;17;1;8;0
WireConnection;45;192;46;0
WireConnection;45;37;42;0
WireConnection;45;75;41;0
WireConnection;45;80;44;0
WireConnection;45;233;43;0
WireConnection;38;0;35;0
WireConnection;38;1;12;0
WireConnection;47;0;17;0
WireConnection;47;1;45;0
WireConnection;18;0;38;0
WireConnection;18;1;47;0
WireConnection;18;2;21;0
WireConnection;19;0;12;4
WireConnection;19;1;17;4
WireConnection;19;2;21;0
WireConnection;10;2;18;0
WireConnection;10;9;19;0
ASEEND*/
//CHKSM=343AFDE0F4CD4C544EE6F03DCEA2A34DA2DEB994