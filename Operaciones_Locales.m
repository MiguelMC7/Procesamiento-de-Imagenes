clc;
close all;
clear;

% Cargar la imagen
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, 'Selecciona una imagen');
if isequal(filename, 0)
    disp('No seleccionaste ninguna imagen');
else
    % Leer la imagen
    imagen = imread(fullfile(pathname, filename));
    
    % Convertir la imagen a escala de grises si es necesario
    if size(imagen, 3) == 3
        imagen_gris = rgb2gray(imagen);
    else
        imagen_gris = imagen;
    end
    
    % Mostrar la imagen original
    figure;
    imshow(imagen_gris, []);
    title('Imagen Original');

    % Definir el tamaño del filtro de suavizado (por ejemplo, 5x5)
    tamanio_filtro = 5;
    
    % Crear un filtro de suavizado (promedio) de tamaño tamanio_filtro x tamanio_filtro
    filtro = fspecial('average', tamanio_filtro);

    % Aplicar la convolución con el filtro
    imagen_suavizada = imfilter(imagen_gris, filtro, 'replicate');

    % Mostrar la imagen suavizada
    figure;
    imshow(imagen_suavizada, []);
    title('Imagen Suavizada');

    % Mostrar el filtro utilizado
    figure;
    surf(filtro);
    title('Filtro de Suavizado');
    xlabel('Columna');
    ylabel('Fila');
    zlabel('Valor');
end
