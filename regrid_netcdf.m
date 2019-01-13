
function [ ncRefRegFileName ] = regrid_netcdf( ncInID,ncRefID,ncRefRegFileName,ncInDimsXY,ncRefDimsXY,varargin )
%% Regridding the NetCDF File (ncRefID) using the given ncInID
% ncInDimsXY ---> Dimensions that are used for regridding
% ncRefDimsXY---> Dimensions that are to be regridded as of ncInDimsXY
% ncRefRegFileName--->Output Regridded Filename
% varargin ---> three inputs can be given as flip parameters for X and Y whether
% dimensions required to be flipped before regridding.
% ncInID----> Input File used for fetching regridding parameters
% ncRefID---> File to be regridded
% 
         disp('|>------Regrdding NetCDF File')

%% Variable argument list (Inputs are not in cell format so cell2mat is not required to read)
        if size(varargin,2) == 0
            flipX = 0;
            flipY = 0;
%             flipZ = 0;
        elseif size(varargin,2) == 1
            flipX = varargin{1,1}(1);
            flipY = 0;
%             flipZ = 0
        elseif size(varargin,2) == 2
            flipX = varargin{1,1}(1);
            flipY = varargin{1,2}(1);
%             flipZ = 0;
%         elseif size(varargin,2) == 3
%             flipX = varargin{1,1}(1);
%             flipY = varargin{1,2}(1);
%             flipZ = varargin{1,3}(1);
        else
            disp('Argument list is not valid');
            quit cancel;
        end
        %% 
        
        %% Retrieving the value of regridding dimensions
        
        ncInXid = netcdf.inqVarID(ncInID,char(ncInDimsXY(1)));
        ncInXdata = netcdf.getVar(ncInID,ncInXid);
        ncInYid = netcdf.inqVarID(ncInID,char(ncInDimsXY(2)));
        ncInYdata = netcdf.getVar(ncInID,ncInYid);
        %ncInDX = ncInXdata(2)-ncInXdata(1);
        %ncInDY = ncInYdata(2)-ncInYdata(1);
        %ncInMinX = min(ncInXdata);
        %ncInMaxX = max(ncInXdata);
        %ncInMinY = min(ncInYdata);
        %ncInMaxY = max(ncInYdata);

        ncRefXid = netcdf.inqVarID(ncRefID,char(ncRefDimsXY(1)));
        ncRefXdata = netcdf.getVar(ncRefID,ncRefXid);
        ncRefYid = netcdf.inqVarID(ncRefID,char(ncRefDimsXY(2)));
        ncRefYdata = netcdf.getVar(ncRefID,ncRefYid);
        %ncRefDX = ncRefXdata(2)-ncRefXdata(1);
        %ncRefDY = ncRefYdata(2)-ncRefYdata(1);
        %ncRefMinX = min(ncReXdata);
        %ncRefMaxX = max(ncRefXdata);
        %ncRefMinY = min(ncRefYdata);
        %ncRefMaxY = max(ncRefYdata);
        %% 
        %% If any flipping is required in any of dimension used for regridding
        
        if flipX
            ncRefXdata = flipud(ncRefXdata);
        end
        if flipY
            ncRefYdata = flipud(ncRefYdata);
        end
%         if flipZ
%             ncRefZdata = flipud(ncRefZdata);
%         end
        %% 


        %% 
        [ncInY,ncInX] = meshgrid(ncInYdata,ncInXdata);
        [ncRefY,ncRefX] = meshgrid(ncRefYdata,ncRefXdata);
        %ncInX = double(ncInX);
        %ncInY = double(ncInY);
        %ncRefX = double(ncRefX);
        %ncRefY = double(ncRefY);

        netcdf.setDefaultFormat(netcdf.inqFormat(ncRefID))
