// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CardWindow"
{
	Properties
	{
		_Color1("Color", Color) = (0.9044118,0.6640914,0.03325041,0)
		_Albedo1("Albedo", 2D) = "white" {}
		_Normal1("Normal", 2D) = "bump" {}
		_Emission1("Emission", 2D) = "black" {}
		_Oclussion1("Oclussion", 2D) = "white" {}
		_HighlightColor1("Highlight Color", Color) = (0.7065311,0.9705882,0.9596617,1)
		_MinHighLightLevel1("MinHighLightLevel", Range( 0 , 1)) = 0.8
		_MaxHighLightLevel1("MaxHighLightLevel", Range( 0 , 1)) = 0.9
		_HighlightSpeed1("Highlight Speed", Range( 0 , 200)) = 60
		[Toggle]_Highlighted1("Highlighted", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
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
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal1;
		uniform float4 _Color1;
		uniform sampler2D _Albedo1;
		uniform float _Highlighted1;
		uniform sampler2D _Emission1;
		uniform float _HighlightSpeed1;
		uniform float _MinHighLightLevel1;
		uniform float _MaxHighLightLevel1;
		uniform float4 _HighlightColor1;
		uniform sampler2D _Oclussion1;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float3 Normal10 = UnpackNormal( tex2D( _Normal1, i.uv_texcoord ) );
			o.Normal = Normal10;
			float4 Albedo45 = ( _Color1 * tex2D( _Albedo1, i.uv_texcoord ) );
			o.Albedo = Albedo45.rgb;
			float4 Emision31 = tex2D( _Emission1, i.uv_texcoord );
			float3 normalizeResult11 = normalize( i.viewDir );
			float dotResult16 = dot( Normal10 , normalizeResult11 );
			float mulTime6 = _Time.y * 0.05;
			float Highlight_Level20 = (_MinHighLightLevel1 + (sin( ( mulTime6 * _HighlightSpeed1 ) ) - -1.0) * (_MaxHighLightLevel1 - _MinHighLightLevel1) / (1.0 - -1.0));
			float4 Highlight_Color26 = _HighlightColor1;
			float4 Highlight_Rim34 = ( pow( ( 1.0 - saturate( dotResult16 ) ) , (10.0 + (Highlight_Level20 - 0.0) * (0.0 - 10.0) / (1.0 - 0.0)) ) * Highlight_Color26 );
			float4 Final_Emision44 = (( _Highlighted1 )?( ( Emision31 + Highlight_Rim34 ) ):( Emision31 ));
			o.Emission = Final_Emision44.rgb;
			float4 Oclussion46 = tex2D( _Oclussion1, i.uv_texcoord );
			o.Occlusion = Oclussion46.r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
480;73;828;849;3179.647;600.9205;1.184462;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-1739.729,-587.0055;Inherit;False;1262.517;561.4071;Comment;8;20;17;15;14;13;7;6;5;Highlight Level (Ping pong animation);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2;-3054.708,-605.9315;Inherit;False;1244.203;1368.811;Comment;11;46;45;39;38;37;35;31;29;10;8;3;Textures;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-3004.708,-6.230286;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1709.729,-332.3575;Float;False;Property;_HighlightSpeed1;Highlight Speed;8;0;Create;True;0;0;0;False;0;False;60;0;0;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1625.425,-480.8104;Inherit;False;1;0;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;4;-1743.631,151.1805;Inherit;False;1900.698;589.5023;Comment;12;34;28;27;25;24;22;19;18;16;12;11;9;Highlight (Rim);1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1357.176,-405.3566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-2594.306,-141.0309;Inherit;True;Property;_Normal1;Normal;2;0;Create;True;0;0;0;False;0;False;-1;11f03d9db1a617e40b7ece71f0a84f6f;11f03d9db1a617e40b7ece71f0a84f6f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;9;-1693.631,323.7807;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-2199.206,-98.73029;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;15;-1170.623,-397.2455;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1405.058,-263.7596;Float;False;Property;_MinHighLightLevel1;MinHighLightLevel;6;0;Create;True;0;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1418.11,-140.5984;Float;False;Property;_MaxHighLightLevel1;MaxHighLightLevel;7;0;Create;True;0;0;0;False;0;False;0.9;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;17;-960.1508,-361.5475;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-1459.732,276.4822;Inherit;False;10;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;11;-1433.23,394.7808;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;16;-1164.832,254.2805;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-745.212,-360.0355;Float;False;Highlight_Level;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-3023.124,838.5746;Inherit;False;642.599;257;Comment;2;26;23;Highlight Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;18;-988.8311,231.9805;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1479.839,510.6828;Inherit;False;20;Highlight_Level;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-2973.124,888.5746;Float;False;Property;_HighlightColor1;Highlight Color;5;0;Create;True;0;0;0;False;0;False;0.7065311,0.9705882,0.9596617,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-2647.525,894.8758;Float;False;Highlight_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;24;-788.6306,264.9805;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;22;-1008.937,447.7821;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-537.233,454.483;Inherit;False;26;Highlight_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;27;-515.8306,201.1805;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-267.8309,308.9806;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;29;-2582.307,68.97031;Inherit;True;Property;_Emission1;Emission;3;0;Create;True;0;0;0;False;0;False;-1;7a170cdb7cc88024cb628cfcdbb6705c;7a170cdb7cc88024cb628cfcdbb6705c;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;30;-2275.204,839.9942;Inherit;False;987.1003;293;Comment;5;44;40;36;33;32;Emission Mix & Highlight Switching;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-2193.907,102.6701;Float;False;Emision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-81.19933,309.9272;Float;False;Highlight_Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-2228.074,1044.527;Inherit;False;34;Highlight_Rim;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-2229.953,877.1444;Inherit;False;31;Emision;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;37;-2583.006,-359.7309;Inherit;True;Property;_Albedo1;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;7130c16fd8005b546b111d341310a9a4;7130c16fd8005b546b111d341310a9a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1976.864,999.9944;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;35;-2572.406,-555.9315;Float;False;Property;_Color1;Color;0;0;Create;True;0;0;0;False;0;False;0.9044118,0.6640914,0.03325041,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;38;-2577.806,291.4716;Inherit;True;Property;_Oclussion1;Oclussion;4;0;Create;True;0;0;0;False;0;False;-1;a8de9c9c15d9c7e4eaa883c727391bee;a8de9c9c15d9c7e4eaa883c727391bee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2212.206,-394.0313;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;40;-1788.344,900.2207;Float;False;Property;_Highlighted1;Highlighted;9;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1545.103,901.9939;Float;False;Final_Emision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-2044.505,-394.1311;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-2202.806,341.4716;Float;False;Oclussion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-318.7318,-532.0234;Inherit;False;45;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-305.6207,-394.4122;Inherit;False;10;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-330.7594,-254.1566;Inherit;False;44;Final_Emision;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-307.074,-123.0383;Inherit;False;46;Oclussion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-70.47219,-518.1777;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;CardWindow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;6;0
WireConnection;7;1;5;0
WireConnection;8;1;3;0
WireConnection;10;0;8;0
WireConnection;15;0;7;0
WireConnection;17;0;15;0
WireConnection;17;3;13;0
WireConnection;17;4;14;0
WireConnection;11;0;9;0
WireConnection;16;0;12;0
WireConnection;16;1;11;0
WireConnection;20;0;17;0
WireConnection;18;0;16;0
WireConnection;26;0;23;0
WireConnection;24;0;18;0
WireConnection;22;0;19;0
WireConnection;27;0;24;0
WireConnection;27;1;22;0
WireConnection;28;0;27;0
WireConnection;28;1;25;0
WireConnection;29;1;3;0
WireConnection;31;0;29;0
WireConnection;34;0;28;0
WireConnection;37;1;3;0
WireConnection;36;0;33;0
WireConnection;36;1;32;0
WireConnection;38;1;3;0
WireConnection;39;0;35;0
WireConnection;39;1;37;0
WireConnection;40;0;33;0
WireConnection;40;1;36;0
WireConnection;44;0;40;0
WireConnection;45;0;39;0
WireConnection;46;0;38;0
WireConnection;0;0;41;0
WireConnection;0;1;42;0
WireConnection;0;2;43;0
WireConnection;0;5;47;0
ASEEND*/
//CHKSM=C41D029F0484A97BAA0549D53FDAE5E46D6B0813