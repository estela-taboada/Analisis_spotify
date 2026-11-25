-- Top 10 temas con mayor tracción en la plataforma
SELECT 
    track_name,
    artist_name,
    track_popularity
FROM DataSpotify
ORDER BY track_popularity DESC
LIMIT 10;

-- Duración promedio según el formato de publicación
SELECT 
    album_type,
    ROUND(AVG(track_duration_m), 2) AS promedio_duracion_min,
    COUNT(*) AS volumen_lanzamientos
FROM DataSpotify
GROUP BY album_type
ORDER BY promedio_duracion_min DESC;

-- Segmentación de catálogo por tipo de contenido
SELECT 
    CASE 
        WHEN explicit = 1 THEN 'Contenido Explícito'
        ELSE 'Apto para Todo Público'
    END AS tipo_clasificacion,
    COUNT(*) AS total_canciones,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM DataSpotify), 2) AS porcentaje_catalogo
FROM DataSpotify 
GROUP BY explicit;

-- Top 5 artistas por volumen de seguidores acumulados
SELECT 
    artist_name,
    MAX(artist_followers) AS total_seguidores
FROM DataSpotify
GROUP BY artist_name
ORDER BY total_seguidores DESC
LIMIT 5;

-- Géneros con mayor tracción promedio y masa crítica (>10 temas)
SELECT 
    artist_genres,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio,
    COUNT(*) AS volumen_pistas
FROM DataSpotify
WHERE artist_genres != 'N/A' AND artist_genres IS NOT NULL
GROUP BY artist_genres
HAVING COUNT(*) >= 10
ORDER BY popularidad_promedio DESC
LIMIT 15;

-- Comparativa entre la popularidad de marca del artista y el promedio de sus canciones
SELECT 
    artist_name,
    artist_popularit AS indice_popularidad_artista,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio_canciones,
    COUNT(*) AS total_canciones_analizadas
FROM DataSpotify
GROUP BY artist_name, artist_popularit
ORDER BY artist_popularit DESC
LIMIT 15;

-- Canción líder por artista usando Window Functions
WITH CancionesRankeadas AS (
    SELECT 
        artist_name,
        track_name,
        track_popularity,
        ROW_NUMBER() OVER(
            PARTITION BY artist_name 
            ORDER BY track_popularity DESC
        ) AS ranking_artista
    FROM DataSpotify
)
SELECT 
    artist_name,
    track_name AS lead_single,
    track_popularity
FROM CancionesRankeadas
WHERE ranking_artista = 1
ORDER BY track_popularity DESC;

-- Desempeño comercial según rangos de duración
SELECT 
    CASE 
        WHEN track_duration_m < 2.5 THEN 'Corta (< 2.5 min)'
        WHEN track_duration_m BETWEEN 2.5 AND 3.5 THEN 'Media (2.5 - 3.5 min)'
        ELSE 'Larga (> 3.5 min)'
    END AS rango_duracion,
    COUNT(*) AS volumen_canciones,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio
FROM DataSpotify
GROUP BY rango_duracion
ORDER BY popularidad_promedio DESC;
