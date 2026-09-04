function interfaz_comparar_bordes()
    % Crear la figura de la interfaz
    hFig = figure('Name', 'Comparar Detección de Bordes', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);

    % Crear un botón para cargar la imagen
    uicontrol('Style', 'pushbutton', 'String', 'Cargar Imagen', ...
        'Position', [20, 550, 100, 30], 'Callback', @cargarImagen);

    % Ejes para mostrar la imagen original
    hAxesOriginal = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [50, 400, 300, 150]);
    title(hAxesOriginal, 'Imagen Original');

    % Ejes para mostrar los resultados de detección de bordes
    hAxesMorph = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [50, 200, 300, 150]);
    title(hAxesMorph, 'Bordes Morfológicos');

    hAxesSobel = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [450, 200, 300, 150]);
    title(hAxesSobel, 'Bordes Sobel');

    hAxesCanny = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [450, 400, 300, 150]);
    title(hAxesCanny, 'Bordes Canny');

    % Función para cargar la imagen y comparar los resultados
    function cargarImagen(~, ~)
        [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Imágenes (*.jpg, *.jpeg, *.png, *.bmp)'}, ...
            'Selecciona una imagen');

        if isequal(filename, 0)
            disp('Selección de archivo cancelada');
            return;
        end

        % Leer la imagen
        I = imread(fullfile(pathname, filename));
        I_gray = rgb2gray(I);

        % Mostrar la imagen original
        imshow(I, 'Parent', hAxesOriginal);

        % Detección de bordes usando operaciones morfológicas
        se = strel('disk', 1);
        img_dilated = imdilate(I_gray, se);
        bordes_morph = img_dilated & ~I_gray;

        % Detección de bordes usando Sobel
        bordes_sobel = edge(I_gray, 'sobel');

        % Detección de bordes usando Canny
        bordes_canny = edge(I_gray, 'canny');

        % Mostrar los resultados de detección de bordes
        imshow(bordes_morph, 'Parent', hAxesMorph);
        imshow(bordes_sobel, 'Parent', hAxesSobel);
        imshow(bordes_canny, 'Parent', hAxesCanny);
    end
end
