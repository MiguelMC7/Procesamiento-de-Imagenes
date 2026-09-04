function interfaz_limpieza_imagen()
    % Crear la figura de la interfaz
    hFig = figure('Name', 'Limpieza de Imagen', 'NumberTitle', 'off', 'Position', [100, 100, 600, 400]);

    % Crear un botón para cargar la imagen
    uicontrol('Style', 'pushbutton', 'String', 'Cargar Imagen', ...
        'Position', [20, 350, 100, 30], 'Callback', @cargarImagen);

    % Ejes para mostrar la imagen original
    hAxesOriginal = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [150, 200, 200, 150]);
    title(hAxesOriginal, 'Imagen Original');

    % Ejes para mostrar la imagen limpiada
    hAxesLimpia = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [400, 200, 200, 150]);
    title(hAxesLimpia, 'Imagen Limpiada');

    % Función para cargar y procesar la imagen
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

        % Procesar la imagen
        img_limpia = limpiarImagen(img);

        % Mostrar la imagen limpiada
        imshow(img_limpia, 'Parent', hAxesLimpia);
    end

    % Función para limpiar la imagen utilizando operaciones morfológicas
    function img_limpia = limpiarImagen(img)
        % Crear el elemento estructurante
        se = strel('disk', 2);  % Disco con radio 2

        % Convertir la imagen a escala de grises si es necesario
        if size(img, 3) == 3  % Imagen a color
            img_gray = rgb2gray(img);
        else
            img_gray = img;  % Ya es en escala de grises
        end

        % Binarizar la imagen usando Otsu
        thresh = graythresh(img_gray);
        img_bw = imbinarize(img_gray, thresh);

        % Limpiar imagen binaria con apertura
        img_limpia_bw = imopen(img_bw, se);

        % Limpiar imagen en escala de grises con apertura y cierre
        img_limpia_gray = imopen(img_gray, se);  % Apertura para eliminar ruido claro
        img_limpia_gray = imclose(img_limpia_gray, se);  % Cierre para eliminar ruido oscuro

        % Limpiar imagen a color (si corresponde)
        if size(img, 3) == 3  % Si es imagen a color
            img_limpia = zeros(size(img), 'like', img);  % Crear una imagen vacía para almacenar el resultado
            for c = 1:3
                % Aplicar apertura y cierre a cada canal de color
                img_limpia(:,:,c) = imopen(img(:,:,c), se);  % Apertura para limpiar ruido claro
                img_limpia(:,:,c) = imclose(img_limpia(:,:,c), se);  % Cierre para limpiar ruido oscuro
            end
        else
            img_limpia = uint8(img_limpia_gray);  % Convertir a uint8 para imagen en escala de grises
        end
    end
end

