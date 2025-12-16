using System.Collections;
using UnityEngine;
using UnityEngine.UI; // Necesario si usas Image o RawImage para obtener el material

public class HealthBarManager : MonoBehaviour
{
    [Header("Referencias")]
    [SerializeField] private Material healthBarMaterial; // Arrastra el material de tu UI

    [Header("Configuración de Salud")]
    // Cuánto se resta por defecto en cada golpe (ej. 0.2 = 20% de vida)
    [SerializeField] private float damageAmount = 0.2f;

    [Header("Efecto de Daño (Trailing)")]
    // Duración de la animación de la franja de daño (0.75s es un buen punto de partida cinemático)
    [SerializeField] private float trailingDuration = 0.75f;

    // Propiedades exactas del Shader de Amplify
    private const string HealthRatioProperty = "_HealthRatio";
    private const string TrailingHealthProperty = "_TrailingHealth";

    // Variables de estado
    private float currentHealthRatio = 1.0f;
    private Coroutine trailingCoroutine;

    void Start()
    {
        // Inicializa la barra en 100% al inicio de la escena
        if (healthBarMaterial != null)
        {
            healthBarMaterial.SetFloat(HealthRatioProperty, 1.0f);
            healthBarMaterial.SetFloat(TrailingHealthProperty, 1.0f);
        }
    }

    // ESTA es la función que conectarás al UnityEvent en Fighter.cs
    public void ReceiveHit()
    {
        // 1. Calcular nueva vida
        float oldHealthRatio = currentHealthRatio;
        currentHealthRatio = Mathf.Max(0f, currentHealthRatio - damageAmount);

        // 2. Aplicar la vida actual al Shader (El recorte instantáneo)
        healthBarMaterial.SetFloat(HealthRatioProperty, currentHealthRatio);

        // 3. Iniciar el efecto Trailing Damage
        // Usamos el valor antiguo para empezar la franja de daño.
        if (trailingCoroutine != null)
        {
            StopCoroutine(trailingCoroutine);
        }
        trailingCoroutine = StartCoroutine(AnimateTrailingHealth(oldHealthRatio, currentHealthRatio));
    }

    private IEnumerator AnimateTrailingHealth(float startValue, float endValue)
    {
        // Establece el valor inicial del Trailing (donde estaba la vida antes)
        healthBarMaterial.SetFloat(TrailingHealthProperty, startValue);

        float timeElapsed = 0;

        while (timeElapsed < trailingDuration)
        {
            timeElapsed += Time.deltaTime;
            // Usamos un factor de interpolación suave (SmoothStep) para un movimiento cinemático
            float t = timeElapsed / trailingDuration;

            float animatedValue = Mathf.Lerp(startValue, endValue, t);

            healthBarMaterial.SetFloat(TrailingHealthProperty, animatedValue);
            yield return null;
        }

        // Asegurar que el valor final de Trailing sea igual a HealthRatio
        healthBarMaterial.SetFloat(TrailingHealthProperty, endValue);
    }
}