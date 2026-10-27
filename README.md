### 🎹🎧🎼Análisis_spotify🎹🎧🎼
###  Popularidad y análisis en spotify
Se toman datos de la pagina 🌐https://www.kaggle.com/learn 🌐, analizando las siguientes preguntas realizando las consultas en SQL:
*¿Cuáles son las 10 canciones más populares y quiénes son sus artistas? 

SELECT 
    track_name,
    artist_name,
    track_popularity
FROM DataSpotify
ORDER BY track_popularity DESC
LIMIT 10; 
