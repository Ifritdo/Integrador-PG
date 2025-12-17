// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CardText"
{
	Properties
	{
		_Transition("Transition", Range( 0 , 1)) = 1
		_Shine("Shine", Float) = 0
		_Metallic("Metallic", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform float _Transition;
		uniform float _Metallic;
		uniform float _Shine;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color1 = IsGammaSpace() ? float4(0.5660378,0.5660378,0.5660378,0) : float4(0.280335,0.280335,0.280335,0);
			float4 color2 = IsGammaSpace() ? float4(1,0.9848047,0,0) : float4(1,0.9657804,0,0);
			float4 lerpResult4 = lerp( color1 , color2 , _Transition);
			o.Albedo = lerpResult4.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Shine;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
202;73;1338;632;1175.857;339.1088;1.245512;True;False
Node;AmplifyShaderEditor.ColorNode;1;-654.3433,-260.3227;Inherit;False;Constant;_Metal;Metal;0;0;Create;True;0;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-703.3193,-91.94386;Inherit;False;Constant;_Gold;Gold;0;0;Create;True;0;0;0;False;0;False;1,0.9848047,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-729.0312,102.494;Inherit;False;Property;_Transition;Transition;0;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-401.6029,444.9679;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0.9;0.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-333.6819,-72.71041;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-287.0964,106.1902;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;False;0;False;1;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-275.1022,190.4812;Inherit;False;Property;_Shine;Shine;1;0;Create;True;0;0;0;False;0;False;0;1.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;22;136.538,-93.34262;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CardText;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;0
WireConnection;4;1;2;0
WireConnection;4;2;3;0
WireConnection;22;0;4;0
WireConnection;22;3;5;0
WireConnection;22;4;8;0
ASEEND*/
//CHKSM=AC2500D64EB375E818632326C44A81BECFBB50BB