clc;
close all;
clear;

% Selección manual de la imagen
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, 'Selecciona una imagen');
if isequal(filename, 0)
    disp('No seleccionaste ninguna imagen');
else
    % Cargar la imagen
    imagen = imread(fullfile(pathname, filename));

    % Convertir la imagen a escala de grises si es necesario
    if size(imagen, 3) == 3
        imagen_gris = rgb2gray(imagen);
    else
        imagen_gris = imagen;
    end

    % Obtener el histograma de la imagen original
    [counts, bins] = imhist(imagen_gris);
    L = 256; % Niveles de intensidad

    % Calcular la función de transformación de niveles de gris (CDF acumulativa)
    cdf = cumsum(counts) / numel(imagen_gris);
    
    % Crear la función de transformación (mapeo)
    T = uint8((L - 1) * cdf);  % Escalar al rango [0, 255]

    % Aplicar la transformación a la imagen
    imagen_transformada = T(double(imagen_gris) + 1);  % Mapeo con la función de transformación

    % Mostrar la comparación entre la imagen original y la transformada
    figure;
    subplot(1, 2, 1);
    imshow(imagen_gris);
    title('Imagen Original');

    subplot(1, 2, 2);
    imshow(imagen_transformada);
    title('Imagen con Histograma Uniformizado');

    % Mostrar los histogramas
    figure;
    subplot(2, 1, 1);
    imhist(imagen_gris);
    title('Histograma de la Imagen Original');

    subplot(2, 1, 2);
    imhist(imagen_transformada);
    title('Histograma de la Imagen Uniformizada');
end
