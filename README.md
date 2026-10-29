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

### 6. ¿Cuál es la duración promedio (track_duration_m) de las canciones según el tipo de álbum (album_type)?*/ 
```
SELECT album_type, ROUND(AVG(track_duration_m), 2) AS promedio_minutos
FROM DataSpotify
GROUP BY album_type
ORDER BY promedio_minutos DESC;
```
<img width="470" height="145" alt="image" src="https://github.com/user-attachments/assets/2e552098-c573-4b40-90fa-34954583a0ba" />

### 7. ¿Existe una correlación visible entre la popularidad del artista (artist_popularity) y la popularidad de sus canciones (track_popularity)?
```
SELECT 
   artist_name,
   artist_popularit,
   ROUND(AVG(track_popularity), 2) AS promedio_canciones
FROM DataSpotify
GROUP BY artist_name, artist_popularit
ORDER BY artist_popularit DESC
LIMIT 15;
```
<img width="612" height="420" alt="image" src="https://github.com/user-attachments/assets/eae88ce6-1446-4d95-878d-ab102b2f37b7" />

#### Interpretación de los datos:
Al comparar las dos métricas numéricas observamos:  
* Taylor Swift: Popularidad de artista = 100, promedio de canciones = 60.05.   
* Bad Bunny: Popularidad de artista = 95, promedio de canciones = 73.34.  
* Drake: Popularidad de artista = 95, promedio de canciones = 65.89.

### Conclusión analítica:
Sí existe una relación positiva visible: Los artistas con popularidad muy alta ($\ge 95$) mantienen promedios de canciones elevados ($\ge 60$) en comparación con el resto del catálogo general.   El promedio de canciones siempre es menor que el pico del artista: Esto ocurre porque artistas consolidados como Taylor Swift o Drake tienen discografías muy extensas; aunque sus sencillos principales alcancen puntuaciones cercanas a 90 o 100, sus temas de relleno o pistas secundarias promedian entre 40 y 60 puntos, moderando la media general. 

