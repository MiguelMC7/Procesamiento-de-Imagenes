function interfaz_cargar_hit_or_miss()
    % Crear la figura de la interfaz
    hFig = figure('Name', 'Cargar y Aplicar Hit-or-Miss', 'NumberTitle', 'off', 'Position', [100, 100, 600, 400]);

    % Crear un botón para cargar la imagen
    uicontrol('Style', 'pushbutton', 'String', 'Cargar Imagen', ...
        'Position', [20, 380, 100, 30], 'Callback', @cargarImagen);

    % Ejes para mostrar la imagen original
    hAxesOriginal = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [50, 200, 200, 150]);
    title(hAxesOriginal, 'Imagen Original');

    % Ejes para mostrar la imagen con Hit-or-Miss
    hAxesHitOrMiss = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [350, 200, 200, 150]);
    title(hAxesHitOrMiss, 'Hit-or-Miss');

    % Función para cargar la imagen y aplicar Hit-or-Miss
    function cargarImagen(~, ~)
        [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Imágenes (*.jpg, *.jpeg, *.png, *.bmp)'}, ...
            'Selecciona una imagen');

        if isequal(filename, 0)
            disp('Selección de archivo cancelada');
            return;
        end

        % Leer la imagen
        img = imread(fullfile(pathname, filename));

        % Mostrar la imagen original
        imshow(img, 'Parent', hAxesOriginal);

        % Convertir la imagen a escala de grises si es necesario
        if size(img, 3) == 3
            img = rgb2gray(img);
        end

        % Verificar si la imagen está en escala de grises
        if max(img(:)) > 1
            img = imbinarize(img / 255, 'global');
        else
            img = imbinarize(img, 'global');
        end

        % Mostrar la imagen binaria
        figure;
        imshow(img), title('Imagen Binaria');

        % Definir los elementos estructurantes para el Hit-or-Miss
        se1 = [0 0 0; 1 1 0; 0 0 0];
        se2 = [1 1 1; 0 0 1; 1 1 1];

        % Aplicar la operación Hit-or-Miss
        hit_miss = bwhitmiss(img, se1, se2);

        % Mostrar la imagen resultante de Hit-or-Miss
        imshow(hit_miss, 'Parent', hAxesHitOrMiss);

        % Guardar la imagen resultante
        imwrite(hit_miss, fullfile(pathname, 'imagen_hit_or_miss.png'));
    end
end
