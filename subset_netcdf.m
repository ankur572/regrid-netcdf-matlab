

function [ ncRefRegFileName ] = subset_netcdf( ncInID,ncRefRegFileName,ncDims,ncDimsRange )

    
    ncRegID = netcdf.create(ncRefRegFileName,'NC_CLOBBER');
    copy_dimensions(ncInID,ncRegID,ncInDimsXY,ncRefDimsXY);
    copy_dimensions(ncRefID,ncRegID);
    copy_groups(ncRefID,ncRegID);
    copy_vars(ncRefID,ncRegID);
    copy_gatts(ncRefID,ncRegID);
    
    
    
    

end
