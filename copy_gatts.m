function copy_gatts( ncInID,ncOutID )
%% Copy Global attributes from ncInID to ncOutID

disp('|>------Copying Global Attributes from Source to Target NetCDF File')
     
%% 

 [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncInID);
 
 %% %%%%%%%%%%%%%%%%% Defining Global Attributes
        for gatts = 0:ngatts-1             
            attname = netcdf.inqAttName(ncInID,netcdf.getConstant('NC_GLOBAL'),gatts);
            netcdf.copyAtt(ncInID,netcdf.getConstant('NC_GLOBAL'),attname,ncOutID,netcdf.getConstant('NC_GLOBAL'));
        end

disp('|>--------Copying Process has been Completed')
     
end

