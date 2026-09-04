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
    
    % Mostrar la imagen
    figure;
    imshow(imagen_gris, []);
    title('Imagen en Escala de Grises');
    
    % Tamaño de la imagen
    [filas, columnas] = size(imagen_gris);
    num_pixeles = filas * columnas;
    
    % Inicializar la tabla de frecuencias (256 niveles de gris para imágenes de 8 bits)
    frecuencias = zeros(256, 1);
    
    % Contar la frecuencia de cada nivel de gris
    for i = 1:filas
        for j = 1:columnas
            valor_pixel = imagen_gris(i, j);
            frecuencias(valor_pixel + 1) = frecuencias(valor_pixel + 1) + 1;
        end
    end
    
    % Calcular la función de distribución de probabilidad (PDF)
    pdf = frecuencias / num_pixeles;
    
    % Mostrar la frecuencia de cada nivel de gris
    disp('Frecuencia de niveles de gris:');
    for nivel = 0:255
        if frecuencias(nivel + 1) > 0
            fprintf('Nivel %d: Frecuencia = %d, PDF = %.4f\n', nivel, frecuencias(nivel + 1), pdf(nivel + 1));
        end
    end
    
    % Mostrar el histograma de frecuencias y la PDF
    figure;
    subplot(2, 1, 1);
    bar(0:255, frecuencias);
    title('Frecuencia de Niveles de Gris');
    xlabel('Niveles de Gris');
    ylabel('Frecuencia');
    xlim([0 255]);
    
    subplot(2, 1, 2);
    bar(0:255, pdf);
    title('Función de Distribución de Probabilidad (PDF)');
    xlabel('Niveles de Gris');
    ylabel('Probabilidad');
    xlim([0 255]);
end
