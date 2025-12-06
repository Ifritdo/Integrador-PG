// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ripple"
{
	Properties
	{
		_Frequency("Frequency", Range( 0 , 10)) = 4
		_TesselationScale("TesselationScale", Range( 0 , 10)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_InitPoint("InitPoint", Vector) = (0,0,0,0)
		_Edge("Edge", Range( 0 , 0.5)) = 0
		_Radio("Radio", Range( 0.1 , 5)) = 0
		_FadeMax("FadeMax", Range( 5 , 10)) = 1
		_FadeMin("FadeMin", Range( 0.1 , 5)) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Radio;
		uniform float _Edge;
		uniform float3 _InitPoint;
		uniform float _Frequency;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _FadeMax;
		uniform float _FadeMin;
		uniform float _TesselationScale;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _TesselationScale);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_4_0 = distance( ase_vertex3Pos , _InitPoint );
			float RealDist180 = temp_output_4_0;
			float smoothstepResult196 = smoothstep( _Radio , ( _Radio * _Edge ) , RealDist180);
			float3 ase_vertexNormal = v.normal.xyz;
			float Distance5 = ( 1.0 - temp_output_4_0 );
			float mulTime10 = _Time.y * 0.5;
			float Waves13 = sin( ( ( Distance5 * _Frequency ) + mulTime10 ) );
			float SinMod194 = ( ( ( Waves13 + 1.0 ) * 0.25 ) + 0.5 );
			float3 Result23 = ( ( smoothstepResult196 * ase_vertexNormal * SinMod194 ) + ase_vertex3Pos );
			v.vertex.xyz += Result23;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_4_0 = distance( ase_vertex3Pos , _InitPoint );
			float Distance5 = ( 1.0 - temp_output_4_0 );
			float mulTime10 = _Time.y * 0.5;
			float Waves13 = sin( ( ( Distance5 * _Frequency ) + mulTime10 ) );
			float SinMod194 = ( ( ( Waves13 + 1.0 ) * 0.25 ) + 0.5 );
			float3 temp_cast_0 = (SinMod194).xxx;
			o.Normal = temp_cast_0;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Albedo = tex2D( _TextureSample0, uv_TextureSample0 ).rgb;
			float RealDist180 = temp_output_4_0;
			float smoothstepResult206 = smoothstep( _FadeMax , _FadeMin , RealDist180);
			float myVarName204 = smoothstepResult206;
			o.Alpha = myVarName204;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v );
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
				surfIN.worldPos = worldPos;
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
1694;73;865;1278;2711.601;1393.511;3.450597;False;False
Node;AmplifyShaderEditor.CommentaryNode;130;-2376.635,-516.2034;Inherit;False;930.7742;377.5136;Distance;6;4;73;5;164;165;180;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;165;-2310.248,-298.1892;Inherit;False;Property;_InitPoint;InitPoint;3;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;164;-2316.505,-465.3141;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;4;-2029.899,-373.3882;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;73;-1867.781,-375.3538;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;129;-2378.643,-129.9396;Inherit;False;974.6909;330.9993;Waves;8;11;9;6;8;10;7;12;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-1669.859,-371.101;Inherit;False;Distance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2238.942,85.05946;Inherit;False;Constant;_TimeScale;TimeScale;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2328.643,7.959107;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;4;1.85;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;-2228.241,-79.93964;Inherit;False;5;Distance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-2046.941,77.65974;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2030.942,-32.43969;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1880.444,0.8591092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;12;-1767.76,-0.7867947;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1627.951,-12.3523;Inherit;False;Waves;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;-1418.17,-2.466546;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-1273.128,-14.28747;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-1114.644,-0.1614919;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-2221.699,503.3026;Inherit;False;Property;_Radio;Radio;5;0;Create;True;0;0;0;False;0;False;0;3.41;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;198;-2214.518,649.5187;Inherit;False;Property;_Edge;Edge;4;0;Create;True;0;0;0;False;0;False;0;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-1856.992,-243.2848;Inherit;False;RealDist;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1933.518,589.5187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;200;-1963.518,436.5187;Inherit;False;180;RealDist;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-954.6957,48.0285;Inherit;False;SinMod;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;201;-1762.126,655.5767;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;157;-1754.138,800.1248;Inherit;False;194;SinMod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;196;-1712.806,501.9984;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-2017.586,342.006;Inherit;False;Property;_FadeMin;FadeMin;7;0;Create;True;0;0;0;False;0;False;2;5;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-2020.586,263.006;Inherit;False;Property;_FadeMax;FadeMax;6;0;Create;True;0;0;0;False;0;False;1;10;5;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;203;-1547.409,843.4889;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-1522.944,581.8536;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0.25,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;206;-1664.586,324.006;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;202;-1336.409,742.4889;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1121.031,728.8557;Inherit;False;Result;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;204;-1296.409,466.4889;Inherit;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-669.7623,448.8989;Inherit;False;Property;_TesselationScale;TesselationScale;1;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;29;-344.2409,442.6519;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;153;-630.6181,-72.17358;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;d75d23fa05e7cd747ba54add1c60d577;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;-219.5899,97.8762;Inherit;False;194;SinMod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-335.7324,302.8189;Inherit;False;23;Result;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;205;-341.4094,184.4889;Inherit;False;204;myVarName;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Ripple;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;164;0
WireConnection;4;1;165;0
WireConnection;73;0;4;0
WireConnection;5;0;73;0
WireConnection;10;0;7;0
WireConnection;9;0;8;0
WireConnection;9;1;6;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;12;0;11;0
WireConnection;13;0;12;0
WireConnection;191;0;13;0
WireConnection;192;0;191;0
WireConnection;193;0;192;0
WireConnection;180;0;4;0
WireConnection;199;0;197;0
WireConnection;199;1;198;0
WireConnection;194;0;193;0
WireConnection;196;0;200;0
WireConnection;196;1;197;0
WireConnection;196;2;199;0
WireConnection;186;0;196;0
WireConnection;186;1;201;0
WireConnection;186;2;157;0
WireConnection;206;0;200;0
WireConnection;206;1;207;0
WireConnection;206;2;208;0
WireConnection;202;0;186;0
WireConnection;202;1;203;0
WireConnection;23;0;202;0
WireConnection;204;0;206;0
WireConnection;29;0;25;0
WireConnection;0;0;153;0
WireConnection;0;1;30;0
WireConnection;0;9;205;0
WireConnection;0;11;28;0
WireConnection;0;14;29;0
ASEEND*/
//CHKSM=421CDCAF75555EAB171725D2F10444DB0960B8CB