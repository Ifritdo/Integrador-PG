// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TvVignette"
{
	Properties
	{
		_Height1("Height", Float) = 1
		_Width1("Width", Float) = 1
		_TextureSample1("Texture Sample 0", 2D) = "white" {}
		_PosX1("PosX", Float) = 0.5
		_PosY1("PosY", Float) = 0.5
		_Radius1("Radius", Range( 0 , 2)) = 2
		_Smoothness1("Smoothness", Range( 0 , 1)) = 1
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

		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _Radius1;
		uniform float _Smoothness1;
		uniform float _PosX1;
		uniform float _PosY1;
		uniform float _Width1;
		uniform float _Height1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color33 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float temp_output_27_0 = ( _Radius1 - _Smoothness1 );
			float2 appendResult18 = (float2(_PosX1 , _PosY1));
			float2 appendResult21 = (float2(_Width1 , _Height1));
			float smoothstepResult34 = smoothstep( ( temp_output_27_0 + ( _Smoothness1 + 0.001 ) ) , temp_output_27_0 , distance( ( appendResult18 + ( ( i.uv_texcoord - appendResult18 ) / appendResult21 ) ) , appendResult18 ));
			float4 lerpResult41 = lerp( color33 , tex2D( _TextureSample1, uv_TextureSample1 ) , smoothstepResult34);
			o.Albedo = lerpResult41.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
937;188;981;1029;2418.116;1930.624;3.012119;True;False
Node;AmplifyShaderEditor.RangedFloatNode;14;-1804.969,-369.2996;Inherit;False;Property;_PosY1;PosY;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1811.37,-428.4997;Inherit;False;Property;_PosX1;PosX;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1795.369,-674.8997;Inherit;False;Property;_Height1;Height;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;17;-1868.968,-570.8997;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1800.169,-767.6997;Inherit;False;Property;_Width1;Width;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-1654.569,-431.6997;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-1641.77,-681.2997;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-1521.769,-511.6998;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-1414.561,-657.2994;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1655.127,-227.1715;Inherit;False;Property;_Radius1;Radius;7;0;Create;True;0;0;0;False;0;False;2;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1652.127,-121.1715;Inherit;False;Property;_Smoothness1;Smoothness;8;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1473.127,-19.17151;Inherit;False;Constant;_Float3;Float 0;1;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1254.127,-101.1715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-1281.127,-221.1715;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1322.161,-539.6995;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1079.127,-183.1715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;30;-1186.127,-443.1715;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-992.5294,-859.1115;Inherit;False;Constant;_Color1;Color 0;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;34;-914.1273,-336.1715;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-1072.772,-641.5272;Inherit;True;Property;_TextureSample1;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-302.2301,164.0367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1096.23,505.0367;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;7;-439.2301,296.0367;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;2;-647.2301,115.0367;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;8;-587.2301,405.0367;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-995.4203,117.3834;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;6c09620d7a2d17a469567a363c98c913;6c09620d7a2d17a469567a363c98c913;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;6;-641.2301,562.0367;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-929.2301,647.0367;Inherit;False;Property;_PowerMult;Power Mult;1;0;Create;True;0;0;0;False;0;False;2;4.53;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;3;-820.2301,491.0367;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;12;-1072.23,376.0367;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;41;-656.1273,-426.1715;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TvVignette;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;15;0
WireConnection;18;1;14;0
WireConnection;21;0;19;0
WireConnection;21;1;16;0
WireConnection;20;0;17;0
WireConnection;20;1;18;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;27;0;23;0
WireConnection;27;1;24;0
WireConnection;28;0;18;0
WireConnection;28;1;22;0
WireConnection;31;0;27;0
WireConnection;31;1;26;0
WireConnection;30;0;28;0
WireConnection;30;1;18;0
WireConnection;34;0;30;0
WireConnection;34;1;31;0
WireConnection;34;2;27;0
WireConnection;13;0;2;0
WireConnection;13;1;7;0
WireConnection;7;0;8;0
WireConnection;2;0;1;0
WireConnection;8;0;6;0
WireConnection;6;0;3;0
WireConnection;6;1;10;0
WireConnection;3;0;12;0
WireConnection;3;1;11;0
WireConnection;41;0;33;0
WireConnection;41;1;32;0
WireConnection;41;2;34;0
WireConnection;0;0;41;0
ASEEND*/
//CHKSM=51107B463652E4B24797B785A694CF3C480DB2CC