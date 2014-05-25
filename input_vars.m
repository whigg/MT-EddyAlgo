function U=input_vars
    %% threads
    U.threads.num=12;
    %% time
    U.time.from.str='19941001';
    U.time.till.str='20061001';
% 	 U.time.from.str='19940426';
%     U.time.till.str='19940501';
    U.time.delta_t=1; % [days]!
    %% dirs
%     U.path.TempSalt.name='../TempSalt/';
	 U.path.TempSalt.name='/media/ROM/TempSalt/';
%     U.path.raw.name='/scratch/uni/ifmto/u241194/DAILY/EULERIAN/SSH/';
     U.path.raw.name='/media/ROM/SSH_POP/';
    U.path.root='../dataTINY/';
    U.path.plots='../dataTINY/';
    %% thresholds
    U.contour.step=0.01; % [SI]
    U.thresh.ssh_filter_size=1;
    U.thresh.radius=0; % [SI]
    U.thresh.amp=0.01; % [SI]
    U.thresh.shape.iq=0.1; % isoperimetric quotient
    U.thresh.shape.chelt=0.2; % (diameter of circle with equal area)/(maximum distance between nodes) (if ~switch.IQ)
    U.thresh.corners=6; % min number of data points for the perimeter of an eddy
    U.thresh.dist=.8*24*60^2; % max distance travelled per day
    U.thresh.life=30; % min num of living days for saving
	 U.thresh.rossbySpeedFactor=1.75; % only relevant if cheltons method is used. eddy translation speed assumed factor*rossbyWavePhaseSpeed for tracking projections
    %% dims for map plots
    U.dim.X=10*3+1;
    U.dim.Y=10*3+1;
    U.dim.west=-50;
    U.dim.east=-60;
    U.dim.south=30;
    U.dim.north=40;
    U.dim.NumOfDecimals=1;
    %% switches
    U.switchs.RossbyStuff=false;  % TODO
    U.switchs.IQ=true;
    U.switchs.chelt=false;
    
    %% technical params
    U.RossbyStuff.splits = 25; % number of chunks for brunt väis calculations
    %% fields that must end with .mean and .std - for output plot maps
    U.FieldKeys.MeanStdFields= { ...
        'age';
        'dist.traj.fromBirth';
        'dist.traj.tillDeath';
        'dist.zonal.fromBirth';
        'dist.zonal.tillDeath';
        'dist.merid.fromBirth';
        'dist.merid.tillDeath';
        'radius.mean';
        'radius.zonal';
        'radius.meridional';
        'vel.traj';
        'vel.zonal';
        'vel.merid';
        'amp.to_contour';
        'amp.to_ellipse';
        'amp.to_mean.of_contour';
        };
    
    %% fields 4 colorcoded track plots
    U.FieldKeys.trackPlots= { ...
        'isoper';
        'radius.mean';
        'radius.meridional';
        'radius.zonal';
        %'radius.volume';
        'age';
        'peak.amp.to_contour';
        'peak.amp.to_mean.of_contour';
        'peak.amp.to_ellipse';
        };
    %%
    U.FieldKeys.senses= { ...
        'AntiCycs';
        'Cycs';
        };
end
