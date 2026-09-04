clc
close all
clear

im = imread("cafe2.jpg");

scale_factor = 0.3; % Cambia el factor de escala según lo desees (0.5 reduce al 50%)
im_resized = imresize(im, scale_factor);

% Step 1: Convertir la imagen a escala de grises
im_gray = rgb2gray(im_resized);

% Step 2: Aplicar un umbral para crear una máscara binaria y quitar el fondo
threshold = graythresh(im_gray);
imbw = imbinarize(im_gray, threshold);

se = strel('disk', 1);
imbw = imopen(imbw, se); % Eliminar ruido pequeño
imbw = imclose(imbw, se); % Rellenar huecos pequeños
foreground = im_resized .* uint8(repmat(imbw, [1, 1, 3])); 

% Step 3: Convertir la imagen sin fondo a escala de grises
im_gray_foreground = rgb2gray(foreground);

% Step 4: Aplicar filtros a la imagen sin fondo
im_smooth = imgaussfilt(im_gray_foreground, 6);
im_inv = imcomplement(im_smooth);
imbw = im2bw(im_inv, 0.9);
imbw = bwareaopen(imbw, 400);
imbw = imclose(imbw, se);

estadistica = regionprops(imbw, 'all');
centroids = cat(1, estadistica.Centroid);
cantidad = length(estadistica);

perimetroMayor = 0; % Comienza con un valor 0
posicionMayor = 0; % Inicializa la posición
perimetroMenor = inf;
posicionMenor = 0;

for i = 1:size(estadistica, 1)
    % Compara el perímetro actual con el perímetro mayor encontrado hasta ahora
    if estadistica(i).Perimeter > perimetroMayor
        perimetroMayor = estadistica(i).Perimeter; % Actualiza el perímetro mayor
        posicionMayor = i; % Actualiza la posición del perímetro mayor
    end
    if estadistica(i).Perimeter < perimetroMenor
        perimetroMenor = estadistica(i).Perimeter; % Actualiza el perímetro menor
        posicionMenor = i; % Actualiza la posición del perímetro menor
    end
end

% Muestra el perímetro mayor y menor
disp(['El perímetro mayor es: ', num2str(perimetroMayor)]);
disp(['La posición del perímetro mayor es: ', num2str(posicionMayor)]);
disp(['El perímetro menor es: ', num2str(perimetroMenor)]);
disp(['La posición del perímetro menor es: ', num2str(posicionMenor)]);
disp(['Número total de granos de café detectados: ', num2str(cantidad)]);

figure()
imshow(im_resized)
hold on
% Dibujar el bounding box para cada región detectada
for i = 1:size(estadistica, 1)
    rectangle('Position', estadistica(i).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2)
end
% Dibujar el bounding box para el perímetro mayor en rojo y el menor en azul
rectangle('Position', estadistica(posicionMayor).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2)
rectangle('Position', estadistica(posicionMenor).BoundingBox, 'EdgeColor', 'b', 'LineWidth', 2)
plot(centroids(:, 1), centroids(:, 2), 'b*')
hold off
