// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpriteDissolve"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_DirdeDissolve("DirdeDissolve", 2D) = "white" {}
		_Umbral("Umbral", Range( 0 , 1)) = 0.5
		_Textura("Textura", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		
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
			uniform sampler2D _DirdeDissolve;
			uniform float4 _DirdeDissolve_ST;
			uniform sampler2D _Textura;
			uniform float4 _Textura_ST;
			uniform float _Umbral;

			
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

				float2 uv_DirdeDissolve = IN.texcoord.xy * _DirdeDissolve_ST.xy + _DirdeDissolve_ST.zw;
				float4 tex2DNode3 = tex2D( _DirdeDissolve, uv_DirdeDissolve );
				float4 BurntTexture38 = tex2DNode3;
				float2 uv_Textura = IN.texcoord.xy * _Textura_ST.xy + _Textura_ST.zw;
				float4 tex2DNode20 = tex2D( _Textura, uv_Textura );
				float4 Texture40 = tex2DNode20;
				float TextureAlpha41 = tex2DNode20.a;
				float4 temp_cast_0 = (_Umbral).xxxx;
				float4 Step18 = step( temp_cast_0 , tex2DNode3 );
				float4 temp_output_31_0 = saturate( ( float4( 1,1,1,0 ) * ( TextureAlpha41 * Step18 ) ) );
				float4 lerpResult30 = lerp( BurntTexture38 , Texture40 , temp_output_31_0);
				float4 break36 = lerpResult30;
				float4 appendResult37 = (float4(break36.r , break36.g , break36.b , temp_output_31_0.r));
				float4 Result13 = appendResult37;
				
				fixed4 c = Result13;
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
1644;73;915;1278;2026.149;996.4854;1.3;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;2;-2082.392,-691.6368;Inherit;True;Property;_DirdeDissolve;DirdeDissolve;0;0;Create;True;0;0;0;False;0;False;0203bc3bf47efb84ca5cf01effeed7ba;c9cddf36de4a01542866d59e7b126154;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1822.468,-567.9901;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1550.334,-723.5734;Inherit;False;Property;_Umbral;Umbral;1;0;Create;True;0;0;0;False;0;False;0.5;0.558;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1552.434,-643.5992;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;19;-2556.571,-201.1804;Inherit;True;Property;_Textura;Textura;2;0;Create;True;0;0;0;False;0;False;None;8bab5ab76ae712243bd36da71b105f17;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StepOpNode;7;-1248.848,-675.7346;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;20;-2335.339,-200.533;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1113.212,-678.1907;Inherit;False;Step1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-1987.528,-181.263;Inherit;False;TextureAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1639.579,-133.3735;Inherit;False;41;TextureAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;-1625.617,-56.75293;Inherit;False;8;Step1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1412.606,-102.1758;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-2006.437,-284.5598;Inherit;False;Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1263.633,-102.8699;Inherit;False;2;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-1250.676,-563.453;Inherit;False;BurntTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;31;-1103.698,-95.22426;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-1169.162,-270.5905;Inherit;False;38;BurntTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1161.106,-199.0793;Inherit;False;40;Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;30;-955.8369,-244.4475;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;36;-779.8161,-225.6897;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;37;-638.6743,-207.1241;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-491.5734,-204.7525;Inherit;False;Result;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-588.6168,-415.8781;Inherit;False;13;Result;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-401.1946,-406.9758;Float;False;True;-1;2;ASEMaterialInspector;0;6;SpriteDissolve;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;5;2;2;0
WireConnection;3;0;2;0
WireConnection;3;1;5;0
WireConnection;7;0;4;0
WireConnection;7;1;3;0
WireConnection;20;0;19;0
WireConnection;8;0;7;0
WireConnection;41;0;20;4
WireConnection;21;0;42;0
WireConnection;21;1;10;0
WireConnection;40;0;20;0
WireConnection;11;1;21;0
WireConnection;38;0;3;0
WireConnection;31;0;11;0
WireConnection;30;0;39;0
WireConnection;30;1;43;0
WireConnection;30;2;31;0
WireConnection;36;0;30;0
WireConnection;37;0;36;0
WireConnection;37;1;36;1
WireConnection;37;2;36;2
WireConnection;37;3;31;0
WireConnection;13;0;37;0
WireConnection;0;0;14;0
ASEEND*/
//CHKSM=CBA285D7E493DBDD69EDC32FFA432CA7B8ABC8DF