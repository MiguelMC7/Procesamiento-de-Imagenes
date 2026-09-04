clc
close all
clear

% Selección manual de la imagen
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, 'Selecciona una imagen');
if isequal(filename, 0)
    disp('No seleccionaste ninguna imagen');
else
    % Cargar la imagen
    imagen = imread(fullfile(pathname, filename));

    % Convertir la imagen a escala de grises (si no lo está)
    if size(imagen, 3) == 3
        imagen_gris = rgb2gray(imagen);
    else
        imagen_gris = imagen;
    end

    % Aplicar la ecualización de histograma
    imagen_ecualizada = histeq(imagen_gris);

    % Mostrar la comparación entre la imagen original y la ecualizada
    figure;
    subplot(1, 2, 1); % Espacio para la imagen original
    imshow(imagen_gris);
    title('Imagen Original con Bajo Contraste');

    subplot(1, 2, 2); % Espacio para la imagen ecualizada
    imshow(imagen_ecualizada);
    title('Imagen Ecualizada (Histograma)');
    
    % Mostrar los histogramas
    figure;
    subplot(1, 2, 1);
    imhist(imagen_gris);
    title('Histograma de la Imagen Original');
    
    subplot(1, 2, 2);
    imhist(imagen_ecualizada);
    title('Histograma de la Imagen Ecualizada');
end
