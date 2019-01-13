%%%%%% Swapping the data of Variables in different NetCDF Files


%% %%%%%%%%%%% Define Folder and Files Location
% ncInDir = 'D:\netcdf\Jun2016Simulation\input\';
% ncRefDir = 'D:\netcdf\Jun2016Simulation\reference\';
% ncOutDir = 'D:\netcdf\Jun2016Simulation\output';

ncInDimsXY = {'lon','lat'};
ncRefDimsXY = {'longitude','latitude'};
ncInDimsXYZ = {'lon','lat','lev'};
ncRefDimsXYZ = {'longitude','latitude','level'};


%% 
% 
% ncInfoIN = ncinfo('D:\netcdf\Jun2016Simulation\New folder\cami_1980-01-01_0.47x0.63_L26_c071226.nc');
% ncInfoR2D = ncinfo('D:\netcdf\Jun2016Simulation\reference\_grib2netcdf-atls15-95e2cf679cd58ee9b4db4dd119a05a8d-G1AMWu.nc');
% ncInfoR3D = ncinfo('D:\netcdf\Jun2016Simulation\reference\_grib2netcdf-atls15-95e2cf679cd58ee9b4db4dd119a05a8d-QbcERU.nc');
% ncInfoRG2D = ncinfo('D:\netcdf\Jun2016Simulation\New folder\cami_1987-01-01_0.9x1.25_L26_c060703_ERA_REGRIDDED3D.nc');
% ncInfoRG3D = ncinfo('D:\netcdf\Jun2016Simulation\New folder\_grib2netcdf-atls17-95e2cf679cd58ee9b4db4dd119a05a8d-WIHFnW.nc');

ncInID = netcdf.open('D:\netcdf\Jun2016Simulation\New folder\cami_1980-01-01_0.47x0.63_L26_c071226.nc','NC_WRITE');
ncRegID2 = netcdf.open('D:\netcdf\Jun2016Simulation\New folder\cami_1980-01-01_0.47x0.63_L26_c071226_ERA_REGRIDDED.nc','NC_WRITE');
ncRegID3 = netcdf.open('D:\netcdf\Jun2016Simulation\New folder\cami_1980-01-01_0.47x0.63_L26_c071226_ERA_REGRIDDED3D.nc','NC_WRITE');
ncRefID3 = netcdf.open('D:\netcdf\Jun2016Simulation\reference\_grib2netcdf-atls04-95e2cf679cd58ee9b4db4dd119a05a8d-maj5pU.nc','NC_NOWRITE');

%copy_data(ncRegID2,ncInID,{'sp','sd','skt','sst','istl1','istl2','istl3','istl4'},{'PS','SNOWHICE','TS','TSICE','TS1','TS2','TS3','TS4'});
copy_data(ncRegID2,ncInID,{'sp','sd','stl1','stl2','stl3','stl4'},{'PS','SNOWHICE','TS1','TS2','TS3','TS4'});

copy_data(ncRegID3,ncInID,{'t','q'},{'T','Q'});

netcdf.close(ncRegID2)
netcdf.close(ncRegID3)

ncInDimsXYZ = {'lon','slat','lev'};
cd('D:\netcdf\Jun2016Simulation\New folder\')
ncRefRegFileName = 'ERA_Ref_3D_3DREGRIDDED_US.nc';
regrid3_netcdf( ncInID,ncRefID3,ncRefRegFileName,ncInDimsXYZ,ncRefDimsXYZ,0,0,0)
ncRegID3 = netcdf.open(ncRefRegFileName,'NC_WRITE');
copy_data(ncRegID3,ncInID,{'u'},{'US'});

ncInDimsXYZ = {'slon','lat','lev'};
cd('D:\netcdf\Jun2016Simulation\New folder\')
ncRefRegFileName = 'ERA_Ref_3D_3DREGRIDDED_VS.nc';
regrid3_netcdf( ncInID,ncRefID3,ncRefRegFileName,ncInDimsXYZ,ncRefDimsXYZ,0,0,0)
ncRegID3 = netcdf.open(ncRefRegFileName,'NC_WRITE');
copy_data(ncRegID3,ncInID,{'v'},{'VS'});


netcdf.close(ncRegID3)
netcdf.close(ncInID)
netcdf.close(ncRefID3)
