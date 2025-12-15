// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distance"
{
	Properties
	{
		_Frequency("Frequency", Range( 0 , 5)) = 4
		_TesselationScale("TesselationScale", Range( 0 , 10)) = 0
		_InitialPoint("InitialPoint", Vector) = (0,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float3 _InitialPoint;
		uniform float _Frequency;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _TesselationScale;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _TesselationScale);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 _OffsetPosition = float3(0,1,0);
			float3 ase_vertex3Pos = v.vertex.xyz;
			float Distance1 = distance( ase_vertex3Pos , _InitialPoint );
			float Seno12 = ( ( ( sin( ( ( Distance1 * _Frequency ) + _Time.y ) ) + 1.0 ) * 0.25 ) + 0.5 );
			float3 appendResult40 = (float3(_OffsetPosition.x , ( _OffsetPosition.y * Seno12 ) , _OffsetPosition.z));
			float3 Result29 = appendResult40;
			v.vertex.xyz += Result29;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float Distance1 = distance( ase_vertex3Pos , _InitialPoint );
			float Seno12 = ( ( ( sin( ( ( Distance1 * _Frequency ) + _Time.y ) ) + 1.0 ) * 0.25 ) + 0.5 );
			float3 temp_cast_0 = (Seno12).xxx;
			o.Normal = temp_cast_0;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 Color27 = ( Seno12 * tex2D( _TextureSample0, uv_TextureSample0 ) );
			o.Albedo = Color27.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
670;81;1113;957;1304.14;1818.673;1.744581;False;False
Node;AmplifyShaderEditor.PosVertexDataNode;41;-1699.712,-738.9742;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;32;-1551.16,-560.4987;Inherit;False;Property;_InitialPoint;InitialPoint;2;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;10;-1317.543,-652.5428;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1;-1161.545,-652.5427;Inherit;False;Distance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1445.845,-1065.855;Inherit;False;Constant;_TimeScale;TimeScale;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1613.844,-1143.456;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;4;4;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2;-1456.242,-1216.652;Inherit;False;1;Distance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1257.344,-1184.152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-1270.345,-1078.854;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-1090.947,-1155.555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;-963.5472,-1145.155;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-801.8231,-1162.633;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-656.7813,-1174.454;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-498.2973,-1160.328;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-358.8766,-1158.034;Inherit;False;Seno;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1979.478,67.87003;Inherit;False;12;Seno;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;13;-1936.059,172.6125;Inherit;False;Constant;_OffsetPosition;OffsetPosition;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1725.421,68.05848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1858.492,-195.7023;Inherit;False;12;Seno;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-1978.228,-399.6631;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1588.826,-286.5229;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1506.353,95.23096;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-537.9955,354.7932;Inherit;False;Property;_TesselationScale;TesselationScale;1;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-1238.077,112.0046;Inherit;False;Result;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1224.539,-222.7664;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-236.9088,45.7734;Inherit;False;12;Seno;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-227.6353,282.2144;Inherit;False;29;Result;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-278.2744,-48.57617;Inherit;False;27;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;18;-242.4755,356.946;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Distance;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;41;0
WireConnection;10;1;32;0
WireConnection;1;0;10;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;7;0;5;0
WireConnection;6;0;3;0
WireConnection;6;1;7;0
WireConnection;8;0;6;0
WireConnection;37;0;8;0
WireConnection;38;0;37;0
WireConnection;39;0;38;0
WireConnection;12;0;39;0
WireConnection;17;0;13;2
WireConnection;17;1;14;0
WireConnection;36;0;26;0
WireConnection;36;1;33;0
WireConnection;40;0;13;1
WireConnection;40;1;17;0
WireConnection;40;2;13;3
WireConnection;29;0;40;0
WireConnection;27;0;36;0
WireConnection;18;0;19;0
WireConnection;0;0;28;0
WireConnection;0;1;20;0
WireConnection;0;11;30;0
WireConnection;0;14;18;0
ASEEND*/
//CHKSM=0F7F1916E3B45421012DA27FF46FEEE156255C0C