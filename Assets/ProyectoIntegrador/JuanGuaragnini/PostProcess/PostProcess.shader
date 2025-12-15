// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_TextureSample2("Texture Sample 0", 2D) = "white" {}
		_TextureSample3("Texture Sample 0", 2D) = "white" {}
		_TextureSample4("Texture Sample 0", 2D) = "white" {}
		_PixelDensity1("PixelDensity", Float) = 64
		_VignettePowerMult1("Vignette Power Mult", Range( 0 , 5)) = 2
		_BloomNoiseIntensity1("BloomNoiseIntensity", Float) = 0.1
		_BloomUmbral2("BloomUmbral", Float) = 0.8
		_Valor1("Valor1", Int) = 0
		_Valor2("Valor2", Int) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform int _Valor1;
			uniform int _Valor2;
			uniform sampler2D _TextureSample4;
			uniform float _PixelDensity1;
			uniform float _BloomUmbral2;
			uniform sampler2D _TextureSample3;
			uniform float4 _TextureSample3_ST;
			uniform float _BloomNoiseIntensity1;
			uniform sampler2D _TextureSample2;
			uniform float4 _TextureSample2_ST;
			uniform float _VignettePowerMult1;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 texCoord1 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 PixelEffect30 = ( 1.0 - tex2D( _TextureSample4, ( floor( ( texCoord1 * _PixelDensity1 ) ) / _PixelDensity1 ) ) );
				float4 temp_cast_0 = (_BloomUmbral2).xxxx;
				float2 uv_TextureSample3 = i.uv.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float4 tex2DNode2 = tex2D( _TextureSample3, uv_TextureSample3 );
				float4 TxtColor7 = tex2DNode2;
				float4 BloomEmission29 = ( ( step( temp_cast_0 , TxtColor7 ) * TxtColor7 ) * 4.0 );
				float simplePerlin2D22 = snoise( tex2DNode2.rg );
				simplePerlin2D22 = simplePerlin2D22*0.5 + 0.5;
				float4 NoiseAlbedo32 = ( tex2DNode2 + ( simplePerlin2D22 * _BloomNoiseIntensity1 ) );
				float2 uv_TextureSample2 = i.uv.xy * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
				float grayscale26 = Luminance(tex2D( _TextureSample2, uv_TextureSample2 ).rgb);
				float2 texCoord5 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float VignetteEffect33 = ( grayscale26 * saturate( ( 1.0 - pow( distance( float2( 0.5,0.5 ) , texCoord5 ) , _VignettePowerMult1 ) ) ) );
				float4 temp_cast_3 = (VignetteEffect33).xxxx;
				float4 ifLocalVar40 = 0;
				if( _Valor1 > _Valor2 )
				ifLocalVar40 = PixelEffect30;
				else if( _Valor1 == _Valor2 )
				ifLocalVar40 = ( BloomEmission29 + NoiseAlbedo32 );
				else if( _Valor1 < _Valor2 )
				ifLocalVar40 = temp_cast_3;
				

				finalColor = ifLocalVar40;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
1452;73;1107;1278;3050.199;1180.197;2.054959;True;False
Node;AmplifyShaderEditor.SamplerNode;2;-2386.557,-1184.799;Inherit;True;Property;_TextureSample3;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;6c09620d7a2d17a469567a363c98c913;6c09620d7a2d17a469567a363c98c913;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1961.083,-1207.806;Inherit;False;TxtColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2087.256,1053.543;Inherit;False;Property;_PixelDensity1;PixelDensity;3;0;Create;True;0;0;0;False;0;False;64;64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2104.869,300.7652;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-2080.869,171.7652;Inherit;False;Constant;_Vector2;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2152.254,941.7427;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;9;-1828.87,286.7652;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1937.87,442.7651;Inherit;False;Property;_VignettePowerMult1;Vignette Power Mult;4;0;Create;True;0;0;0;False;0;False;2;2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1863.654,1001.543;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2053.214,-613.9451;Inherit;False;Property;_BloomUmbral2;BloomUmbral;6;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-2062.083,-507.8058;Inherit;False;7;TxtColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;14;-1649.87,357.7651;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;8;-1708.958,1001.543;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;22;-1984.557,-1093.799;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1994.557,-920.7994;Inherit;False;Property;_BloomNoiseIntensity1;BloomNoiseIntensity;5;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;13;-1815.792,-620.7418;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1799.558,-940.7994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1684.085,-439.8058;Inherit;False;Constant;_BloomIntensity2;BloomIntensity;3;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-2004.06,-86.88818;Inherit;True;Property;_TextureSample2;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;6c09620d7a2d17a469567a363c98c913;6c09620d7a2d17a469567a363c98c913;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;20;-1595.87,200.7652;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-1560.758,997.6428;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1647.085,-575.8058;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;26;-1655.87,-89.23486;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-1399.558,974.2432;Inherit;True;Property;_TextureSample4;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;6c09620d7a2d17a469567a363c98c913;6c09620d7a2d17a469567a363c98c913;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1468.085,-526.8059;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1661.562,-1083.799;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;23;-1447.87,91.76512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1492.634,-1084.934;Inherit;False;NoiseAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-1317.085,-523.8059;Inherit;False;BloomEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1310.87,-40.23486;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-1077.158,988.5428;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-974.0624,217.4651;Inherit;False;32;NoiseAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1008.435,120.4781;Inherit;False;29;BloomEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-860.1387,1006.078;Inherit;False;PixelEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1093.863,-38.14426;Inherit;False;VignetteEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;42;-728.0283,-135.8478;Inherit;False;Property;_Valor1;Valor1;7;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-781.0624,136.4651;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-760.0283,60.15222;Inherit;False;30;PixelEffect;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-744.7353,247.0783;Inherit;False;33;VignetteEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;43;-723.0283,-50.84778;Inherit;False;Property;_Valor2;Valor2;8;0;Create;True;0;0;0;False;0;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.ConditionalIfNode;40;-490.0283,27.15222;Inherit;False;False;5;0;INT;0;False;1;INT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-257.4003,31.19999;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;7;0;2;0
WireConnection;9;0;6;0
WireConnection;9;1;5;0
WireConnection;4;0;1;0
WireConnection;4;1;3;0
WireConnection;14;0;9;0
WireConnection;14;1;10;0
WireConnection;8;0;4;0
WireConnection;22;0;2;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;27;0;22;0
WireConnection;27;1;21;0
WireConnection;20;0;14;0
WireConnection;15;0;8;0
WireConnection;15;1;3;0
WireConnection;17;0;13;0
WireConnection;17;1;12;0
WireConnection;26;0;16;0
WireConnection;19;1;15;0
WireConnection;25;0;17;0
WireConnection;25;1;18;0
WireConnection;28;0;2;0
WireConnection;28;1;27;0
WireConnection;23;0;20;0
WireConnection;32;0;28;0
WireConnection;29;0;25;0
WireConnection;31;0;26;0
WireConnection;31;1;23;0
WireConnection;24;0;19;0
WireConnection;30;0;24;0
WireConnection;33;0;31;0
WireConnection;48;0;45;0
WireConnection;48;1;47;0
WireConnection;40;0;42;0
WireConnection;40;1;43;0
WireConnection;40;2;44;0
WireConnection;40;3;48;0
WireConnection;40;4;46;0
WireConnection;0;0;40;0
ASEEND*/
//CHKSM=88742F7ECA944457C7B845A41F5B8C4A822FD062