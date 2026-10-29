# 🎹🎧🎼Análisis_spotify🎹🎧🎼
##  Popularidad y análisis en spotify
Se toman datos de la pagina 🌐https://www.kaggle.com/learn 🌐, analizando las siguientes preguntas realizando las consultas en SQL:
### 1. ¿Cuáles son las 10 canciones más populares y quiénes son sus artistas? 
```
SELECT 
    track_name,
    artist_name,
    track_popularity
FROM DataSpotify
ORDER BY track_popularity DESC
LIMIT 10; 
```
<img width="573" height="399" alt="image" src="https://github.com/user-attachments/assets/6703cfed-6dc9-4c71-8d87-880855387301" />

### 2. ¿Cuál es el promedio de duración (track_duration_min) de las canciones según el tipo de lanzamiento (album_type: single vs. album)?
```
SELECT 
    album_type,
    ROUND(AVG(track_duration_m), 2) AS promedio_duracion
FROM DataSpotify
GROUP BY album_type
ORDER BY promedio_duracion DESC;
```
<img width="550" height="178" alt="image" src="https://github.com/user-attachments/assets/cc05dae3-8a6f-4aef-8cd7-674e6fd1fc00" />

### 3. ¿Cuántas canciones tienen contenido explícito (explicit = TRUE) frente a las que son para todo público (FALSE)? */
```
SELECT 
    explicit, 
    COUNT(*) AS total_canciones
FROM DataSpotify 
GROUP BY explicit;
```
<img width="461" height="119" alt="image" src="https://github.com/user-attachments/assets/e7be7d1e-9fe1-4bf0-adf3-1fa8466bed86" />

### 4. ¿Quiénes son los 5 artistas con mayor número de seguidores en este dataset?
```
SELECT 
    artist_name,
    MAX(artist_followers) AS total_seguidores
FROM DataSpotify
GROUP BY artist_name
ORDER BY total_seguidores DESC
LIMIT 5;
```
<img width="457" height="205" alt="image" src="https://github.com/user-attachments/assets/d48b4ee3-5c92-4b7c-a221-f50196f33145" />

### 5. ¿Cuál es la popularidad promedio de las canciones por cada género musical (artist_genres)? (Aquí se puede filtrar solo géneros con más de X canciones para evitar sesgos)
```
SELECT 
    artist_genres,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio,
    COUNT(*) AS total_canciones
FROM DataSpotify
WHERE artist_genres != 'N/A'
GROUP BY artist_genres
ORDER BY popularidad_promedio DESC;
```
<img width="607" height="391" alt="image" src="https://github.com/user-attachments/assets/1da7f7d4-ea61-4818-9fe7-df3efe87a56b" />
