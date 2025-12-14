// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CardBkrgnd"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_AnchoNoise("AnchoNoise", Float) = -0.09
		_Movement("Movement", Vector) = (0.1,0.1,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		Stencil
		{
			Ref 0
			Comp NotEqual
			Pass Keep
			Fail Keep
		}
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform sampler2D _TextureSample0;
		uniform float2 _Movement;
		uniform sampler2D _Noise;
		uniform float _AnchoNoise;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 panner81 = ( _Time.y * _Movement + (ase_screenPosNorm).xyzw.xy);
			float2 ResMov85 = panner81;
			float4 lerpResult75 = lerp( float4( 0,0,0,0 ) , tex2D( _TextureSample0, ResMov85 ) , ceil( saturate( ( 1.0 - ( tex2D( _Noise, ResMov85 ).r + _AnchoNoise ) ) ) ));
			o.Albedo = lerpResult75.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
917;73;1136;927;4209.427;262.8763;2.27704;True;False
Node;AmplifyShaderEditor.CommentaryNode;88;-3375.31,872.1398;Inherit;False;1149.156;453.1451;Comment;6;72;82;73;84;81;85;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;72;-3325.311,922.1398;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;84;-3087.828,1076.659;Inherit;False;Property;_Movement;Movement;3;0;Create;True;0;0;0;False;0;False;0.1,0.1;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;73;-2994.306,978.5316;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;82;-2993.144,1214.285;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;81;-2745.235,1057.817;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-2450.155,1005.557;Inherit;False;ResMov;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-3457.046,331.1646;Inherit;False;85;ResMov;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;76;-3215.963,321.3232;Inherit;True;Property;_Noise;Noise;1;0;Create;True;0;0;0;False;0;False;-1;None;714f4664f55c45c46b53f75dcd662d4d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-3083.662,513.9652;Inherit;False;Property;_AnchoNoise;AnchoNoise;2;0;Create;True;0;0;0;False;0;False;-0.09;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-2906.563,440.0231;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;83;-2757.715,451.2852;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;79;-2607.982,452.6224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-2861.844,227.3457;Inherit;False;85;ResMov;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CeilOpNode;80;-2473.762,451.9232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;-2641.81,220.8525;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;75;-2309.569,394.588;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-2087.07,417.2337;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;CardBkrgnd;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;0;False;-1;255;False;-1;255;False;-1;6;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;73;0;72;0
WireConnection;81;0;73;0
WireConnection;81;2;84;0
WireConnection;81;1;82;0
WireConnection;85;0;81;0
WireConnection;76;1;86;0
WireConnection;78;0;76;1
WireConnection;78;1;77;0
WireConnection;83;0;78;0
WireConnection;79;0;83;0
WireConnection;80;0;79;0
WireConnection;74;1;87;0
WireConnection;75;1;74;0
WireConnection;75;2;80;0
WireConnection;0;0;75;0
ASEEND*/
//CHKSM=5749182C6AC91C16D6680A7A1565997EE86EA334