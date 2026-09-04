clc
close all
clear

im = imread("monedas1.jpg");

scale_factor = 0.5; % Cambia el factor de escala según lo desees (0.5 reduce al 50%)
im_resized = imresize(im, scale_factor);

% Convertir a escala de grises
im_gray = rgb2gray(im_resized);
im_smooth = imgaussfilt(im_gray, 2);
im_inv = imcomplement(im_smooth);
imbw = im2bw(im_inv, 0.5);

imbw = bwareaopen(imbw,150);

se = strel('disk',5);

imbw = imclose(imbw,se);
estadistica = regionprops(imbw, 'all');

centroids = cat(1, estadistica.Centroid);
cantidad = length(estadistica);

perimetroMayor = 0; % Comienza con un valor 0
posicionMayor = 0; % Inicializa la posición
perimetroMenor = inf;
posicionMenor = 0;

total_value = 0; % Variable para almacenar el valor total de las monedas

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
    
    % Sumar el valor basado en el perímetro
    if estadistica(i).Perimeter > 400
        total_value = total_value + 200;
    elseif estadistica(i).Perimeter >= 380 && estadistica(i).Perimeter <= 395
        total_value = total_value + 100;
    elseif estadistica(i).Perimeter >= 280 && estadistica(i).Perimeter <= 310
        total_value = total_value + 50;
    elseif estadistica(i).Perimeter >= 360 && estadistica(i).Perimeter <= 370
        total_value = total_value + 200;
    end
end

% Muestra el perímetro mayor, menor y el valor total de las monedas
disp(['El perímetro mayor es: ', num2str(perimetroMayor)]);
disp(['La posición del perímetro mayor es: ', num2str(posicionMayor)]);
disp(['El perímetro menor es: ', num2str(perimetroMenor)]);
disp(['La posición del perímetro menor es: ', num2str(posicionMenor)]);
disp(['El valor total de las monedas es: ', num2str(total_value)]);

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
