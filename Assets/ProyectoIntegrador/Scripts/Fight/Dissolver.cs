using System.Collections;
using System.Collections.Generic; // Necesario para la lista de Materiales
using UnityEngine;

public class Dissolver : MonoBehaviour
{
    [SerializeField] private Material dissolveMaterialTemplate;
    [SerializeField] private float dissolveDuration = 1.5f; // Duración en segundos
    private const string DissolveAmountPropertyName = "_DissolveAmount";

    // COLECCIONES
    private Renderer[] characterRenderers; // Todos los Renderers (muñeco, huesos, etc.)

    // Lista de todos los materiales clonados que vamos a animar.
    private List<Material> allRuntimeDissolveMaterials = new List<Material>();

    private void Awake()
    {
        // 1. Obtener TODOS los Renderers en los hijos (incluyendo inactivos, si es necesario)
        characterRenderers = GetComponentsInChildren<Renderer>(true);
        if (characterRenderers.Length == 0) return;

        // 2. Crear los materiales de disolución en tiempo de ejecución (runtime)
        foreach (Renderer renderer in characterRenderers)
        {
            // Clona el material para que los cambios sean únicos a este objeto
            // y no afecte a otros personajes que compartan el mismo material base.
            Material[] mats = new Material[renderer.sharedMaterials.Length];

            for (int i = 0; i < mats.Length; i++)
            {
                // Instanciar el material Dissolve template para cada ranura de material
                Material dissolvedMat = Instantiate(dissolveMaterialTemplate);
                mats[i] = dissolvedMat;
                allRuntimeDissolveMaterials.Add(dissolvedMat);
            }

            // NO se asigna aquí. Solo se crea.
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
            renderer.materials = matsToAssign;
        }

        // 2. Iniciar la disolución
        StartCoroutine(AnimateDissolve());
    }

    private IEnumerator AnimateDissolve()
    {
        float time = 0f;

        // ¡CRÍTICO! Inicializar el valor a 0.0 para que la transición no sea instantánea
        foreach (var mat in allRuntimeDissolveMaterials)
        {
            mat.SetFloat(DissolveAmountPropertyName, 0f);
        }

        while (time < dissolveDuration)
        {
            float t = time / dissolveDuration;
            float dissolveValue = Mathf.Lerp(0f, 1f, t);

            // ¡Iterar sobre TODOS los materiales clonados para animarlos!
            foreach (var mat in allRuntimeDissolveMaterials)
            {
                mat.SetFloat(DissolveAmountPropertyName, dissolveValue);
            }

            time += Time.deltaTime;
            yield return null; // Espera al siguiente frame (soluciona lo instantáneo)
        }

        // Asegurar el valor final (1.0)
        foreach (var mat in allRuntimeDissolveMaterials)
        {
            mat.SetFloat(DissolveAmountPropertyName, 1f);
        }

        // Si quieres ocultar el objeto al final
        // gameObject.SetActive(false); 
    }
}