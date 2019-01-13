%%%%%%%%%% To create the netcdf file as the given reference

function copy_netcdf_dump(ncInID,ncOutID)

 
        [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncInID);
        
        %% %%%%%%%%%%%%% For defining dimensions
        for dims = 0:ndims-1           
            [dimname, dimlen] = netcdf.inqDim(ncInID,dims);
            if dims == unlimdimid
                 dimid = netcdf.defDim(ncOutID,dimname,netcdf.getConstant('NC_UNLIMITED'));
            else  
                dimid = netcdf.defDim(ncOutID,dimname,dimlen);
            end
        end
       
        
        %% %%%%%%%%%%%%%%%%% for Defining Groups
        
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
        
        %% %%%%%%%%%%%%% Defining Variables and their local attributes
        
        for vars = 0:nvars-1
            
            %%%%% Read Variables from input
            [varname,xtype,dimids,natts] = netcdf.inqVar(ncInID,vars);
            [noFillMode,fillValue] = netcdf.inqVarFill(ncInID,vars);
    
            ncOutVarID = netcdf.defVar(ncOutID,varname,xtype,dimids);
            %netcdf.defVarFill(ncInID,ncOutVarID,noFillMode,fillValue);
            
            for atts = 0:natts-1             
                attname = netcdf.inqAttName(ncInID,vars,atts);
                netcdf.copyAtt(ncInID,vars,attname,ncOutID,ncOutVarID);
            end
            
        end
        
        %% %%%%%%%%%%%%%%%%% Defining Global Attributes
        for gatts = 0:ngatts-1             
            attname = netcdf.inqAttName(ncInID,netcdf.getConstant('NC_GLOBAL'),gatts);
            netcdf.copyAtt(ncInID,netcdf.getConstant('NC_GLOBAL'),attname,ncOutID,netcdf.getConstant('NC_GLOBAL'));
        end
        
end