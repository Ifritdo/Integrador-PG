// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LensDistortion"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_Intensity("Intensity", Range( 0.5 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float _Intensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 Vector18 = float2( 0.5,0.5 );
			float2 temp_output_12_0 = ( i.uv_texcoord - Vector18 );
			float2 normalizeResult13 = normalize( temp_output_12_0 );
			o.Albedo = tex2D( _Texture0, ( ( normalizeResult13 * pow( length( temp_output_12_0 ) , _Intensity ) ) + Vector18 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1190;73;1369;1278;1771.868;429.7348;1.392397;True;False
Node;AmplifyShaderEditor.Vector2Node;11;-2107.234,536.287;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-1906.236,574.8793;Inherit;False;Vector;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1799.081,146.0825;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1729.4,306.1469;Inherit;False;18;Vector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-1536.246,225.3886;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;14;-1352.568,364.9021;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1463.612,498.1584;Inherit;False;Property;_Intensity;Intensity;1;0;Create;True;0;0;0;False;0;False;0;1;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;13;-1371.139,276.4182;Inherit;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;15;-1173.415,395.4896;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-982.2451,337.5924;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1010.924,491.3354;Inherit;False;18;Vector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-793.2606,382.3807;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-968.322,133.018;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;0dc0cc0b0fc47d14a80a41105b98d112;8bab5ab76ae712243bd36da71b105f17;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;3;-601.2225,198.8659;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;21;-210.6821,224.2511;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LensDistortion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;11;0
WireConnection;12;0;5;0
WireConnection;12;1;19;0
WireConnection;14;0;12;0
WireConnection;13;0;12;0
WireConnection;15;0;14;0
WireConnection;15;1;10;0
WireConnection;16;0;13;0
WireConnection;16;1;15;0
WireConnection;17;0;16;0
WireConnection;17;1;20;0
WireConnection;3;0;4;0
WireConnection;3;1;17;0
WireConnection;21;0;3;0
ASEEND*/
//CHKSM=CC8D284CB8D2A799218AF42B6422DA242CE5846B