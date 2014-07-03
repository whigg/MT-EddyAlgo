%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created: 04-Apr-2014 16:53:06
% Computer:  GLNX86
% Matlab:  7.9
% Author:  NK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculates all contours and saves one file per timestep
function S01_contours
    %% init
    DD=initialise('cuts',mfilename);
    %% spmd
    main(DD)
    %% save info
    conclude(DD);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main(DD)
    if DD.debugmode
        spmd_body(DD);
    else
        spmd(DD.threads.num)
            
            spmd_body(DD);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function spmd_body(DD)
    %% loop over ssh cuts
    [TT]=SetThreadVar(DD);  
    for cc=1:numel(TT)
        %% contours
        get_contours(DD,TT(cc));
    end
    disp_progress('conclude');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function II=get_contours(dd,TT)
    %%
    [II,CONT]=init_get_contours(dd,TT);
    %% check
    if exist(CONT.filename,'file')
        dispM([CONT.filename ' exists'])
        return
    end
    %% loop over levels    
    for level=II.levels
        II.T=disp_progress('disp',II.T,numel(II.levels),10);
        CONT.all=[CONT.all; contourc(II.grids.ssh,[level level])'];
    end
    %% save data
    save(CONT.filename,'-struct','CONT');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [II,CONT]=init_get_contours(dd,TT)
    %% load cut
    II.file=TT.files;
    II.grids=getfield(load(II.file),'grids');
    %% calc contours
    dispM('calculating contours... takes long time!',1)
    CONT.all=[]; % init
    %% create level vector at chosen interval
    
    floorlevel=floor(nanmin(II.grids.ssh(:))/dd.contour.step)*dd.contour.step;
    ceillevel=ceil(nanmax(II.grids.ssh(:))/dd.contour.step)*dd.contour.step;
    II.levels=floorlevel:dd.contour.step:ceillevel;
    II.T=disp_progress('init',['contours of day: ' datestr(TT.daynums)]);
    %% add info
    CONT.filename=[dd.path.conts.name dd.pattern.prefix.conts TT.protos];
end