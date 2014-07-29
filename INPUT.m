%     templates :
%     'udef'     - user defined in INPUTuserDef.m
%     'pop'      - template for POP SSH data
%     'aviso'    - template for AVISO SSH data
%     'mad'      - template for Madeleine's data

function DD=INPUT
    %%
    DD.template='pop';
    %% threads / debug
    DD.threads.num=1;
    DD.debugmode=false;   
%       DD.debugmode=true;
    %% time
    DD.time.from.str='19940101';
    DD.time.till.str='19950101';
    %% window on globe
    DD.map.in.west=-75;
    DD.map.in.east= -55;
    DD.map.in.south= 25;
    DD.map.in.north= 45;
    %% output map res
    DD.map.out.X=15*1+1; % TODO
    DD.map.out.Y=15*1+1;
    %% thresholds
    DD.contour.step=0.01; % [SI]
    DD.thresh.ssh_filter_size=1;
    DD.thresh.radius=0; % [SI]
    DD.thresh.amp=0.01; % [SI]
    DD.thresh.shape.iq=0.1; % isoperimetric quotient
    DD.thresh.shape.chelt=0.3; % (diameter of circle with equal area)/(maximum distance between nodes) (if ~switch.IQ)
    DD.thresh.corners=8; % min number of data points for the perimeter of an eddy
    DD.thresh.dist=.1*24*60^2; % max distance travelled per day
    DD.thresh.life=3; % min num of living days for saving
    DD.thresh.amArea=[.25 2.5]; % allowable factor between old and new time step for amplitude and area (1/4 and 5/1 ??? chelton)
    %% switches
    DD.switchs.RossbyStuff=false;
    DD.switchs.IQ=true;
    DD.switchs.chelt=false;
    DD.switchs.distlimit=false;
    DD.switchs.AmpAreaCheck=false;
    DD.switchs.netUstuff=false;
    DD.switchs.meanUviaOW=true;
    DD.switchs.spaciallyFilterSSH=false;
    DD.switchs.filterSSHinTime=true;
end