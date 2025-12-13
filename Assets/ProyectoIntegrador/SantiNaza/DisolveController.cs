using UnityEngine;
using System.Collections;

public class DissolveController : MonoBehaviour
{
    [Header("Configuración del Shader")]
    [Tooltip("El Material que contiene el shader de disolución.")]
    public Material dissolveMaterial;

    // Cambia esto si tu propiedad se llama diferente (ej. "_DissolveAmount")
    private const string DissolveAmountProp = "_Disolucion";

    [Header("Configuración de la Animación")]
    [Tooltip("Tiempo en segundos que tarda la disolución en completarse.")]
    public float dissolveDuration = 2.0f;

    // NUEVA PROPIEDAD: Tiempo de espera antes de que inicie la disolución
    [Header("Temporizador")]
    [Tooltip("Tiempo en segundos de espera antes de que inicie el efecto de disolución.")]
    public float delayBeforeDissolve = 15.0f;

    // Referencia al Renderer del objeto
    private Renderer objRenderer;

    void Awake()
    {
        objRenderer = GetComponent<Renderer>();
        if (dissolveMaterial == null && objRenderer != null)
        {
            dissolveMaterial = objRenderer.material;
        }

        if (dissolveMaterial == null)
        {
            Debug.LogError("ERROR: No se encontró el Material de Disolución.");
            enabled = false;
        }

        // **NUEVO:** Inicializa el valor en 1.0 (totalmente disuelto) para que el objeto no se vea al inicio.
        if (dissolveMaterial != null)
        {
            dissolveMaterial.SetFloat(DissolveAmountProp, 1.0f);
        }
    }

    void Start()
    {
        // 1. Espera el tiempo definido (ej. 15 segundos).
        // 2. Llama a la corrutina para iniciar la solidificación (Disolve de 1.0 a 0.0).

        if (enabled)
        {
            StartCoroutine(StartDissolveAfterDelay());
        }
    }

    // Corrutina que espera el tiempo definido y luego inicia la transición
    IEnumerator StartDissolveAfterDelay()
    {
        // El objeto está invisible (D-Amount = 1.0)
        yield return new WaitForSeconds(delayBeforeDissolve);

        // Inicia el proceso de solidificación/reaparición
        StartCoroutine(DissolveTransition(1.0f, 0.0f));
    }

    // Corrutina de transición (de 1.0 a 0.0)
    IEnumerator DissolveTransition(float startValue, float endValue)
    {
        float elapsedTime = 0f;

        while (elapsedTime < dissolveDuration)
        {
            float currentValue = Mathf.Lerp(startValue, endValue, elapsedTime / dissolveDuration);
            dissolveMaterial.SetFloat(DissolveAmountProp, currentValue);

            elapsedTime += Time.deltaTime;
            yield return null;
        }

        // Asegura que el valor final sea exactamente 0.0 (totalmente sólido)
        dissolveMaterial.SetFloat(DissolveAmountProp, endValue);
    }
}