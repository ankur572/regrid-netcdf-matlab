%%%%%%%%%% To create the netcdf file as the given reference

function copy_netcdf(ncInID,ncOutFileSrc)
%% Copy NetCDF file aa ncInID to the given file location with name

        disp('|>---Copying NetCDF File')
     
%% 
        
        [pathstr,Fname] = fileparts(ncOutFileSrc);
        cd(pathstr);
        ncOutFile = strcat(Fname,'COPY.nc');
        netcdf.setDefaultFormat(netcdf.inqFormat(ncInID))
        ncOutID = netcdf.create(ncOutFile,'NC_CLOBBER');

        %% %%%%%%%%%%%%%%%%% for Defining Dimensions
        disp('|>-----Copying Dimensions')
        copy_dimensions( ncInID,ncOutID )
       
        %% %%%%%%%%%%%%%%%%% for Defining Groups
        disp('|>-----Copying Groups')
        copy_groups( ncInID,ncOutID )

        %% %%%%%%%%%%%%% Defining Variables and their local attributes
        disp('|>-----Copying Variables')
        copy_vars( ncInID,ncOutID )
        
        %% %%%%%%%%%%%%%%%%% Defining Global Attributes
        disp('|>-----Copying Global Attributes')
        copy_gatts( ncInID,ncOutID )
        
        %% %%%%%%%%%%%%%%%%% Copy Data of Variables 
        disp('|>-----Copying Data')
        copy_data( ncInID,ncOutID )

        netcdf.close(ncOutID);
        disp('|>---NetCDF File has been Copied Successfully')
     
end