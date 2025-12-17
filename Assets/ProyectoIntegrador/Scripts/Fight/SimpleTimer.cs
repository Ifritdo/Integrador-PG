using UnityEngine;
using TMPro;

public class SimpleTimer : MonoBehaviour
{
    [Header("Componentes")]
    [Tooltip("Arrastra aquí tu componente TextMeshProUGUI.")]
    public TextMeshProUGUI timerText;

    [Header("Configuración")]
    [Tooltip("Tiempo inicial de la cuenta regresiva en segundos.")]
    public float initialTime = 70f;

    private float timeRemaining;

    private bool isTimerActive = true;

    void Start()
    {
        timeRemaining = initialTime;
        isTimerActive = true;

        DisplayTime(timeRemaining);
    }

    void Update()
    {
        if (isTimerActive)
        {
            if (timeRemaining > 0)
            {
                timeRemaining -= Time.deltaTime;

                if (timeRemaining < 0)
                {
                    timeRemaining = 0;
                }

                DisplayTime(timeRemaining);
            }
            else
            {
                isTimerActive = false;
                OnTimerFinished();
            }
        }
    }

    void DisplayTime(float timeToDisplay)
    {
        int secondsOnly = Mathf.FloorToInt(timeToDisplay);

        timerText.text = string.Format("{0:00}", secondsOnly);
    }

    void OnTimerFinished()
    {
        Debug.Log("¡Cuenta regresiva terminada!");
    }
}