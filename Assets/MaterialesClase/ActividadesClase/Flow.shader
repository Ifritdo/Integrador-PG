// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Flow"
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
		_Color0("Color 0", Color) = (0.4528302,0.07475969,0.07475969,1)
		_DistortionNormal("DistortionNormal", 2D) = "white" {}
		_DistortionMask1("DistortionMask", 2D) = "white" {}
		_DistortionEffect("DistortionEffect", 2D) = "white" {}
		_PosScaleCircle("Pos/ScaleCircle", Vector) = (0,0,0,0)
		_Ramp("Ramp", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Flow("Flow", 2D) = "white" {}
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
			#include "UnityStandardUtils.cginc"

			
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
			uniform sampler2D _Ramp;
			uniform sampler2D _Flow;
			uniform float4 _Flow_ST;
			uniform float4 _Color0;
			uniform sampler2D _DistortionEffect;
			uniform sampler2D _DistortionNormal;
			uniform float4 _DistortionEffect_ST;
			uniform sampler2D _DistortionMask1;
			uniform sampler2D _Texture0;
			uniform float4 _PosScaleCircle;

			
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

				float2 uv_Flow = IN.texcoord.xy * _Flow_ST.xy + _Flow_ST.zw;
				float4 tex2DNode14_g6 = tex2D( _Flow, uv_Flow );
				float2 appendResult20_g6 = (float2(tex2DNode14_g6.r , tex2DNode14_g6.g));
				float mulTime19 = _Time.y * 0.1;
				float TimeVar197_g6 = mulTime19;
				float2 temp_cast_0 = (TimeVar197_g6).xx;
				float2 temp_output_18_0_g6 = ( appendResult20_g6 - temp_cast_0 );
				float4 tex2DNode72_g6 = tex2D( _Ramp, temp_output_18_0_g6 );
				float2 uv_DistortionEffect = IN.texcoord.xy * _DistortionEffect_ST.xy + _DistortionEffect_ST.zw;
				float2 MainUvs222_g5 = uv_DistortionEffect;
				float4 tex2DNode65_g5 = tex2D( _DistortionNormal, MainUvs222_g5 );
				float4 appendResult82_g5 = (float4(0.0 , tex2DNode65_g5.g , 0.0 , tex2DNode65_g5.r));
				float2 temp_output_84_0_g5 = (UnpackScaleNormal( appendResult82_g5, _SinTime.w )).xy;
				float2 temp_output_71_0_g5 = ( ( temp_output_84_0_g5 * tex2D( _DistortionMask1, MainUvs222_g5 ).g ) + MainUvs222_g5 );
				float4 tex2DNode96_g5 = tex2D( _DistortionEffect, temp_output_71_0_g5 );
				float2 uv_DistortionMask1232_g5 = IN.texcoord.xy;
				float4 temp_output_57_0_g4 = _PosScaleCircle;
				float2 temp_output_2_0_g4 = (temp_output_57_0_g4).zw;
				float2 temp_cast_1 = (1.0).xx;
				float2 temp_output_13_0_g4 = ( ( ( IN.texcoord.xy + (temp_output_57_0_g4).xy ) * temp_output_2_0_g4 ) + -( ( temp_output_2_0_g4 - temp_cast_1 ) * 0.5 ) );
				float TimeVar197_g4 = _Time.y;
				float cos17_g4 = cos( TimeVar197_g4 );
				float sin17_g4 = sin( TimeVar197_g4 );
				float2 rotator17_g4 = mul( temp_output_13_0_g4 - float2( 0.5,0.5 ) , float2x2( cos17_g4 , -sin17_g4 , sin17_g4 , cos17_g4 )) + float2( 0.5,0.5 );
				float4 tex2DNode97_g4 = tex2D( _Texture0, rotator17_g4 );
				float temp_output_115_0_g4 = step( ( (temp_output_13_0_g4).y + -0.5 ) , 0.0 );
				float lerpResult125_g4 = lerp( 1.0 , tex2D( _DistortionMask1, IN.texcoord.xy ).g , ( 1.0 - temp_output_115_0_g4 ));
				float4 temp_output_192_0_g5 = ( ( tex2DNode97_g4 * lerpResult125_g4 * tex2DNode97_g4.a ) * float4( 0.7830189,0,0.64833,1 ) );
				float4 temp_output_192_0_g6 = ( ( tex2DNode96_g5 * tex2DNode96_g5.a * tex2D( _DistortionMask1, uv_DistortionMask1232_g5 ).g ) + temp_output_192_0_g5 );
				
				half4 color = ( ( ( tex2DNode72_g6 * tex2DNode14_g6.a ) * _Color0 ) + temp_output_192_0_g6 );
				
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
270;73;1230;631;1569.239;22.72316;1.203463;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;62;-2375.6,434.6427;Inherit;True;Property;_DistortionMask1;DistortionMask;9;0;Create;True;0;0;0;False;0;False;8a3452a842b60a84e92eb36a217964cb;8a3452a842b60a84e92eb36a217964cb;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;67;-2530.311,-433.3669;Inherit;False;655.5737;701.6455;Rotacion;4;66;35;29;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-2100.428,435.3858;Inherit;False;mascara;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;28;-1789.494,-295.8698;Inherit;False;902.7258;1069.876;Distortion;5;20;27;26;23;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;66;-2442.332,63.21759;Inherit;False;Property;_PosScaleCircle;Pos/ScaleCircle;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,1,4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2432.19,-48.17434;Inherit;False;63;mascara;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;35;-2453.414,-294.1042;Inherit;True;Property;_Texture0;Texture 0;13;0;Create;True;0;0;0;False;0;False;None;2c9b6d719126a3f4c9d93e64a70e4c1e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;29;-2163.476,-95.01649;Inherit;False;UI-Sprite Effect Layer;0;;4;789bf62641c5cfe4ab7126850acc22b8;18,74,2,204,2,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,1,234,0,126,0,129,1,130,1,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;0.7830189,0,0.64833,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.GetLocalVarNode;65;-1409.204,507.7226;Inherit;False;63;mascara;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;26;-1738.641,286.7417;Inherit;True;Property;_DistortionNormal;DistortionNormal;8;0;Create;True;0;0;0;False;0;False;d710ce45bb70a4341bf82edae6bf7596;07f75d8515799c849b3b4bd1c9b9626a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;23;-1740.313,26.05479;Inherit;True;Property;_DistortionEffect;DistortionEffect;10;0;Create;True;0;0;0;False;0;False;a8eca4af2b85eea48b25c10a52da2666;a8eca4af2b85eea48b25c10a52da2666;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;21;-874.5167,-292.2051;Inherit;False;842.1376;897.2574;FLOW;5;1;2;6;17;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinTimeNode;27;-1645.929,517.3453;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;6;-852.8775,157.004;Inherit;True;Property;_Ramp;Ramp;12;0;Create;True;0;0;0;False;0;False;1e508ccbcac51df45a949ccba3fcadca;1e508ccbcac51df45a949ccba3fcadca;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleTimeNode;19;-505.0078,419.5751;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-836.477,367.7827;Inherit;True;Property;_Flow;Flow;14;0;Create;True;0;0;0;False;0;False;6525cc3a0b430154eba0612a6a0d7b4d;6525cc3a0b430154eba0612a6a0d7b4d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;2;-796.3652,-21.19249;Inherit;False;Property;_Color0;Color 0;7;0;Create;True;0;0;0;False;0;False;0.4528302,0.07475969,0.07475969,1;0.990566,0.004672492,0.8039547,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;20;-1243.77,-117.944;Inherit;False;UI-Sprite Effect Layer;0;;5;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,1,177,0,182,0,229,1,92,0,98,0,234,0,126,0,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.FunctionNode;1;-343.5304,-130.6686;Inherit;False;UI-Sprite Effect Layer;0;;6;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,0,234,0,126,0,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-14.74521,-127.199;Float;False;True;-1;2;ASEMaterialInspector;0;4;Flow;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;63;0;62;0
WireConnection;29;37;35;0
WireConnection;29;101;64;0
WireConnection;29;57;66;0
WireConnection;20;192;29;0
WireConnection;20;37;23;0
WireConnection;20;75;26;0
WireConnection;20;80;27;4
WireConnection;20;188;65;0
WireConnection;20;233;65;0
WireConnection;1;192;20;0
WireConnection;1;39;2;0
WireConnection;1;37;6;0
WireConnection;1;33;17;0
WireConnection;1;40;19;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=97C8A55D76022F6A0915D04C7001FD93CC120C20