%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created: 19-Sep-2014 17:39:11
% Computer:  GLNX86
% Matlab:  7.9
% Author:  NK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S09_plotsNew
%     DD=initialise([],mfilename);
%         save DD
         load DD
    ticks.rez=get(0,'ScreenPixelsPerInch');
    ticks.width=800;
    ticks.height=600;
    ticks.y= [-30 0 30];
    ticks.x= 0;
    ticks.age=[1,5*365,10];
    %     ticks.isoper=[DD.thresh.shape.iq,1,10];
    ticks.isoper=[.6,1,10];
    ticks.radius=[50,250,11];
    ticks.radiusStd=[0,150,11];
    ticks.radiusToRo=[1,5,5];
    ticks.amp=[1,20,7];
    %ticks.visits=[0,max([maps.AntiCycs.visitsSingleEddy(:); maps.Cycs.visitsSingleEddy(:)]),5];
    ticks.visits=[1,20,11];
    ticks.visitsunique=[1,10,10];
    ticks.dist=[-1500;500;11];
    %ticks.dist=[-100;50;16];
    ticks.disttot=[1;3000;5];
    ticks.vel=[-30;20;6];
    ticks.axis=[DD.map.out.west DD.map.out.east DD.map.out.south DD.map.out.north];
    ticks.lat=[ticks.axis(3:4),5];
    %     ticks.minMax=cell2mat(extractfield( load([DD.path.analyzed.name, 'vecs.mat']), 'minMax'));
    %%
    main(DD,ticks)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main(DD,T)
    II=initStuff(DD);
    save S09main II DD T
     sub09_scaleStuff
%     sub09_trackstuff
%     sub09_mapStuff
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function II=initStuff(DD)
    II.aut=autumn(100);
    II.win=winter(100);
    II.maps=load([DD.path.analyzed.name, 'maps.mat']);
    II.la=II.maps.Cycs.lat;
    II.lo=II.maps.Cycs.lon;
end
