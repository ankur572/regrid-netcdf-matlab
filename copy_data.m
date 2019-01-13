function copy_data( ncInID,ncOutID,varargin )

% Data will be copied from ncInID to ncOutID Netcdf File.
disp('|>------Copying Data from Source to Target NetCDF File')
     
%% 
        disp(size(varargin))
        if size(varargin,2) == 0
                [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncInID);
                clear('ndims'); clear('ngatts'); clear('unlimdimid');
                 nvars = 0:1:nvars-1;
        elseif size(varargin,2) == 1
            nvars = [];
            for da = 1:length(varargin{1,1})
                if ischar(cell2mat(varargin{1,1}(da)))
                    nvars(1,da) = netcdf.inqVarID(ncInID,cell2mat(varargin{1,1}(da)));
                    nvars(2,da) = netcdf.inqVarID(ncOutID,cell2mat(varargin{1,1}(da)));
                elseif isnumeric(cell2mat(varargin{1,1}(da)))
                    nvars(1,da) = cell2mat(varargin{1,1}(da));
                    nvars(2,da) = cell2mat(varargin{1,1}(da));
                else
                    disp('Only string or numeric type wrapped in cells are allowes');
                    %exit();
                end
                disp(nvars)
            end
        elseif size(varargin,2) == 2
            if class(varargin{1,1}) ~= class(varargin{1,2})
                disp('Both arguments variable should be of same class');
                quit cancel;
            end
            nvars = [];
            for da = 1:length(varargin{1,1})
                if ischar(cell2mat(varargin{1,1}(da)))
                    nvars(1,da) = netcdf.inqVarID(ncInID,cell2mat(varargin{1,1}(da)));
                    nvars(2,da) = netcdf.inqVarID(ncOutID,cell2mat(varargin{1,2}(da)));
                elseif isnumeric(cell2mat(varargin{1,1}(da)))
                    nvars(1,da) = cell2mat(varargin{1,1}(da));
                    nvars(2,da) = cell2mat(varargin{1,2}(da));
                else
                    disp('Only string or numeric type wrapped in cells are allowes');
                    %exit();
                end
            end
            disp(nvars)
            disp(length(nvars))
        else
            disp('Argument list is not valid');
            %exit();
        end
        %% 
        
        
         
        %% 
    try
        netcdf.endDef(ncOutID);
    catch
    end
    %% 
    
    %% 
     for vars = 1:size(nvars,2)
            %%%%% Read Variables from input
            [varname,xtype,dimids,natts] = netcdf.inqVar(ncInID,nvars(1,vars));
            ncInVarData = netcdf.getVar(ncInID,nvars(1,vars));
            try
            ncInVarOffset = netcdf.getAtt(ncInID,nvars(1,vars),'add_offset');
            ncInVarscaleF = netcdf.getAtt(ncInID,nvars(1,vars),'scale_factor');
            ncInVarData = double(ncInVarData)*double(ncInVarscaleF) + double(ncInVarOffset);
            catch
            end
            %ncInVarData = double(ncInVarData); %Since interp2 requires input in double
            if size(nvars,1) == 1
                %[varname,xtype,dimids,natts] = netcdf.inqVar(ncInID,nvars(1,vars));
                %disp(varname)
                ncOutVarID = nvars(1,vars);    
            else
                 %[varname,xtype,dimids,natts] = netcdf.inqVar(ncInID,nvars(2,vars));
                ncOutVarID = nvars(2,vars);
            end
            %ncOutVarData = [] ;
            ncOutVarData = netcdf.getVar(ncOutID,ncOutVarID);
            %ncOutVarData = double(ncOutVarData); %Since interp2 requires input in double
            ncOutVarDT = class(netcdf.getVar(ncOutID,ncOutVarID));
