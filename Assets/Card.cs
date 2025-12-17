using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Card : MonoBehaviour
{
    [Header("Objetos Hijos (Arrastrar desde la Jerarquía)")]
    [SerializeField] private GameObject objMarco;
    [SerializeField] private GameObject objFondo;
    [SerializeField] private GameObject objPersonaje;

    [Header("Configuración")]
    [SerializeField] private float duraciondescarte = 5f;

    private Material frame_mat;
    private Material back_mat;
    private Material character_mat;

    private void Start()
    {
        if (objMarco != null) frame_mat = objMarco.GetComponent<Renderer>().material;
        if (objFondo != null) back_mat = objFondo.GetComponent<Renderer>().material;
        if (objPersonaje != null) character_mat = objPersonaje.GetComponent<Renderer>().material;

        if (back_mat != null) back_mat.SetFloat("_Evo", 0f);
        if (back_mat != null) back_mat.SetFloat("_Umbral", 1f);
    }

    public void SeleccionarDesdeUI()
    {
        if (CardManager.Instance != null)
            CardManager.Instance.SeleccionarCarta(this);
    }

    private void OnMouseDown() { SeleccionarDesdeUI(); }

    public void AlSerSeleccionada() { if (frame_mat) frame_mat.SetFloat("_Hover", 1f); }
    public void AlSerDeseleccionada() { if (frame_mat) frame_mat.SetFloat("_Hover", 0f); }

    public void Evolucionar()
    {
        StartCoroutine(Evolucion(duraciondescarte));
    }

    IEnumerator Evolucion(float tiempoTotal)
    {
        float tiempoTranscurrido = 0f;
        while (tiempoTranscurrido < tiempoTotal)
        {
            tiempoTranscurrido += Time.deltaTime;
            float t = tiempoTranscurrido / tiempoTotal;
            if (back_mat) back_mat.SetFloat("_Evo", t);
            if (frame_mat) frame_mat.SetFloat("_Evo", t);
            if (character_mat) character_mat.SetFloat("_Evo", t);
            yield return null;
        }
        if (back_mat) back_mat.SetFloat("_Evo", 1f);
    }

    public void Descartar()
    {
        StartCoroutine(Descarte(duraciondescarte));
    }

    IEnumerator Descarte(float tiempoTotal)
    {
        float tiempoTranscurrido = 0f;
        while (tiempoTranscurrido < tiempoTotal)
        {
            tiempoTranscurrido += Time.deltaTime;
            float t = tiempoTranscurrido / tiempoTotal;
            float valorUmbral = Mathf.Lerp(1f, 0f, t);

            if (back_mat) back_mat.SetFloat("_Umbral", valorUmbral);
            if (frame_mat) frame_mat.SetFloat("_Umbral", valorUmbral);
            if (character_mat) character_mat.SetFloat("_Umbral", valorUmbral);

            yield return null;
        }
        Destroy(gameObject);
    }
}