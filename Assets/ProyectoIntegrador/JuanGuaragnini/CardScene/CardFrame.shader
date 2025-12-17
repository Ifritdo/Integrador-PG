// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CardFrame"
{
	Properties
	{
		_Evo("Evo", Range( 0 , 1)) = 0
		_FireTexture("Fire Texture", 2D) = "white" {}
		_BurnMask("Burn Mask", 2D) = "white" {}
		_Frecuencia("Frecuencia", Float) = 0
		_Dissolve("Dissolve", 2D) = "white" {}
		_Umbral("Umbral", Range( 0 , 1)) = 0.5
		_NoEvoTexture("No-EvoTexture", 2D) = "white" {}
		_Hover("Hover", Range( 0 , 1)) = 0
		_EvoTexture("EvoTexture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref 1
			Comp Always
			Pass Replace
		}
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Dissolve;
		uniform float4 _Dissolve_ST;
		uniform sampler2D _NoEvoTexture;
		uniform float4 _NoEvoTexture_ST;
		uniform sampler2D _EvoTexture;
		uniform sampler2D _BurnMask;
		uniform float4 _BurnMask_ST;
		uniform sampler2D _FireTexture;
		uniform float4 _EvoTexture_ST;
		uniform float _Evo;
		uniform float _Umbral;
		uniform float _Frecuencia;
		uniform float _Hover;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Dissolve = i.uv_texcoord * _Dissolve_ST.xy + _Dissolve_ST.zw;
			float4 tex2DNode62 = tex2D( _Dissolve, uv_Dissolve );
			float4 BurntTexture65 = tex2DNode62;
			float2 uv_NoEvoTexture = i.uv_texcoord * _NoEvoTexture_ST.xy + _NoEvoTexture_ST.zw;
			float2 uv_BurnMask = i.uv_texcoord * _BurnMask_ST.xy + _BurnMask_ST.zw;
			float2 uv_EvoTexture = i.uv_texcoord * _EvoTexture_ST.xy + _EvoTexture_ST.zw;
			float2 panner2_g4 = ( _Time.x * float2( -1,0 ) + uv_EvoTexture);
			float4 EvoTexture35 = tex2D( _EvoTexture, ( ( tex2D( _BurnMask, uv_BurnMask ) * tex2D( _FireTexture, panner2_g4 ) ) * ( 0.2 * ( _SinTime.w + 1.5 ) ) ).rg );
			float4 lerpResult37 = lerp( tex2D( _NoEvoTexture, uv_NoEvoTexture ) , EvoTexture35 , _Evo);
			float4 TextureFinal56 = lerpResult37;
			float smoothstepResult94 = smoothstep( _Umbral , tex2DNode62.r , -0.5);
			float Step164 = smoothstepResult94;
			float temp_output_68_0 = ( TextureFinal56.a * Step164 );
			float4 lerpResult73 = lerp( BurntTexture65 , TextureFinal56 , saturate( temp_output_68_0 ));
			float4 break74 = lerpResult73;
			float4 appendResult75 = (float4(break74.r , break74.g , break74.b , temp_output_68_0));
			float4 Dissolve76 = appendResult75;
			float4 temp_output_78_0 = Dissolve76;
			o.Albedo = temp_output_78_0.rgb;
			float3 ase_worldNormal = i.worldNormal;
			float Oscilacion48 = ( ( sin( ( _Time.y * _Frecuencia ) ) * 0.5 ) + 0.5 );
			float fresnelNdotV54 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode54 = ( Oscilacion48 + Oscilacion48 * pow( 1.0 - fresnelNdotV54, Oscilacion48 ) );
			float FresnelResult55 = fresnelNode54;
			o.Emission = ( float4( 0,0,0,0 ) + ( ( FresnelResult55 * _Hover ) * TextureFinal56 ) ).rgb;
			float Umbral80 = _Umbral;
			o.Alpha = Umbral80;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
1291;73;689;815;2976.885;1742.261;3.315506;True;False
Node;AmplifyShaderEditor.CommentaryNode;36;-2866.654,-366.3656;Inherit;False;1556.054;387.1626;Comment;5;4;32;33;34;35;EvoTexture;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;33;-2801.642,-306.7871;Inherit;True;Property;_EvoTexture;EvoTexture;14;0;Create;True;0;0;0;False;0;False;None;36b88763521a03549b56d085b6f1e518;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-2517.457,-217.1132;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;4;-2247.506,-188.5083;Inherit;False;Burn Effect;1;;4;e412e392e3db9574fbf6397db39b4c51;0;2;12;FLOAT;0.2;False;14;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;77;-714.9753,-2052.885;Inherit;False;1422.006;683.2112;Comment;19;59;60;61;62;64;65;67;68;70;71;72;73;74;75;76;80;86;94;66;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;34;-1886.036,-316.3656;Inherit;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;0;False;0;False;33;None;36b88763521a03549b56d085b6f1e518;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;40;-2363.295,1050.658;Inherit;False;623.9867;528.0135;Tiempo y frecuencia;6;46;45;44;43;42;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;41;-2280.508,1118.672;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2327.84,1192.71;Inherit;False;Property;_Frecuencia;Frecuencia;4;0;Create;True;0;0;0;False;0;False;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-1534.6,-309.1078;Inherit;False;EvoTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;95;-1857.936,-1185.565;Inherit;False;963.755;473.3613;Comment;5;26;39;38;37;56;FinalTexture;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;59;-649.9834,-1970.948;Inherit;True;Property;_Dissolve;Dissolve;7;0;Create;True;0;0;0;False;0;False;0203bc3bf47efb84ca5cf01effeed7ba;f7e96904e8667e1439548f0f86389447;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;26;-1756.322,-1135.565;Inherit;True;Property;_NoEvoTexture;No-EvoTexture;9;0;Create;True;0;0;0;False;0;False;-1;None;d141606ca3998914892249c806929dcd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2101.279,1190.26;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1807.936,-828.2034;Inherit;False;Property;_Evo;Evo;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-390.0593,-1847.301;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;39;-1580.397,-922.6642;Inherit;False;35;EvoTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-132.8005,-1997.926;Inherit;False;Property;_Umbral;Umbral;8;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;44;-1931.556,1189.42;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-120.0253,-1922.91;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;37;-1304.484,-956.3297;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;94;233.8392,-1923.51;Inherit;False;3;0;FLOAT;-0.5;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-1118.181,-984.4222;Inherit;False;TextureFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2085.448,1361.535;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1875.164,1364.413;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-698.5575,-1677.052;Inherit;False;56;TextureFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;439.9198,-1890.471;Inherit;False;Step1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-651.0134,-1485.673;Inherit;False;64;Step1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;86;-507.3147,-1689.947;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;47;-3158.362,268.975;Inherit;False;1354.748;630.1989;Fresnel;7;55;54;53;52;51;50;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-1700.07,1244.147;Inherit;False;Oscilacion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-395.1759,-1554.456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;52;-2527.919,316.3751;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;51;-2496.794,617.7227;Inherit;False;48;Oscilacion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;207.7642,-1767.149;Inherit;False;BurntTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;50;-2513.618,452.875;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;70;-212.6877,-1547.047;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-278.1134,-1703.162;Inherit;False;65;BurntTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;54;-2059.615,387.2742;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-275.0804,-1634.666;Inherit;False;56;TextureFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;73;18.76672,-1673.368;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-2003.776,690.1669;Inherit;False;FresnelResult;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-1189.684,-23.66837;Inherit;False;Property;_Hover;Hover;13;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;74;194.7877,-1654.61;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;58;-1052.938,122.1458;Inherit;False;55;FresnelResult;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-769.7049,39.68442;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;75;335.9297,-1636.045;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-882.2631,230.3845;Inherit;False;56;TextureFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;235.7503,-1989.714;Inherit;False;Umbral;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-544.2869,22.58565;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;483.0306,-1633.673;Inherit;False;Dissolve;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-553.3383,-64.51022;Inherit;False;76;Dissolve;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;103;-857.1299,353.0792;Inherit;True;Property;_Texture0;Texture 0;11;0;Create;True;0;0;0;False;0;False;None;4cf5ebc7a0d76a64ba35105c672c82c6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-681.0554,-220.3206;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-250.7965,69.49254;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;104;-529.6016,177.5258;Inherit;True;Property;_TextureSample3;Texture Sample 3;11;0;Create;True;0;0;0;False;0;False;-1;None;2115d9153108e3e4db79bd7b010e2018;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-368.386,396.9824;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2491.686,787.2071;Inherit;False;Property;_Power;Power;5;0;Create;True;0;0;0;False;0;False;0;1.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;96;-480.7222,-338.973;Inherit;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;0;False;0;False;-1;None;f88677df267a41d6be1e7a6133e7d227;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-174.4528,-204.6183;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;105;-941.4465,-272.0738;Inherit;True;Property;_Texture1;Texture 1;12;0;Create;True;0;0;0;False;0;False;None;2115d9153108e3e4db79bd7b010e2018;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;79;-369.1102,433.5966;Inherit;True;80;Umbral;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2491.684,706.6071;Inherit;False;Property;_Bias;Bias;6;0;Create;True;0;0;0;False;0;False;0;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1.566356,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CardFrame;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;7;False;-1;3;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.03;1,1,1,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;2;33;0
WireConnection;4;14;32;0
WireConnection;34;0;33;0
WireConnection;34;1;4;0
WireConnection;35;0;34;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;60;2;59;0
WireConnection;44;0;43;0
WireConnection;62;0;59;0
WireConnection;62;1;60;0
WireConnection;37;0;26;0
WireConnection;37;1;39;0
WireConnection;37;2;38;0
WireConnection;94;1;61;0
WireConnection;94;2;62;0
WireConnection;56;0;37;0
WireConnection;45;0;44;0
WireConnection;46;0;45;0
WireConnection;64;0;94;0
WireConnection;86;0;66;0
WireConnection;48;0;46;0
WireConnection;68;0;86;3
WireConnection;68;1;67;0
WireConnection;65;0;62;0
WireConnection;70;0;68;0
WireConnection;54;0;52;0
WireConnection;54;4;50;0
WireConnection;54;1;51;0
WireConnection;54;2;51;0
WireConnection;54;3;51;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;73;2;70;0
WireConnection;55;0;54;0
WireConnection;74;0;73;0
WireConnection;113;0;58;0
WireConnection;113;1;108;0
WireConnection;75;0;74;0
WireConnection;75;1;74;1
WireConnection;75;2;74;2
WireConnection;75;3;68;0
WireConnection;80;0;61;0
WireConnection;81;0;113;0
WireConnection;81;1;57;0
WireConnection;76;0;75;0
WireConnection;106;2;105;0
WireConnection;97;1;81;0
WireConnection;104;0;103;0
WireConnection;96;1;106;0
WireConnection;107;0;96;0
WireConnection;107;1;78;0
WireConnection;0;0;78;0
WireConnection;0;2;97;0
WireConnection;0;9;79;0
ASEEND*/
//CHKSM=C51E31FA5354E14F809BEA7C9C0125F4A627D7D3