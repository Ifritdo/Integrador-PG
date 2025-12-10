using System.Collections;
using UnityEngine;

public class CameraShake : MonoBehaviour
{
    // Función pública que llamaremos desde el evento
    public void Shake(float duration, float magnitude)
    {
        StartCoroutine(ShakeRoutine(duration, magnitude));
    }

    public void ShakeOnHit()
    {
        // Define los valores de temblor para el golpe
        float defaultDuration = 0.2f;
        float defaultMagnitude = 0.1f;

        StartCoroutine(ShakeRoutine(defaultDuration, defaultMagnitude));
    }
    private IEnumerator ShakeRoutine(float duration, float magnitude)
    {
        Vector3 originalPos = transform.localPosition;
        float elapsed = 0f;

        while (elapsed < duration)
        {
            // Genera una posición aleatoria dentro de la magnitud
            float x = Random.Range(-1f, 1f) * magnitude;
            float y = Random.Range(-1f, 1f) * magnitude;

            transform.localPosition = originalPos + new Vector3(x, y, 0f);

            elapsed += Time.deltaTime;
            yield return null; // Espera al siguiente frame
        }

        transform.localPosition = originalPos; // Vuelve a la posición original
    }
}