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
<img width="589" height="378" alt="image" src="https://github.com/user-attachments/assets/25205ca3-a5f9-4f9f-acdc-3102f4e16d0d" />

### 2. ¿Cuál es el promedio de duración de las canciones según el tipo de lanzamiento (album_type)?
```SQL
SELECT 
    album_type,
    ROUND(AVG(track_duration_m), 2) AS promedio_duracion_min
FROM DataSpotify
GROUP BY album_type
ORDER BY promedio_duracion_min DESC;
```

<img width="514" height="135" alt="image" src="https://github.com/user-attachments/assets/f0cd178d-e2f9-4efa-b66d-740d1664c66b" />

### 3. ¿Cuántas canciones tienen contenido explícito frente a las aptas para todo público?
 
```SQL
SELECT 
    explicit, 
    COUNT(*) AS total_canciones
FROM DataSpotify 
GROUP BY explicit;
```

### 4. ¿Quiénes son los 5 artistas con mayor número de seguidores?
   
```SQL
   SELECT 
    artist_name,
    MAX(artist_followers) AS total_seguidores
FROM DataSpotify
GROUP BY artist_name
ORDER BY total_seguidores DESC
LIMIT 5;
```

<img width="472" height="223" alt="image" src="https://github.com/user-attachments/assets/e0722746-69af-4c95-9552-9cf7f2a2756a" />


### 5. ¿Cuál es la popularidad promedio de las canciones por género musical (artist_genres)?

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

<img width="570" height="412" alt="image" src="https://github.com/user-attachments/assets/dceb1d9a-fe0d-4bef-895d-0b0ac0dafff3" />

### 6. ¿Existe una correlación visible entre la popularidad del artista y la de sus temas?

```SQL
SELECT 
    artist_name,
    artist_popularit,
    ROUND(AVG(track_popularity), 2) AS promedio_canciones
FROM DataSpotify
GROUP BY artist_name, artist_popularit
ORDER BY artist_popularit DESC
LIMIT 15;
```

<img width="603" height="409" alt="image" src="https://github.com/user-attachments/assets/166c7c49-ac5a-4a3b-a9c1-426d2ebe44a2" />

Interpretación de hallazgos:Relación positiva evidente: Artistas situados en niveles máximos de popularidad ($\ge 95$) conservan promedios elevados en sus temas ($\ge 60$) en contraste con el catálogo general.Efecto catálogo extenso: El promedio individual de las canciones suele ser menor al índice de popularidad del artista; discografías amplias incluyen temas secundarios que moderan la media respecto a sus grandes éxitos.

### 7. Canción más popular de cada artista (ROW_NUMBER:

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
<img width="570" height="417" alt="image" src="https://github.com/user-attachments/assets/0c590c7b-8f96-4bc7-b227-9503169e6c51" />

### 8. Distribución y desempeño según la duración del tema:

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
<img width="609" height="148" alt="image" src="https://github.com/user-attachments/assets/ac106138-9aeb-45cb-a0c0-3aa998e24f40" />

Conclusiones del análisis:Volumen del catálogo: Predominan las producciones de media y larga duración (más de 7,400 canciones combinadas), frente a solo 1,171 temas cortos.Impacto en popularidad: Las canciones cortas registran la menor aceptación relativa (42.14 puntos), mientras que los formatos largos (> 3.5 min) lideran con 54.86 puntos, superando la media en más de 12 puntos.


