function [ output_args ] = copy_groups( ncInID,ncOutID )
 %% Copy Groups from ncInID too ncOutID
 
 disp('|>------Copying Group from Source to Target NetCDF File')
     
 %% 
        
        ncInGrp = netcdf.inqGrpName(ncInID);
        if size(ncInGrp,1)==1 && size(ncInGrp,2)==1
            disp('|>---There is no Group Defined in the source File:')
        else
            for ncgrpI = 1:size(ncInGrp,1)
                ncGrps = strsplit(ncInGrp(ncgrpI,:),'/')
                for ncgrpJ = 2:size(ncGrps,2)
                    grpid = netcdf.inqNcid(ncInID,ncGrps(ncgrpJ));
                    if grpid == ncInID
                    GrpID = netcdf.defGrp(ncOutID,ncGrps(ncgrpJ));
                    else
                    GrpID = netcdf.defGrp(ncOutID,ncGrps(ncgrpJ-1));
                    end
                end
            end
        end

disp('|>--------Copying Process has been Completed')
     
end

