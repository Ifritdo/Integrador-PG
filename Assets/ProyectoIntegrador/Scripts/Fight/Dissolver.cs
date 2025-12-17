using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dissolver : MonoBehaviour
{
    [SerializeField] private Material dissolveMaterialTemplate;
    [SerializeField] private float dissolveDuration = 1.5f; // Duración en segundos
    private const string DissolveAmountPropertyName = "_DissolveAmount";

    // COLECCIONES
    private Renderer[] characterRenderers; // Todos los Renderers (muñeco, huesos, etc.)
    private List<Material> allRuntimeDissolveMaterials = new List<Material>();

    private void Awake()
    {
        // 1. Obtener TODOS los Renderers en los hijos (incluyendo inactivos, si es necesario)
        characterRenderers = GetComponentsInChildren<Renderer>(true);
        if (characterRenderers.Length == 0) return;

        // 2. Crear los materiales de disolución en tiempo de ejecución (runtime)
        foreach (Renderer renderer in characterRenderers)
        {
            Material[] mats = new Material[renderer.sharedMaterials.Length];

            for (int i = 0; i < mats.Length; i++)
            {
                Material dissolvedMat = Instantiate(dissolveMaterialTemplate);
                mats[i] = dissolvedMat;
                allRuntimeDissolveMaterials.Add(dissolvedMat);
            }
        }
    }

    public void StartDissolve()
    {
        if (characterRenderers.Length == 0 || allRuntimeDissolveMaterials.Count == 0) return;

        // 1. ASIGNAR LOS NUEVOS MATERIALES A TODOS LOS RENDERERS
        int materialIndex = 0;
        foreach (Renderer renderer in characterRenderers)
        {
            Material[] matsToAssign = new Material[renderer.sharedMaterials.Length];
            for (int i = 0; i < matsToAssign.Length; i++)
            {
                matsToAssign[i] = allRuntimeDissolveMaterials[materialIndex];
                materialIndex++;
            }
            renderer.materials = matsToAssign; // Esto reemplaza los materiales existentes
        }

        // 2. Iniciar la disolución
        StartCoroutine(AnimateDissolve());
    }

    private IEnumerator AnimateDissolve()
    {
        float time = 0f;

        // PASO 1: Inicialización (Debe ser Visible = 1.0)
        foreach (var mat in allRuntimeDissolveMaterials)
        {
            mat.SetFloat(DissolveAmountPropertyName, 1f);
        }

        while (time < dissolveDuration)
        {
            float t = time / dissolveDuration;

            // PASO 2: ANIMACIÓN (De 1.0 a 0.0)
            float dissolveValue = Mathf.Lerp(1f, 0f, t); // ¡CAMBIO CLAVE!

            foreach (var mat in allRuntimeDissolveMaterials)
            {
                mat.SetFloat(DissolveAmountPropertyName, dissolveValue);
            }

            time += Time.deltaTime;
            yield return null;
        }

        // PASO 3: Asegurar el valor final (Invisible = 0.0)
        foreach (var mat in allRuntimeDissolveMaterials)
        {
            mat.SetFloat(DissolveAmountPropertyName, 0f); // ¡CAMBIO CLAVE!
        }

        // Opcional: Desactivar el objeto principal
        // gameObject.SetActive(false); 
    }
}