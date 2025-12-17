using System.Collections;
using UnityEngine;

public class HitReaction : MonoBehaviour
{
    private Renderer myRenderer;
    private Material myMaterial;

    // El mismo nombre exacto que pusiste en la propiedad del Shader en Amplify
    private string hitProperty = "_HitAmount";

    [Header("Configuración")]
    [SerializeField] private float flashDuration = 0.1f; // Qué tan rápido es el parpadeo
    [SerializeField] private int numberOfFlashes = 2; // Cuántas veces parpadea

    void Start()
    {
        myRenderer = GetComponentInChildren<Renderer>(); // Busca el renderer en este objeto o hijos
        if (myRenderer != null)
        {
            // Usamos material para crear una instancia y no afectar a todos los prefabs iguales
            myMaterial = myRenderer.material;
        }
    }

    // ESTA es la función que conectarás en el UnityEvent del Fighter.cs
    public void TomarDaño()
    {
        if (myMaterial != null)
        {
            StopAllCoroutines(); // Reinicia si ya estaba parpadeando
            StartCoroutine(FlashRoutine());
        }
    }

    private IEnumerator FlashRoutine()
    {
        for (int i = 0; i < numberOfFlashes; i++)
        {
            // Poner rojo (Valor 1)
            myMaterial.SetFloat(hitProperty, 1f);
            yield return new WaitForSeconds(flashDuration);

            // Volver a normal (Valor 0)
            myMaterial.SetFloat(hitProperty, 0f);
            yield return new WaitForSeconds(flashDuration);
        }
    }
}