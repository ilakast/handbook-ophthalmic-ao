%FN_AVERAGE_WAVEFRONT_GRADIENT_SYM_INTEGRATION calculates the average x- 
%   and y-gradients of Zernike polynomials over polygons, inscribed within 
%   a square grid of square-shaped lenlets with a 100% fill factor using 
%   exact symbolic calculations.
%
% Syntax: 
%   [calculated_wavefront_gradient_x,                                   ...
%    calculated_wavefront_gradient_y]                                   ...
%                       = fn_average_wavefront_gradient_sym_integration(...
%                                 sym_Cartesian_Zernike_polynomial,     ...
%                                 column_lenslet_centers_in_pupil_units,...
%                                 row_lenslet_centers_in_pupil_units,   ...
%                                 lenslet_radius_pupil_units, x, y)
%   where, sym_Cartesian_Zernike_polynomial is the symbolic Matlab
%   expression for a Zernike polynomial defined in terms of 'x' and 'y'.
%   column_lenslet_centers_in_pupil_units and 
%   row_lenslet_centers_in_pupil_units are the column and row lenslet
%   centers in units of the pupil radius. 
%   lenslet_radius_pupil_units is the lenslet radius in pupil radius units.

function [calculated_wavefront_gradient_x,                              ...
          calculated_wavefront_gradient_y]                              ...
            = fn_average_wavefront_gradient_sym_integration(            ...
                    sym_Cartesian_Zernike_polynomial,                   ...
                    column_lenslet_centers_in_pupil_units,              ...
                    row_lenslet_centers_in_pupil_units,                 ...
                    lenslet_radius_pupil_units, x, y)

% Define function that reads the input variables of an anonymous function
afn_read_input_variables        = @(f) strsplit(regexp(func2str(f),     ...
                                         '(?<=^@\()[^\)]*', 'match',    ...
                                         'once'), ',');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                     

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Expressions for integrating the wavefront to calculate gradients %%%%
    % see Reference: A. Dubra, Opt Express 15(6) 2017.
    sym_W_integral_wrt_x            = int(                              ...
                                      sym_Cartesian_Zernike_polynomial, x);
    sym_W_integral_wrt_y            = int(                              ...
                                      sym_Cartesian_Zernike_polynomial, y);

    afn_W_integral_wrt_x            = matlabFunction(sym_W_integral_wrt_x);
    afn_W_integral_wrt_y            = matlabFunction(sym_W_integral_wrt_y);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Lenslet_Column_Min_Coordinates = column_lenslet_centers_in_pupil_units  ...
                                   - lenslet_radius_pupil_units;
    Lenslet_Row_Min_Coordinates    = row_lenslet_centers_in_pupil_units ...
                                   - lenslet_radius_pupil_units;
                               
    Lenslet_Column_Max_Coordinates = column_lenslet_centers_in_pupil_units  ...
                                   + lenslet_radius_pupil_units;
    Lenslet_Row_Max_Coordinates    = row_lenslet_centers_in_pupil_units ...
                                   + lenslet_radius_pupil_units;
                                    
    % Calculated wavefront gradients %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin(afn_W_integral_wrt_y) == 1
       if char(afn_read_input_variables(afn_W_integral_wrt_y)) == 'x'
            calculated_wavefront_gradient_x                                 ...
                = ((afn_W_integral_wrt_y(Lenslet_Column_Max_Coordinates)    ...
                  - afn_W_integral_wrt_y(Lenslet_Column_Max_Coordinates)) - ...
                   (afn_W_integral_wrt_y(Lenslet_Column_Min_Coordinates)  - ...
                    afn_W_integral_wrt_y(Lenslet_Column_Min_Coordinates)))  ...
                   ./(lenslet_radius_pupil_units*2)^2;
       elseif char(afn_read_input_variables(afn_W_integral_wrt_y)) == 'y'
           calculated_wavefront_gradient_x                              ...
               = ((afn_W_integral_wrt_y(Lenslet_Row_Max_Coordinates)    ...
                 - afn_W_integral_wrt_y(Lenslet_Row_Min_Coordinates)) - ...
                  (afn_W_integral_wrt_y(Lenslet_Row_Max_Coordinates)  - ...
                   afn_W_integral_wrt_y(Lenslet_Row_Min_Coordinates)))  ...
                   ./(lenslet_radius_pupil_units*2)^2;
       end
    else
            calculated_wavefront_gradient_x                             ...
               = ((afn_W_integral_wrt_y(Lenslet_Column_Max_Coordinates, ...
                                        Lenslet_Row_Max_Coordinates)    ...
                 - afn_W_integral_wrt_y(Lenslet_Column_Max_Coordinates, ...
                                        Lenslet_Row_Min_Coordinates)) - ...
                  (afn_W_integral_wrt_y(Lenslet_Column_Min_Coordinates, ...
                                        Lenslet_Row_Max_Coordinates)  - ...
                   afn_W_integral_wrt_y(Lenslet_Column_Min_Coordinates, ...
                                        Lenslet_Row_Min_Coordinates)))  ...
                   ./(lenslet_radius_pupil_units*2)^2;
    end

    if nargin(afn_W_integral_wrt_x) == 1
       if char(afn_read_input_variables(afn_W_integral_wrt_x)) == 'x'

           calculated_wavefront_gradient_y                                 ...
               = ((afn_W_integral_wrt_x(Lenslet_Column_Max_Coordinates)    ...
                 - afn_W_integral_wrt_x(Lenslet_Column_Min_Coordinates)) - ...
                  (afn_W_integral_wrt_x(Lenslet_Column_Max_Coordinates)  - ...
                   afn_W_integral_wrt_x(Lenslet_Column_Min_Coordinates)))  ...
                   ./(lenslet_radius_pupil_units*2)^2;
       elseif char(afn_read_input_variables(afn_W_integral_wrt_x)) == 'y'
           calculated_wavefront_gradient_y                              ...
               = ((afn_W_integral_wrt_x(Lenslet_Row_Max_Coordinates)    ...
                 - afn_W_integral_wrt_x(Lenslet_Row_Max_Coordinates)) - ...
                  (afn_W_integral_wrt_x(Lenslet_Row_Min_Coordinates)  - ...
                   afn_W_integral_wrt_x(Lenslet_Row_Min_Coordinates)))  ...
                    ./(lenslet_radius_pupil_units*2)^2;
       end
    else
           calculated_wavefront_gradient_y                              ...
               = ((afn_W_integral_wrt_x(Lenslet_Column_Max_Coordinates, ...
                                        Lenslet_Row_Max_Coordinates)    ...
                 - afn_W_integral_wrt_x(Lenslet_Column_Min_Coordinates, ...
                                        Lenslet_Row_Max_Coordinates)) - ...
                  (afn_W_integral_wrt_x(Lenslet_Column_Max_Coordinates, ...
                                        Lenslet_Row_Min_Coordinates)  - ...
                   afn_W_integral_wrt_x(Lenslet_Column_Min_Coordinates, ...
                                        Lenslet_Row_Min_Coordinates)))  ...
                    ./(lenslet_radius_pupil_units*2)^2;
    end