%             if ~isempty(dimids)  %&& length(dimids)~=ndims(ncOutVarData)
%                 COUNT_OUT = [];
%                 START = [];
%                 COUNT_IN = [];
% %                 [varname,xtype,dimidout,natts] = netcdf.inqVar(ncOutID,nvars(2,vars));
%                 for c = 1:length(dimids)
%                     COUNT_OUT(c) = size(ncOutVarData,c);
%                     COUNT_IN(c) = size(ncInVarData,c);
%                     START(c) = 0;
% %                     [dim{1,c}, dimlen{1,c}] = netcdf.inqDim(ncInID,dimids(c));
% %                     [dim{2,c}, dimlen{2,c}] = netcdf.inqDim(ncOutID,dimidout(c));
%                 end           
%                 if length(dimids) == 1
%                     ncOutVarData = ncInVarData;
%                 else
%                     for c = 1:length(COUNT_IN)
%                         disp(varname)
%                         permuteInd(c) = find(COUNT_IN==COUNT_OUT(c));
%                     end
%                     ncOutVarData = ncInVarData;
%                     ncOutVarData = permute(ncOutVarData,permuteInd);
%                 end
%             end
            
%             This bolck may be activate but then it will not allow to copy subset of data
%             if eq(size(ncInVarData),size(ncOutVarData))
%                 ncOutVarData = ncInVarData;
%             else
%                 disp('Dimensions must agree to copy data');
%             end
 
            %netcdf.putVar(ncOutID,ncOutVarID,0,1,cast(ncOutVarData,eval('ncOutVarDT')));
           
            if isempty(dimids)
                disp(varname)
                netcdf.putVar(ncOutID,ncOutVarID,cast(ncOutVarData,eval('ncOutVarDT')));
            elseif length(dimids) == 1
                
                ncOutVarData = ncInVarData;
                COUNT = [];
                START = [];
%                 [varname,xtype,dimidout,natts] = netcdf.inqVar(ncOutID,nvars(2,vars));
                for c = 1:length(dimids)
                    COUNT(c) = size(ncOutVarData,c);
                    START(c) = 0;
%                     [dim{1,c}, dimlen{1,c}] = netcdf.inqDim(ncInID,dimids(c));
%                     [dim{2,c}, dimlen{2,c}] = netcdf.inqDim(ncOutID,dimidout(c));
                end
                
                disp(strcat('Populating Data in -->',varname))
%                 %disp(vars)
%                 netcdf.putVar(ncOutID,ncOutVarID,START,COUNT,cast(ncOutVarData,eval('ncOutVarDT'))); 
                netcdf.putVar(ncOutID,ncOutVarID,START,COUNT,cast(ncOutVarData,eval('ncOutVarDT'))); 
%                 delete('START');delete('COUNT');
            else
                COUNT_OUT = [];
                START = [];
                COUNT_IN = [];
%                 [varname,xtype,dimidout,natts] = netcdf.inqVar(ncOutID,nvars(2,vars));
                for c = 1:length(dimids)
                    COUNT_OUT(c) = size(ncOutVarData,c);
                    COUNT_IN(c) = size(ncInVarData,c);
                    START(c) = 0;
%                     [dim{1,c}, dimlen{1,c}] = netcdf.inqDim(ncInID,dimids(c));
%                     [dim{2,c}, dimlen{2,c}] = netcdf.inqDim(ncOutID,dimidout(c));
                end           

                for c = 1:length(COUNT_IN)
                    disp(varname)
                    permuteInd(c) = find(COUNT_IN==COUNT_OUT(c));
                end
                ncOutVarData = ncInVarData;
                ncOutVarData = permute(ncOutVarData,permuteInd);

                %disp(vars)
%                 try
                disp(strcat('Populating Data in -->',varname))
                netcdf.putVar(ncOutID,ncOutVarID,START,COUNT_OUT,cast(ncOutVarData,eval('ncOutVarDT')));
%                 delete('START');delete('COUNT_IN');delete('COUNT_OUT')
%                 catch
%                     netcdf.putVar(ncOutID,ncOutVarID,cast(ncOutVarData,eval('ncOutVarDT')));
%                 end
            end
            %disp(varname)
     end
     %% 

disp('|>--------Copying Process has been Completed')
     

end

