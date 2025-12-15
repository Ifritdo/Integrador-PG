// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CharacterEvolve"
{
	Properties
	{
		_Evo("Evo", Range( 0 , 1)) = 0
		_NoEvoTexture("NoEvoTexture", 2D) = "white" {}
		_Dissolve1("Dissolve", 2D) = "white" {}
		_NoEvoDistortionMask("NoEvoDistortionMask", 2D) = "white" {}
		_Umbral1("Umbral", Range( 0 , 1)) = 0.5
		_EvoTexture("EvoTexture", 2D) = "white" {}
		_EvoDistortionMask("EvoDistortionMask", 2D) = "white" {}
		_DistortionTexture("DistortionTexture", 2D) = "white" {}
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

		uniform sampler2D _DistortionTexture;
		uniform sampler2D _NoEvoTexture;
		uniform float4 _DistortionTexture_ST;
		uniform sampler2D _NoEvoDistortionMask;
		uniform sampler2D _EvoTexture;
		uniform sampler2D _EvoDistortionMask;
		uniform float _Evo;
		uniform float _Umbral1;
		uniform sampler2D _Dissolve1;
		uniform float4 _Dissolve1_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_DistortionTexture = i.uv_texcoord * _DistortionTexture_ST.xy + _DistortionTexture_ST.zw;
			float2 MainUvs222_g1 = uv_DistortionTexture;
			float4 tex2DNode65_g1 = tex2D( _NoEvoTexture, MainUvs222_g1 );
			float4 appendResult82_g1 = (float4(0.0 , tex2DNode65_g1.g , 0.0 , tex2DNode65_g1.r));
			float2 temp_output_84_0_g1 = (UnpackScaleNormal( appendResult82_g1, _Time.y )).xy;
			float2 temp_output_71_0_g1 = ( temp_output_84_0_g1 + MainUvs222_g1 );
			float4 tex2DNode96_g1 = tex2D( _DistortionTexture, temp_output_71_0_g1 );
			float2 uv_NoEvoDistortionMask232_g1 = i.uv_texcoord;
			float4 tex2DNode12 = tex2D( _NoEvoTexture, i.uv_texcoord );
			float4 temp_output_192_0_g1 = tex2DNode12;
			float4 NormalTexture50 = ( ( tex2DNode96_g1 * tex2DNode96_g1.a * tex2D( _NoEvoDistortionMask, uv_NoEvoDistortionMask232_g1 ).g ) + temp_output_192_0_g1 );
			float2 MainUvs222_g2 = uv_DistortionTexture;
			float4 tex2DNode65_g2 = tex2D( _EvoTexture, MainUvs222_g2 );
			float4 appendResult82_g2 = (float4(0.0 , tex2DNode65_g2.g , 0.0 , tex2DNode65_g2.r));
			float2 temp_output_84_0_g2 = (UnpackScaleNormal( appendResult82_g2, _Time.y )).xy;
			float2 temp_output_71_0_g2 = ( temp_output_84_0_g2 + MainUvs222_g2 );
			float4 tex2DNode96_g2 = tex2D( _DistortionTexture, temp_output_71_0_g2 );
			float2 uv_EvoDistortionMask232_g2 = i.uv_texcoord;
			float4 tex2DNode46 = tex2D( _EvoTexture, i.uv_texcoord );
			float4 temp_output_192_0_g2 = tex2DNode46;
			float4 EvoTexture52 = ( ( tex2DNode96_g2 * tex2DNode96_g2.a * tex2D( _EvoDistortionMask, uv_EvoDistortionMask232_g2 ).g ) + temp_output_192_0_g2 );
			float4 lerpResult18 = lerp( NormalTexture50 , EvoTexture52 , _Evo);
			float4 TexturaFinal89 = lerpResult18;
			float2 uv_Dissolve1 = i.uv_texcoord * _Dissolve1_ST.xy + _Dissolve1_ST.zw;
			float4 tex2DNode73 = tex2D( _Dissolve1, uv_Dissolve1 );
			float smoothstepResult74 = smoothstep( _Umbral1 , tex2DNode73.r , -0.5);
			float Step175 = smoothstepResult74;
			float temp_output_80_0 = ( TexturaFinal89.a * Step175 );
			float4 lerpResult84 = lerp( 0 , TexturaFinal89 , saturate( temp_output_80_0 ));
			float4 break85 = lerpResult84;
			float4 appendResult86 = (float4(break85.r , break85.g , break85.b , temp_output_80_0));
			float4 Dissolve88 = appendResult86;
			float4 temp_output_92_0 = Dissolve88;
			o.Albedo = temp_output_92_0.rgb;
			o.Emission = temp_output_92_0.rgb;
			float NormalAlpha51 = tex2DNode12.a;
			float EvoAlpha53 = tex2DNode46.a;
			float lerpResult19 = lerp( NormalAlpha51 , EvoAlpha53 , _Evo);
			float Umbral87 = _Umbral1;
			o.Alpha = ( lerpResult19 * Umbral87 );
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
995;73;1058;927;2043.984;2593.777;3.137605;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;41;-3884.848,379.5056;Inherit;True;Property;_EvoTexture;EvoTexture;12;0;Create;True;0;0;0;False;0;False;None;bfca7f1a3437812479d5b63e50fafd60;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;39;-3909.026,-32.30891;Inherit;True;Property;_NoEvoTexture;NoEvoTexture;8;0;Create;True;0;0;0;False;0;False;None;98fe6059ed17a3a47bb1c64e7a1f7d65;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;59;-2757.057,-590.675;Inherit;False;1674.884;797.2711;Comment;10;12;37;40;35;8;51;50;66;67;68;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;58;-2727.792,316.5618;Inherit;False;1452.147;651.3076;Comment;10;46;44;45;52;53;61;62;64;49;43;Evo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-3617.171,382.355;Inherit;False;Evotxt;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-3660.337,-16.80999;Inherit;False;NormalTxt;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;42;-3882.484,184.514;Inherit;True;Property;_DistortionTexture;DistortionTexture;14;0;Create;True;0;0;0;False;0;False;None;f7e96904e8667e1439548f0f86389447;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-3645.538,181.0129;Inherit;False;DistortTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2693.874,-408.3426;Inherit;False;65;NormalTxt;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-2690.587,487.7333;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;61;-2670.07,402.5918;Inherit;False;60;Evotxt;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2726.367,-554.4661;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;37;-2414.81,-20.60987;Inherit;True;Property;_NoEvoDistortionMask;NoEvoDistortionMask;10;0;Create;True;0;0;0;False;0;False;None;3eaf0ffb87807aa4683db144a430c7e3;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;66;-2366.041,-184.1231;Inherit;False;65;NormalTxt;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;46;-2429.607,365.4483;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;bfca7f1a3437812479d5b63e50fafd60;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;68;-2381.017,-300.5598;Inherit;False;63;DistortTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2441.348,621.3553;Inherit;False;60;Evotxt;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2449.486,556.2228;Inherit;False;63;DistortTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleTimeNode;40;-2358.271,-95.97598;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;43;-2696.251,761.5677;Inherit;True;Property;_EvoDistortionMask;EvoDistortionMask;13;0;Create;True;0;0;0;False;0;False;None;6b6133586a4da544bab2f57e106d6ce5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;12;-2479.727,-552.912;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;0;False;0;False;-1;None;98fe6059ed17a3a47bb1c64e7a1f7d65;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;44;-2448.943,695.8658;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;45;-1977.088,497.5806;Inherit;False;UI-Sprite Effect Layer;1;;2;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,1,92,0,98,0,234,0,126,0,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.CommentaryNode;69;-837.0465,-1536.249;Inherit;False;1422.006;683.2112;Comment;19;88;87;86;85;84;83;82;81;80;79;78;77;76;75;74;73;72;71;70;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;35;-1845.92,-349.2744;Inherit;False;UI-Sprite Effect Layer;1;;1;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,1,92,0,98,0,234,0,126,0,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-1499.645,527.5411;Inherit;False;EvoTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-1494.986,-359.1751;Inherit;False;NormalTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;70;-772.0546,-1454.312;Inherit;True;Property;_Dissolve1;Dissolve;9;0;Create;True;0;0;0;False;0;False;0203bc3bf47efb84ca5cf01effeed7ba;f7e96904e8667e1439548f0f86389447;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1051.474,-38.19333;Inherit;False;50;NormalTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1057.474,42.80666;Inherit;False;52;EvoTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;-512.1305,-1330.665;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1211.789,162.6762;Inherit;False;Property;_Evo;Evo;0;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-703.7661,58.15025;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;73;-242.0965,-1406.274;Inherit;True;Property;_TextureSample1;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-254.8717,-1481.29;Inherit;False;Property;_Umbral1;Umbral;11;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;111.768,-1406.874;Inherit;False;3;0;FLOAT;-0.5;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-518.706,101.1092;Inherit;False;TexturaFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-820.6287,-1160.416;Inherit;False;89;TexturaFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;317.8486,-1373.834;Inherit;False;Step1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-773.0847,-969.0365;Inherit;False;75;Step1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;78;-629.3859,-1173.311;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-517.2471,-1037.82;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;81;-334.7589,-1030.411;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-400.1846,-1186.526;Inherit;False;63;DistortTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-397.1516,-1118.03;Inherit;False;89;TexturaFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;84;-103.3045,-1156.732;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-2170.655,-370.7194;Inherit;False;NormalAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;85;72.71649,-1137.974;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-2017.547,370.2845;Inherit;False;EvoAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;86;213.8585,-1119.409;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1033.474,335.8067;Inherit;False;53;EvoAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-1032.474,259.8066;Inherit;False;51;NormalAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;113.6791,-1473.078;Inherit;False;Umbral;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-660.8201,317.2118;Inherit;False;87;Umbral;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-705.3944,179.8429;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;360.9594,-1117.036;Inherit;False;Dissolve;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-431.9747,227.4882;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-252.5281,33.92715;Inherit;False;88;Dissolve;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;85.69299,-1250.513;Inherit;False;BurntTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;10;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CharacterEvolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;14;all;True;True;True;True;0;False;-1;True;0;False;-1;255;False;-1;255;False;-1;6;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;60;0;41;0
WireConnection;65;0;39;0
WireConnection;63;0;42;0
WireConnection;46;0;61;0
WireConnection;46;1;49;0
WireConnection;12;0;67;0
WireConnection;12;1;8;0
WireConnection;45;192;46;0
WireConnection;45;37;64;0
WireConnection;45;75;62;0
WireConnection;45;80;44;0
WireConnection;45;233;43;0
WireConnection;35;192;12;0
WireConnection;35;37;68;0
WireConnection;35;75;66;0
WireConnection;35;80;40;0
WireConnection;35;233;37;0
WireConnection;52;0;45;0
WireConnection;50;0;35;0
WireConnection;71;2;70;0
WireConnection;18;0;57;0
WireConnection;18;1;54;0
WireConnection;18;2;48;0
WireConnection;73;0;70;0
WireConnection;73;1;71;0
WireConnection;74;1;72;0
WireConnection;74;2;73;0
WireConnection;89;0;18;0
WireConnection;75;0;74;0
WireConnection;78;0;76;0
WireConnection;80;0;78;3
WireConnection;80;1;77;0
WireConnection;81;0;80;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;84;2;81;0
WireConnection;51;0;12;4
WireConnection;85;0;84;0
WireConnection;53;0;46;4
WireConnection;86;0;85;0
WireConnection;86;1;85;1
WireConnection;86;2;85;2
WireConnection;86;3;80;0
WireConnection;87;0;72;0
WireConnection;19;0;56;0
WireConnection;19;1;55;0
WireConnection;19;2;48;0
WireConnection;88;0;86;0
WireConnection;90;0;19;0
WireConnection;90;1;91;0
WireConnection;79;0;73;0
WireConnection;10;0;92;0
WireConnection;10;2;92;0
WireConnection;10;9;90;0
ASEEND*/
//CHKSM=A13688D1589B362A4F1B67EF55E47A688739678C