using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardManager : MonoBehaviour
{

    public static CardManager Instance;
    private Card cartaSeleccionadaActual;

    private void Awake()
    {
        if (Instance == null)
            Instance = this;
        else
            Destroy(gameObject);
    }

    public void SeleccionarCarta(Card nuevaCarta)
    {
        if (cartaSeleccionadaActual != null){ cartaSeleccionadaActual.AlSerDeseleccionada();}
        cartaSeleccionadaActual = nuevaCarta;
        if (cartaSeleccionadaActual != null){ cartaSeleccionadaActual.AlSerSeleccionada();}
    }

    public void BotonEvolvePresionado()
    {
        if (cartaSeleccionadaActual != null){ cartaSeleccionadaActual.Evolucionar();}
        else{ Debug.LogWarning("No hay ninguna carta seleccionada para evolucionar.");}
    }

    public void BotonDiscardPresionado()
    {
        if (cartaSeleccionadaActual != null)
        {
            cartaSeleccionadaActual.Descartar();
            cartaSeleccionadaActual = null; 
        }
        else{ Debug.LogWarning("No hay ninguna carta seleccionada para descartar.");}
    }
}

