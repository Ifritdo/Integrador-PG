// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ProjRender"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Vector1("Vector 1", Vector) = (0,0,0,0)

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform sampler2D _Texture0;
			uniform float4 _Vector1;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float4 temp_output_57_0_g1 = _Vector1;
				float2 temp_output_2_0_g1 = (temp_output_57_0_g1).zw;
				float2 temp_cast_0 = (1.0).xx;
				float2 temp_output_13_0_g1 = ( ( ( IN.texcoord.xy + (temp_output_57_0_g1).xy ) * temp_output_2_0_g1 ) + -( ( temp_output_2_0_g1 - temp_cast_0 ) * 0.5 ) );
				float mulTime104 = _Time.y * 0.2;
				float TimeVar197_g1 = mulTime104;
				float cos17_g1 = cos( TimeVar197_g1 );
				float sin17_g1 = sin( TimeVar197_g1 );
				float2 rotator17_g1 = mul( temp_output_13_0_g1 - float2( 0.5,0.5 ) , float2x2( cos17_g1 , -sin17_g1 , sin17_g1 , cos17_g1 )) + float2( 0.5,0.5 );
				float4 tex2DNode97_g1 = tex2D( _Texture0, rotator17_g1 );
				
				fixed4 c = tex2DNode97_g1;
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
884;81;851;952;1842.666;1382.042;2.821806;True;False
Node;AmplifyShaderEditor.CommentaryNode;59;-758.9814,31.69146;Inherit;False;1087.492;363.6394;Projector;7;10;9;11;12;13;14;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;10;-706.6453,188.3308;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityProjectorMatrixNode;9;-708.9813,81.69142;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-510.8485,151.5311;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;12;-381.0471,150.7311;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;13;-242.8483,146.931;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-76.28851,174.2382;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;104.5115,180.5941;Inherit;False;Projector;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-889.2601,-155.6612;Inherit;False;54;Projector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-664.6999,-611.6217;Inherit;False;Constant;_frequency;frequency;4;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-961.6312,-397.0531;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;None;9dd67e0d3d3cb694fa56f0f95740e85c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleTimeNode;104;-459.5413,-535.2976;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-648.2972,-247.7985;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;6c09620d7a2d17a469567a363c98c913;d710ce45bb70a4341bf82edae6bf7596;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;105;-339.6999,-221.6217;Inherit;False;Property;_Vector1;Vector 1;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,2,2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;103;-138.8528,-293.3734;Inherit;False;UI-Sprite Effect Layer;1;;1;789bf62641c5cfe4ab7126850acc22b8;18,74,2,204,2,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;102;311.3855,-232.8454;Float;False;True;-1;2;ASEMaterialInspector;0;6;ProjRender;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;12;0;11;0
WireConnection;13;0;12;0
WireConnection;13;1;12;1
WireConnection;14;0;13;0
WireConnection;14;1;12;3
WireConnection;54;0;14;0
WireConnection;104;0;106;0
WireConnection;6;0;16;0
WireConnection;6;1;91;0
WireConnection;103;192;6;0
WireConnection;103;37;16;0
WireConnection;103;57;105;0
WireConnection;103;40;104;0
WireConnection;102;0;103;0
ASEEND*/
//CHKSM=A342EE134C8593EB235D788DC7E2BD92315DBCBE