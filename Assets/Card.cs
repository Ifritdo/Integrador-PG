using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Card : MonoBehaviour
{

    [SerializeField] private Material frame_mat;
    [SerializeField] private Material back_mat;
    [SerializeField] private Material character_mat;
    private SpriteRenderer spriteRenderer;
    private Color colorOriginal;
    [SerializeField] private float duraciondescarte = 5f;

    private void OnMouseDown(){ CardManager.Instance.SeleccionarCarta(this); Debug.Log("Carta Seleccionada");}

    public void AlSerSeleccionada(){ frame_mat.SetFloat("_Hover",1f);}

    public void AlSerDeseleccionada(){ frame_mat.SetFloat("_Hover",0f);}

    public void Evolucionar(){ StartCoroutine(Evolucion(duraciondescarte));}

    public void SeleccionarDesdeUI()
    {
        CardManager.Instance.SeleccionarCarta(this);
        Debug.Log("Carta seleccionada desde el Botón");
    }

    public void Descartar()
    {
        StartCoroutine(Descarte(duraciondescarte));
        Destroy(gameObject);
    }

    IEnumerator Descarte(float tiempoTotal)
    {
        float tiempoTranscurrido = 0f;
        while (back_mat.GetFloat("_Umbral") > 0)
        {
            tiempoTranscurrido += Time.deltaTime;
            float t = tiempoTranscurrido / tiempoTotal;
            back_mat.SetFloat("_Umbral",Mathf.Lerp(1f, 0f, t));
            frame_mat.SetFloat("_Umbral",Mathf.Lerp(1f, 0f, t));
            character_mat.SetFloat("_Umbral",Mathf.Lerp(1f, 0f, t));
            yield return null;
        }
    }

    IEnumerator Evolucion(float tiempoTotal)
    {
        float tiempoTranscurrido = 0f;
        while (back_mat.GetFloat("_Evo") < 1)
        {
            tiempoTranscurrido += Time.deltaTime;
            float t = tiempoTranscurrido / tiempoTotal;
            back_mat.SetFloat("_Evo",Mathf.Lerp(0f, 1f, t));
            frame_mat.SetFloat("_Evo",Mathf.Lerp(0f, 1f, t));
            character_mat.SetFloat("_Evo",Mathf.Lerp(0f, 1f, t));
            yield return null;
        }
    }
}

