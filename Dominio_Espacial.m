function gui_umbralizacion_normalizada
    % Crear la ventana principal
    fig = uifigure('Name', 'Umbralización de Imágenes Normalizadas', 'Position', [100, 100, 800, 400]);

    % Botón para cargar la imagen
    btn = uibutton(fig, 'push', 'Text', 'Cargar Imagen', 'Position', [50, 350, 100, 30], 'ButtonPushedFcn', @(btn,event) cargarImagen(fig));

    % Etiqueta para el control deslizante del umbral
    uilabel(fig, 'Position', [200, 350, 120, 30], 'Text', 'Ajusta el umbral:');
    
    % Control deslizante para el umbral (en el rango de 0 a 1 para imágenes normalizadas)
    slider = uislider(fig, 'Position', [330, 360, 300, 3], 'Limits', [0 1], 'Value', 0.5);
    slider.ValueChangedFcn = @(slider, event) aplicarUmbral(fig, slider.Value);
    
    % Crear espacio para mostrar las imágenes
    ax1 = uiaxes(fig, 'Position', [50, 50, 300, 280]);
    title(ax1, 'Imagen Original');
    
    ax2 = uiaxes(fig, 'Position', [400, 50, 300, 280]);
    title(ax2, 'Imagen Umbralizada');
    
    % Almacenar los ejes en la figura para referencia
    fig.UserData.ax1 = ax1;
    fig.UserData.ax2 = ax2;
    fig.UserData.slider = slider;
end

function cargarImagen(fig)
    % Función para cargar la imagen
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

        % Normalizar la imagen (valores entre 0 y 1)
        imagen_gris = im2double(imagen_gris);
        
        % Mostrar la imagen original en el primer eje
        ax1 = fig.UserData.ax1;
        imshow(imagen_gris, 'Parent', ax1);

        % Almacenar la imagen en los datos de la figura para usarla más adelante
        fig.UserData.imagen_gris = imagen_gris;
        
        % Aplicar umbral con el valor actual del slider
        aplicarUmbral(fig, fig.UserData.slider.Value);
    end
end

function aplicarUmbral(fig, umbral)
    % Función para aplicar la umbralización a la imagen
    if isfield(fig.UserData, 'imagen_gris')
        imagen_gris = fig.UserData.imagen_gris;

        % Binarizar la imagen con el umbral seleccionado
        imagen_binaria = imagen_gris > umbral;

        % Mostrar la imagen umbralizada en el segundo eje
        ax2 = fig.UserData.ax2;
        imshow(imagen_binaria, 'Parent', ax2);
        
        % Actualizar el título con el valor del umbral
        title(ax2, ['Imagen Umbralizada (Umbral: ', num2str(umbral), ')']);
    else
        disp('Cargar una imagen primero.');
    end
end