%         [pathstr,ncRefRegFile] = fileparts(pwd);
%         cd(pathstr)
%         ncRefRegFileName = strcat(ncRefRegFile,'REGRIDDED.nc');
        ncRegID = netcdf.create(ncRefRegFileName,'NC_CLOBBER');
        copy_dimensions(ncInID,ncRegID,ncInDimsXY,ncRefDimsXY);
        copy_dimensions(ncRefID,ncRegID);
        copy_groups(ncRefID,ncRegID);
        copy_vars(ncRefID,ncRegID);
        copy_gatts(ncRefID,ncRegID);

        [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncRefID);
        clear('ndims'); clear('ngatts');
        %% 

        netcdf.endDef(ncRegID);
        
        %% 

         for vars = 0:nvars-1
                %%%%% Read Variables from input
                [varname,xtype,dimids,natts] = netcdf.inqVar(ncRefID,vars);
                RefVarData = netcdf.getVar(ncRefID,vars);
                RefVarData = double(RefVarData); %Since interp2 requires input in double
                RegVarID = netcdf.inqVarID(ncRegID,varname);
                %RegVarData = zeros(size(netcdf.getVar(ncRegID,RegVarID)));
                disp(vars)
                RegVarData = repmat([],(1:1:length(dimids))*0);
                RegVarDT = class(netcdf.getVar(ncRegID,RegVarID));
                
                disp('gaya ki ni')
                if length(dimids)>1
                    if flipX
                        for y = 1:size(RefVarData,2)
                            for z = 1:size(RefVarData,3)
                                RefVarData(:,y,z) = flipud(RefVarData(:,y,z));
                            end
                        end
                    end
                    disp('More Than One')
                    if flipY                        
                        for x = 1:size(RefVarData,2)
                            for z = 1:size(RefVarData,3)
                                disp('flipping')
                                RefVarData(x,:,z) = flipud(RefVarData(x,:,z));
                            end
                        end
                    end                                    
                end
               disp('patah chala')
%                 if eq(size(RefVarData),size(RegVarData))
%                     RegVarData = RefVarData;
%                 else
                    if length(dimids) == 1
                        disp(strcat('dimids1 =:',num2str(dimids),'Vars =: ',num2str(vars)));
                        if strcmp(varname,ncRefDimsXY(1))
                            RegVarData = ncInXdata;
                        elseif strcmp(varname,ncRefDimsXY(2))
                            RegVarData = ncInYdata;
                        else
                            RegVarData = RefVarData;
                        end
                    elseif length(dimids) == 2
                        disp(strcat('dimids2 =:',num2str(dimids),'Vars =: ',num2str(vars)));    
                        RegVarData(:,:) = interp2(ncRefY,ncRefX,RefVarData(:,:),ncInY,ncInX,'spline'); 
                    elseif length(dimids) == 3
                        disp(strcat('dimids3 =:',num2str(dimids),'Vars =: ',num2str(vars))); 
                        for time = 1:size(RefVarData,3)
                            disp(time)                                     
                            RegVarData(:,:,time) = interp2(ncRefY,ncRefX,RefVarData(:,:,time),ncInY,ncInX,'spline');                                     
                        end
                    elseif length(dimids) == 4
                        disp(strcat('dimids4 =:',num2str(dimids),'Vars =: ',num2str(vars))); 
                        for time = 1:size(RefVarData,4)
                            for level = 1:size(RefVarData,3)
                                RegVarData(:,:,level,time) = interp2(ncRefY,ncRefX,RefVarData(:,:,level,time),ncInY,ncInX,'spline');
                            end
                        end
                    end  
%                 end
                
                if ~isempty(dimids) %&& length(dimids)~=ndims(ncOutVarData)
                    COUNT = [];
                    START = [];
                    for c = 1:length(dimids)
                        COUNT(c) = size(RegVarData,c);
                        START(c) = 0;
                    end
                end
                disp(COUNT)
                disp(START)
                if isempty(dimids)
                    disp('dimids is empty')
                    netcdf.putVar(ncRegID,RegVarID,cast(RegVarData,eval('RegVarDT')));
%                 elseif length(dimids) == 1
%                     disp(vars)
%                     netcdf.putVar(ncRegID,RegVarID,START,COUNT,cast(RegVarData,eval('RegVarDT'))); 
                    %netcdf.putVar(ncRegID,RegVarID,cast(RegVarData,eval('RegVarDT'))); 
                else
                    disp(varname)
                    netcdf.putVar(ncRegID,RegVarID,START,COUNT,cast(RegVarData,eval('RegVarDT')));
                end
                %disp(varname)
                
%                 if length(dimids) == 1
%                     netcdf.putVar(ncRegID,RegVarID,(dimids*0),length(RegVarData),cast(RegVarData,eval('RegVarDT'))); 
%                 else
%                     netcdf.putVar(ncRegID,RegVarID,(dimids*0),size(RegVarData),cast(RegVarData,eval('RegVarDT')));
%                 end
         end
         %% 
                %else
                 %   disp('|>---- Please check the file.. There must be a variable of more the 4 dimension..Ignoring it');
              %  end
              %  netcdf.putVar(ncRegID,RegVarID,RegVarData);

               % end
         %end
        netcdf.close(ncRegID);
         disp('|>--------Regrdding Process has been Completed')
end

