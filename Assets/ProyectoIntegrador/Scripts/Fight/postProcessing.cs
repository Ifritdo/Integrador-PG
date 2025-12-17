using System.Collections;
using UnityEngine;

public class postProcessing : MonoBehaviour
{
    [SerializeField] private Shader shader;
    private Material material;

    // Nombre de la propiedad Float de tu shader (debe coincidir con '_GrayscaleAmount')
    private const string GrayscaleAmountPropertyName = "_GrayscaleAmount";

    // Duración del efecto de fundido a gris, ajustable en el Inspector
    [SerializeField] private float transitionDuration = 2.0f;

    private void Awake()
    {
        // Verificar que el shader esté asignado y crear el material
        if (shader == null)
        {
            Debug.LogError("Shader is not assigned to postProcessing script.");
            return;
        }
        material = new Material(shader);

        // Inicializar el efecto en 0 (color)
        material.SetFloat(GrayscaleAmountPropertyName, 0f);
    }

    public void StartGrayscaleTransition()
    {
        // Detiene cualquier corrutina de transición anterior y comienza una nueva
        StopAllCoroutines();
        StartCoroutine(FadeToGrayscale());
    }

    private IEnumerator FadeToGrayscale()
    {
        float startValue = material.GetFloat(GrayscaleAmountPropertyName);
        float targetValue = 1f; // Objetivo: gris total
        float time = 0f;

        while (time < transitionDuration)
        {
            // Calcula el progreso y usa Lerp para suavizar la transición
            float t = time / transitionDuration;
            float newValue = Mathf.Lerp(startValue, targetValue, t);

            material.SetFloat(GrayscaleAmountPropertyName, newValue);

            time += Time.deltaTime;
            yield return null;
        }

        // Asegurar que el valor final sea 1.0 al terminar.
        material.SetFloat(GrayscaleAmountPropertyName, targetValue);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // Aplica el material de post-proceso
        if (material != null)
        {
            Graphics.Blit(source, destination, material);
        }
        else
        {
            // Si el material no está listo, solo copia la imagen
            Graphics.Blit(source, destination);
        }
    }
}