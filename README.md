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

###¿Cuál es el promedio de duración (track_duration_min) de las canciones según el tipo de lanzamiento (album_type: single vs. album)?
```
SELECT 
    album_type,
    ROUND(AVG(track_duration_m), 2) AS promedio_duracion
FROM DataSpotify
GROUP BY album_type
ORDER BY promedio_duracion DESC;
```
<img width="550" height="178" alt="image" src="https://github.com/user-attachments/assets/cc05dae3-8a6f-4aef-8cd7-674e6fd1fc00" />
