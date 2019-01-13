function  copy_vars( ncInID,ncOutID,varargin )
%% Copying Variables and their local attributes from ncInID to ncOutID

        disp('|>------Copying Variables from Source to Target NetCDF File')

%% Handling Argument List for Specified Variables

        if size(varargin,2) == 0
                [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncInID);
                nvars = 0:1:nvars-1;
                %disp(nvars)
        elseif size(varargin,2) == 1
            nvars = [];
            for da = 1:length(varargin{1,1})
                if ischar(cell2mat(varargin{1,1}(da)))
                    nvars(da) = netcdf.inqVarID(ncInID,cell2mat(varargin{1,1}(da)));                  
                elseif isnumeric(cell2mat(varargin{1,1}(da)))
                    nvars(da) = cell2mat(varargin{1,1}(da));
                else
                    disp('Only string or numeric type wrapped in cells are allowes');
                    quit cancel;
                end
            end
        else
            disp('Argument list is not valid');
            quit cancel;
        end
 %% %%%%%%%%%%%%% Defining Variables and their local attributes
        
        for vars = 1:length(nvars)
            
            %%%%% Read Variables from input
            [varname,xtype,dimids,natts] = netcdf.inqVar(ncInID,nvars(vars));
            %[noFillMode,fillValue] = netcdf.inqVarFill(ncInID,vars);
            disp(strcat('Copying-->',varname))
            for d = 1:length(dimids)
            [dimname, dimlen] = netcdf.inqDim(ncInID,dimids(d));
            dimids(d) = netcdf.inqDimID(ncOutID,dimname);
            end
            ncOutVarID = netcdf.defVar(ncOutID,varname,xtype,dimids);
            %netcdf.defVarFill(ncInID,ncOutVarID,noFillMode,fillValue);
            
            for atts = 0:natts-1
%                   print(natts)
                  attname = netcdf.inqAttName(ncInID,ncOutVarID,atts);
                  attvalue = netcdf.getAtt(ncInID,ncOutVarID,attname);
                  netcdf.putAtt(ncOutID,ncOutVarID,attname,attvalue)
%                 netcdf.copyAtt(ncInID,nvars(vars),attname,ncOutID,ncOutVarID);
            end
            
        end
        
        disp('|>--------Copying Process has been Completed')


end

