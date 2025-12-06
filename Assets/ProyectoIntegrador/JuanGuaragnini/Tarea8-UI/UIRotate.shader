// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UIRotate"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_Mask("Mask", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_TextRotator("Text Rotator", 2D) = "white" {}
		_PosScale("Pos&Scale", Vector) = (0,0,1,5)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
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
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _TextRotator;
			uniform float4 _PosScale;
			uniform sampler2D _Mask;
			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float4 temp_output_57_0_g1 = _PosScale;
				float2 temp_output_2_0_g1 = (temp_output_57_0_g1).zw;
				float2 temp_cast_0 = (1.0).xx;
				float2 temp_output_13_0_g1 = ( ( ( IN.texcoord.xy + (temp_output_57_0_g1).xy ) * temp_output_2_0_g1 ) + -( ( temp_output_2_0_g1 - temp_cast_0 ) * 0.5 ) );
				float TimeVar197_g1 = _Time.y;
				float cos17_g1 = cos( TimeVar197_g1 );
				float sin17_g1 = sin( TimeVar197_g1 );
				float2 rotator17_g1 = mul( temp_output_13_0_g1 - float2( 0.5,0.5 ) , float2x2( cos17_g1 , -sin17_g1 , sin17_g1 , cos17_g1 )) + float2( 0.5,0.5 );
				float4 tex2DNode97_g1 = tex2D( _TextRotator, rotator17_g1 );
				float temp_output_115_0_g1 = step( ( (temp_output_13_0_g1).y + -0.5 ) , 0.0 );
				float lerpResult125_g1 = lerp( 1.0 , tex2D( _Mask, IN.texcoord.xy ).g , ( 1.0 - temp_output_115_0_g1 ));
				float2 uv_Texture0 = IN.texcoord.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float4 temp_output_192_0_g1 = tex2D( _Texture0, uv_Texture0 );
				
				half4 color = ( ( tex2DNode97_g1 * lerpResult125_g1 * tex2DNode97_g1.a ) + temp_output_192_0_g1 );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
884;81;851;952;1755.722;1364.919;2.28462;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1250.162,-407.1674;Inherit;True;Property;_Texture0;Texture 0;8;0;Create;True;0;0;0;False;0;False;2c6536772776dd84f872779990273bfc;2c6536772776dd84f872779990273bfc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;3;-924.5386,-399.8109;Inherit;True;Property;_Textura;Textura;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;4;-767.8004,114.8215;Inherit;False;Property;_PosScale;Pos&Scale;10;0;Create;True;0;0;0;False;0;False;0,0,1,5;0,0,1,5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;-991.2804,32.97337;Inherit;True;Property;_Mask;Mask;0;0;Create;True;0;0;0;False;0;False;8a3452a842b60a84e92eb36a217964cb;8a3452a842b60a84e92eb36a217964cb;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;2;-991.8962,-152.586;Inherit;True;Property;_TextRotator;Text Rotator;9;0;Create;True;0;0;0;False;0;False;2c9b6d719126a3f4c9d93e64a70e4c1e;2c9b6d719126a3f4c9d93e64a70e4c1e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;5;-385.7668,-1.389523;Inherit;False;UI-Sprite Effect Layer;1;;1;789bf62641c5cfe4ab7126850acc22b8;18,74,2,204,2,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,1,234,0,126,0,129,1,130,1,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;4;UIRotate;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;0;8;0
WireConnection;5;192;3;0
WireConnection;5;37;2;0
WireConnection;5;101;1;0
WireConnection;5;57;4;0
WireConnection;0;0;5;0
ASEEND*/
//CHKSM=082EDF41E7B080736E2C3D9B12403944DCB6F537