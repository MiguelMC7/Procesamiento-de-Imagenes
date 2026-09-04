function interfaz_detectar_fisura()
    % Crear la figura de la interfaz
    hFig = figure('Name', 'Detección de Fisura en Hueso', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);

    % Crear un botón para cargar la imagen
    uicontrol('Style', 'pushbutton', 'String', 'Cargar Imagen', ...
        'Position', [20, 550, 100, 30], 'Callback', @cargarImagen);

    % Ejes para mostrar la imagen original
    hAxesOriginal = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [50, 250, 300, 300]);
    title(hAxesOriginal, 'Imagen Original');

    % Ejes para mostrar la imagen con fisura resaltada
    hAxesFisura = axes('Parent', hFig, 'Units', 'pixels', ...
        'Position', [450, 250, 300, 300]);
    title(hAxesFisura, 'Fisura Resaltada');

    % Función para cargar la imagen y detectar la fisura
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

        % Seleccionar el área afectada con roipoly
        figure, imshow(I_gray);
        title('Seleccione el área afectada con roipoly');
        mask = roipoly;
        close;

        % Aplicar la máscara seleccionada a la imagen original
        I_crop = I_gray .* uint8(mask);

        % Aplicar un filtro de Sobel para detectar bordes en el área seleccionada
        edges = edge(I_crop, 'sobel');

        % Aplicar operaciones morfológicas para resaltar la fisura
        se = strel('disk', 2);
        dilated = imdilate(edges, se);
        filled = imfill(dilated, 'holes');
        eroded = imerode(filled, se);

        % Crear una imagen en color para resaltar la fisura en rojo
        I_color = repmat(I_gray, [1 1 3]);
        I_color(:,:,1) = I_color(:,:,1) + uint8(255 * eroded);
        I_color(:,:,2) = I_color(:,:,2) .* uint8(~eroded);
        I_color(:,:,3) = I_color(:,:,3) .* uint8(~eroded);

        % Mostrar la imagen con la fisura resaltada
        imshow(I_color, 'Parent', hAxesFisura);

        % Guardar la imagen resultante
        imwrite(I_color, fullfile(pathname, 'fisura_resaltada.png'));
    end
end



