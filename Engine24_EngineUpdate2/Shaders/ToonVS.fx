// ��� ���� ����.
cbuffer CBPerObject
{
	matrix world;		// ���� ���.
	matrix view;		// �� ���.
	matrix projection;	// ���� ���.
};

// ��� ���� - ����Ʈ ����.
cbuffer CBLight
{
	float3 worldLightPosition;
	float3 worldCameraPosition;
};

// ���� �Է� ����ü.
struct VS_INPUT
{
	float4 pos : POSITION;
	float2 texCoord : TEXCOORD;
	float3 normal : NORMAL;
};

// ���� ��� ����ü.
struct VS_OUTPUT
{	
	float4 pos : SV_POSITION;
	float2 texCoord : TEXCOORD;
	float3 diffuse : TEXCOORD1;
	float3 viewDir : TEXCOORD2;
	float3 reflection : TEXCOORD3;
};

VS_OUTPUT main(VS_INPUT input)
{
	float3 suerfaceColor = float3(0.0f, 1.0f, 0.0f);

	VS_OUTPUT output;

	// ���� ��ȯ.
	output.pos = mul(input.pos, world);

	// ����Ʈ ���� ���ϱ�.
	float3 lightDir = output.pos.xyz - worldLightPosition;
	// ���� ���ͷ� �����.
	lightDir = normalize(lightDir);

	// �� ���� ���ϱ� (�������� ó��).
	float3 viewDir = normalize(output.pos.xyz - worldCameraPosition);
	output.viewDir = viewDir;

	// �� ��ȯ.
	output.pos = mul(output.pos, view);
	// ���� ��ȯ.
	output.pos = mul(output.pos, projection);

	// ���� ��� ���ϱ�.
	float3 worldNormal 
		= mul(input.normal, (float3x3)world);
	// ���� ���ͷ� �����.
	worldNormal = normalize(worldNormal);

	// ��ǻ�� ��� (dot = ����).
	output.diffuse = dot(-lightDir, worldNormal);

	// �ݻ� ���� ���ϱ� (reflect = �ݻ籤 ���ϴ� �Լ�).
	output.reflection = reflect(lightDir, worldNormal);

	// �ؽ�ó ��ǥ ��ȯ.
	output.texCoord = input.texCoord;

	return output;
}