// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DistBall"
{
	Properties
	{
		_Frequency("Frequency", Float) = 4
		_TesselationScale("TesselationScale", Float) = 0
		_OffsetPosition("OffsetPosition", Vector) = (0,1,0,0)
		_Color0("Color 0", Color) = (1,1,1,0)
		_Color2("Color2", Color) = (0,0,0,0)
		_Height("Height", Range( 0 , 1)) = 0
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
		};

		uniform float _Frequency;
		uniform float3 _OffsetPosition;
		uniform float _Height;
		uniform float4 _Color0;
		uniform float4 _Color2;
		uniform float _TesselationScale;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _TesselationScale);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 objToWorld2 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float Distance5 = distance( ase_worldPos , objToWorld2 );
			float Seno13 = sin( ( ( Distance5 * _Frequency ) + _Time.y ) );
			float3 Result24 = ( ( Seno13 * _OffsetPosition ) * _Height );
			v.vertex.xyz += Result24;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 objToWorld2 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float Distance5 = distance( ase_worldPos , objToWorld2 );
			float Seno13 = sin( ( ( Distance5 * _Frequency ) + _Time.y ) );
			float3 temp_cast_0 = (Seno13).xxx;
			o.Normal = temp_cast_0;
			float4 lerpResult22 = lerp( _Color0 , _Color2 , Seno13);
			float4 Color25 = lerpResult22;
			o.Albedo = Color25.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1265;73;1294;997;1582.058;-356.6982;1;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1975.347,-196.7936;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;2;-2026.984,6.289729;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;4;-1743.943,-75.8941;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-1450.591,10.46119;Inherit;False;Distance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1265.464,-131.7797;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1201.763,59.32088;Inherit;False;Constant;_TimeScale;TimeScale;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;6;-1346.063,-304.6785;Inherit;False;5;Distance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1084.764,-246.1785;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1032.762,9.921164;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-844.2649,-153.8796;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;12;-694.7651,-136.9796;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-579.0652,-96.67867;Inherit;False;Seno;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-1130.26,727.6246;Inherit;False;13;Seno;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;14;-1136.342,546.0668;Inherit;False;Property;_OffsetPosition;OffsetPosition;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1419.461,462.529;Inherit;False;13;Seno;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-1515.067,127.7511;Inherit;False;Property;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-1624.15,228.8511;Inherit;False;Property;_Color2;Color2;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-882.8281,634.5067;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1157.09,842.7438;Inherit;False;Property;_Height;Height;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-770.0576,726.6982;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;22;-1170.53,312.6572;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-909.445,349.6568;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-571.067,475.2998;Inherit;False;Property;_TesselationScale;TesselationScale;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-642.4311,661.525;Inherit;False;Result;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-296.9798,54.87986;Inherit;False;13;Seno;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;26;-363.5465,438.0527;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;1;-2342.469,-67.04929;Inherit;False;Property;_InitialPoint;InitialPoint;5;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;27;-263.3454,-36.46965;Inherit;False;25;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-309.7063,283.321;Inherit;False;24;Result;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;DistBall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;4;1;2;0
WireConnection;5;0;4;0
WireConnection;9;0;6;0
WireConnection;9;1;7;0
WireConnection;10;0;8;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;12;0;11;0
WireConnection;13;0;12;0
WireConnection;18;0;15;0
WireConnection;18;1;14;0
WireConnection;33;0;18;0
WireConnection;33;1;32;0
WireConnection;22;0;16;0
WireConnection;22;1;17;0
WireConnection;22;2;19;0
WireConnection;25;0;22;0
WireConnection;24;0;33;0
WireConnection;26;0;23;0
WireConnection;0;0;27;0
WireConnection;0;1;29;0
WireConnection;0;11;28;0
WireConnection;0;14;26;0
ASEEND*/
//CHKSM=1F78BBEBE5280C4946B73E10FCDF301148681408