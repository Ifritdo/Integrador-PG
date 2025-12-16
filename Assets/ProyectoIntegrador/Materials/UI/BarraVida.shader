// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BarraVida"
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
		_Texture0("Texture 0", 2D) = "white" {}
		_TrailingHealth("_TrailingHealth", Float) = 0

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
			uniform float _TrailingHealth;
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

				float4 color34 = IsGammaSpace() ? float4(0.8396226,0.3402731,0.01980242,1) : float4(0.673178,0.09478674,0.001532695,1);
				float _TrailingHealth33 = _TrailingHealth;
				float2 temp_cast_0 = (step( (float4( 0,0,0,0 )).x , _TrailingHealth33 )).xx;
				float2 uv_Texture0 = IN.texcoord.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float _HealthRatio18 = 1.0;
				float2 temp_cast_1 = (_HealthRatio18).xx;
				float2 panner8 = ( 1.0 * _Time.y * float2( 0.25,0.25 ) + uv_Texture0);
				float4 color12 = IsGammaSpace() ? float4(0,0.772549,0,1) : float4(0,0.5583404,0,1);
				float4 color14 = IsGammaSpace() ? float4(0.8773585,0.01241543,0.01241543,1) : float4(0.7433497,0.0009609465,0.0009609465,1);
				float4 color13 = IsGammaSpace() ? float4(1,0.7892342,0.004716992,1) : float4(1,0.5857404,0.0003650922,1);
				float _LowThreshold20 = 0.25;
				float4 lerpResult24 = lerp( color14 , color13 , step( _LowThreshold20 , _HealthRatio18 ));
				float _MidThreshold21 = 0.5;
				float4 lerpResult30 = lerp( color12 , lerpResult24 , step( _HealthRatio18 , _MidThreshold21 ));
				
				half4 color = ( ( color34 * float4( ( temp_cast_0 - step( (uv_Texture0).xy , temp_cast_1 ) ), 0.0 , 0.0 ) ) + ( tex2D( _Texture0, panner8 ) * lerpResult30 ) );
				
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
251;73;1206;521;2352.313;-316.6105;1.461388;True;False
Node;AmplifyShaderEditor.RangedFloatNode;16;-166.2637,460.7929;Inherit;False;Constant;_LowThreshold;_LowThreshold;1;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-167.6399,538.7267;Inherit;False;Constant;_HealthRatio;_HealthRatio;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-164.5101,383.308;Inherit;False;Constant;_MidThreshold;_MidThreshold;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;21.93858,461.3039;Inherit;False;_LowThreshold;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;21.48372,539.0536;Inherit;False;_HealthRatio;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-165.3428,289.3071;Inherit;False;Property;_TrailingHealth;_TrailingHealth;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-2120.903,27.25051;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;d01457b88b1c5174ea4235d140b5fab8;d01457b88b1c5174ea4235d140b5fab8;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;23.20415,384.2454;Inherit;False;_MidThreshold;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-1703.209,842.74;Inherit;False;18;_HealthRatio;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-1717.209,767.7399;Inherit;False;20;_LowThreshold;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;24.39944,290.3071;Inherit;False;_TrailingHealth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1714.02,-210.2443;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1389.388,-72.46888;Inherit;False;18;_HealthRatio;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;-1388.69,-208.4445;Inherit;False;True;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;35;-1418.598,-494.7031;Inherit;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-1415.451,-334.6254;Inherit;False;33;_TrailingHealth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-1593.078,350.9359;Inherit;False;Constant;_LowHealthColor;_LowHealthColor;1;0;Create;True;0;0;0;False;0;False;0.8773585,0.01241543,0.01241543,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1531.687,1018.497;Inherit;False;21;_MidThreshold;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1520.687,923.1793;Inherit;False;18;_HealthRatio;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1593.179,569.2742;Inherit;False;Constant;_MidHealthColor;_MidHealthColor;1;0;Create;True;0;0;0;False;0;False;1,0.7892342,0.004716992,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;25;-1485.208,796.74;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;36;-1165.179,-402.5221;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;-1319.606,550.0409;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;26;-1256.19,971.784;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-1308.922,786.1823;Inherit;False;Constant;_HighHealthColor;_HighHealthColor;1;0;Create;True;0;0;0;False;0;False;0,0.772549,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;8;-1376.198,100.875;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.25,0.25;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;6;-1169.573,-144.6703;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;30;-1064.133,768.5963;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-1136.085,28.08291;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;38;-944.9328,-226.9874;Inherit;False;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;34;-1039.498,-537.3438;Inherit;False;Constant;_DamageColor;_DamageColor;2;0;Create;True;0;0;0;False;0;False;0.8396226,0.3402731,0.01980242,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-750.9149,152.5229;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-775.7597,-253.208;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-320.2089,-0.664032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;4;BarraVida;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;20;0;16;0
WireConnection;18;0;1;0
WireConnection;21;0;15;0
WireConnection;33;0;32;0
WireConnection;3;2;9;0
WireConnection;5;0;3;0
WireConnection;25;0;23;0
WireConnection;25;1;22;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;24;0;14;0
WireConnection;24;1;13;0
WireConnection;24;2;25;0
WireConnection;26;0;27;0
WireConnection;26;1;28;0
WireConnection;8;0;3;0
WireConnection;6;0;5;0
WireConnection;6;1;19;0
WireConnection;30;0;12;0
WireConnection;30;1;24;0
WireConnection;30;2;26;0
WireConnection;4;0;9;0
WireConnection;4;1;8;0
WireConnection;38;0;36;0
WireConnection;38;1;6;0
WireConnection;11;0;4;0
WireConnection;11;1;30;0
WireConnection;39;0;34;0
WireConnection;39;1;38;0
WireConnection;40;0;39;0
WireConnection;40;1;11;0
WireConnection;0;0;40;0
ASEEND*/
//CHKSM=34B928F436656B309376F9A053FA548552610E69