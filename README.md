# 📊 Análisis Exploratorio de Datos en Spotify con SQL

Proyecto de análisis de datos centrado en métricas de popularidad, duración, impacto de contenido explícito y correlación entre artistas y temas en la plataforma Spotify.

* **Fuente de datos:** Kaggle Datasets (`DataSpotify`)
* **Herramientas:** SQL / SQLite

---

## Preguntas de Negocio y Consultas SQL

### 1. ¿Cuáles son las 10 canciones más populares y quiénes son sus artistas?
```SQL
SELECT 
    track_name,
    artist_name,
    track_popularity
FROM DataSpotify
ORDER BY track_popularity DESC
LIMIT 10;
```

2. ¿Cuál es el promedio de duración de las canciones según el tipo de lanzamiento (album_type)?
```SQL
   SQLSELECT 
    album_type,
    ROUND(AVG(track_duration_m), 2) AS promedio_duracion_min
FROM DataSpotify
GROUP BY album_type
ORDER BY promedio_duracion_min DESC;
```
3. ¿Cuántas canciones tienen contenido explícito frente a las aptas para todo público?
 
```SQL
SELECT 
    explicit, 
    COUNT(*) AS total_canciones
FROM DataSpotify 
GROUP BY explicit;
```

4. ¿Quiénes son los 5 artistas con mayor número de seguidores?
   
   ```SQL
   SELECT 
    artist_name,
    MAX(artist_followers) AS total_seguidores
FROM DataSpotify
GROUP BY artist_name
ORDER BY total_seguidores DESC
LIMIT 5;
```
5. ¿Cuál es la popularidad promedio de las canciones por género musical (artist_genres)?

```SQL
SELECT 
    artist_genres,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio,
    COUNT(*) AS total_canciones
FROM DataSpotify
WHERE artist_genres != 'N/A'
GROUP BY artist_genres
ORDER BY popularidad_promedio DESC;
```
6. ¿Existe una correlación visible entre la popularidad del artista y la de sus temas?
    ```SQL SELECT 
    artist_name,
    artist_popularit,
    ROUND(AVG(track_popularity), 2) AS promedio_canciones
FROM DataSpotify
GROUP BY artist_name, artist_popularit
ORDER BY artist_popularit DESC
LIMIT 15;
```
Interpretación de hallazgos:Relación positiva evidente: Artistas situados en niveles máximos de popularidad ($\ge 95$) conservan promedios elevados en sus temas ($\ge 60$) en contraste con el catálogo general.Efecto catálogo extenso: El promedio individual de las canciones suele ser menor al índice de popularidad del artista; discografías amplias incluyen temas secundarios que moderan la media respecto a sus grandes éxitos.

7. Canción más popular de cada artista (ROW_NUMBER:
```SQL
WITHcanciones_rankeadas AS (
    SELECT 
        artist_name,
        track_name,
        track_popularity,
        ROW_NUMBER() OVER(
            PARTITION BY artist_name 
            ORDER BY track_popularity DESC
        ) AS ranking
    FROM DataSpotify
)
SELECT 
    artist_name,
    track_name,
    track_popularity
FROM canciones_rankeadas
WHERE ranking = 1
ORDER BY track_popularity DESC;
```

8. Distribución y desempeño según la duración del tema:
   ```SQL
   SELECT 
    CASE 
        WHEN track_duration_m < 2.5 THEN 'Corta (< 2.5 min)'
        WHEN track_duration_m BETWEEN 2.5 AND 3.5 THEN 'Media (2.5 - 3.5 min)'
        ELSE 'Larga (> 3.5 min)'
    END AS rango_duracion,
    COUNT(*) AS total_canciones,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio
FROM DataSpotify
GROUP BY rango_duracion
ORDER BY popularidad_promedio DESC;
```

Conclusiones del análisis:Volumen del catálogo: Predominan las producciones de media y larga duración (más de 7,400 canciones combinadas), frente a solo 1,171 temas cortos.Impacto en popularidad: Las canciones cortas registran la menor aceptación relativa (42.14 puntos), mientras que los formatos largos (> 3.5 min) lideran con 54.86 puntos, superando la media en más de 12 puntos.


