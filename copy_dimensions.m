function copy_dimensions( ncInID,ncOutID,varargin)
%% Copy Dimensions from ncInID to ncOutID

disp('|>------Copying Dimension from Source to Target NetCDF File')
    
%% 
        
        [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncInID);
        if size(varargin,2) == 0
            ndims = 0:1:ndims-1;
        elseif size(varargin,2) == 1 || size(varargin,2) == 2
            ndims = [];
            for da = 1:length(varargin{1,1})
                if ischar(cell2mat(varargin{1,1}(da)))
                    ndims(da) = netcdf.inqDimID(ncInID,cell2mat(varargin{1,1}(da)));
                elseif isnumeric(cell2mat(varargin{1,1}(da)))
                    ndims(da) = cell2mat(varargin{1,1}(da));
                else
                    disp('Only string or numeric type wrapped in cells are allowes');
                    %exit();
                end
            end

        else
            disp('Argument list is not valid');
            %exit();
        end
   
         disp(ndims)  
        %netcdf.reDef(ncOutID)
        
        %% %%%%%%%%%%%%% For defining dimensions
        for dims = 1:length(ndims)           
            [dimname, dimlen] = netcdf.inqDim(ncInID,ndims(dims));
            if size(varargin,2) == 2 && ischar(cell2mat(varargin{1,2}(dims)))
                dimname = cell2mat(varargin{1,2}(dims));
            end
            if dims == unlimdimid+1
                try
                    %dimid = netcdf.defDim(ncOutID,dimname,dimlen);
                    dimid = netcdf.defDim(ncOutID,dimname,netcdf.getConstant('NC_UNLIMITED'));
                catch ex
                    disp(ex.identifier)
                    disp(strcat('|>--Dimension may already exist with the same name:',dimname))
                    continue;
                end
            else  
                try
                    dimid = netcdf.defDim(ncOutID,dimname,dimlen);
                catch ex
                    disp(ex.identifier)
                    disp(strcat('|>--Dimension may already exist with the same name:',dimname))
                    continue;
                end
            end
        end
        clear('dimid');

        disp('|>--------Copying Process has been Completed')
     
end

