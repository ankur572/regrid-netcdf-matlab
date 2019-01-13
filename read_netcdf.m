%%%%%% Program Created By:
%%%%%% ANKUR DIXIT
%%%Copyright © All rights reserved


%% %%%%%%%%%%% Define Folder and Files Location
ncInDir = 'D:\netcdf\Jun2016Simulation\input\';
ncRefDir = 'D:\netcdf\Jun2016Simulation\reference\';
ncOutDir = 'D:\netcdf\Jun2016Simulation\output';

ncInDimsXY = {'lon','lat'};
ncRefDimsXY = {'longitude','latitude'};
ncInDimsXYZ = {'lon','lat','lev'};
ncRefDimsXYZ = {'longitude','latitude','level'};
% ncInDims2Copy = {'lon','lat','slon','slat'};

ncInFileList = dir(ncInDir);
ncRefFileList = dir(ncRefDir);

%% 

for i = 3:size(ncInFileList)
    
    ncInFile =  fullfile(ncInDir,ncInFileList(i).name);
    
    for j = 3:size(ncRefFileList)
        
        ncRefFile = fullfile(ncRefDir,ncRefFileList(j).name);
        
        ncOutFile = ncInFileList(i).name;

        ncInInfo  = ncinfo(ncInFile);
        ncRefInfo = ncinfo(ncRefFile); 
        
        ncInID = netcdf.open(ncInFile,'NC_NOWRITE');
        ncRefID = netcdf.open(ncRefFile,'NC_NOWRITE');
        
        mkdir(ncOutDir,ncRefFileList(j).name)
        ncOutFileDir = fullfile(ncOutDir,ncRefFileList(j).name);
        ncOutFileSrc = fullfile(ncOutFileDir,ncOutFile);
        
        disp('|>- Ready to Copy NetCDF File')
        %copy_netcdf(ncInID,ncOutFileSrc); %%%%%% Create copy of netcdf for output
        disp('|>- NetCDF File has been copied')
        
        %[pathstr,ncRefRegFile] = fileparts(fullfile(ncOutDir,ncRefFileList(j).name));
        [pathstr,ncRefRegFile] = fileparts(ncInFile);
        cd(fullfile(ncOutDir,ncRefFileList(j).name))
               
        if j == 3
            disp('|>- Regridding the Reference Data')
            ncRefRegFileName = strcat(ncRefRegFile,'_ERA_REGRIDDED.nc');
            ncRegSrc = regrid_netcdf( ncInID,ncRefID,ncRefRegFileName,ncInDimsXY,ncRefDimsXY,0,0 );
            disp('|>- Regridding has been successfully done')
        elseif j == 4
            disp('|>- Regridding the Reference Data')
            ncRefRegFileName = strcat(ncRefRegFile,'_ERA_REGRIDDED3D.nc');
            ncRegSrc = regrid3_netcdf( ncInID,ncRefID,ncRefRegFileName,ncInDimsXYZ,ncRefDimsXYZ,0,0,0 );
            disp('|>- Regridding has been successfully done')
        end

       netcdf.close(ncRefID)   

    end
    
     netcdf.close(ncInID)
    
end
  
        disp('HO RAHAAAAAAAAAAAAAAAAAAAAAAAAAAA HAI')
        %copy_data(ncRegID,ncInID);
